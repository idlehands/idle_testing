defmodule IdleTesting.UserTest do
  use IdleTesting.SchemaCase
  alias IdleTesting.User
  alias IdleTesting.Factory

  describe "fields/0" do
    test "success: returns list of fields" do
      expected_fields = [
        :email,
        :favorite_number,
        :first_name,
        :id,
        :inserted_at,
        :last_name,
        :updated_at
      ]

      actual_fields = User.fields()

      assert Enum.sort(expected_fields) == Enum.sort(actual_fields)
    end
  end

  describe "create_changeset/1" do
    test "success: it returns a valid changeset when given valid args" do
      valid_params = Factory.string_params_for(:user)

      assert %Ecto.Changeset{valid?: true, changes: changes} = User.create_changeset(valid_params)

      assert_values_for(
        expected: {valid_params, :string_keys},
        actual: changes,
        fields: User.fields() -- [:id, :inserted_at, :updated_at]
      )
    end

    test "error: returns error changeset if values can't be cast" do
      not_a_string = DateTime.utc_now()

      uncastable_params = %{
        "email" => not_a_string,
        "favorite_number" => "not a string",
        "first_name" => not_a_string,
        "last_name" => not_a_string
      }

      assert %Ecto.Changeset{valid?: false} = changeset = User.create_changeset(uncastable_params)

      errors = errors_on(changeset)

      for {field, _} <- uncastable_params do
        atom_field = String.to_existing_atom(field)

        assert Enum.any?(errors, fn
                 {^atom_field, :cast, _} -> true
                 _ -> false
               end),
               "Missing cast validation for field: #{atom_field}"
      end
    end

    test "error: returns error changeset if required values are missing" do
      # setup
      missing_params = %{}

      # kickoff
      assert %Ecto.Changeset{valid?: false} = changeset = User.create_changeset(missing_params)

      # assertions
      errors = errors_on(changeset)

      assert_required_error(changeset, [:email, :first_name])
    end

    def assert_required_error(changeset, fields) do
      errors = errors_on(changeset)

      for field <- fields do
        assert {field, :required} in errors, "Missing required validation for field: #{field}"
      end
    end

    test "error: returns error changeset if email isn't original" do
      first_user = Factory.insert(:user)

      params_with_same_email = Factory.string_params_for(:user, email: first_user.email)

      assert %Ecto.Changeset{} = changeset = User.create_changeset(params_with_same_email)
      {:error, changeset_from_db} = IdleTesting.Repo.insert(changeset)

      expected_error = {:email, nil, [constraint: :unique, constraint_name: "users_email_index"]}
      assert expected_error in errors_on(changeset_from_db)
    end
  end
end
