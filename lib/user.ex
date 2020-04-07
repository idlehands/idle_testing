defmodule IdleTesting.User do
  use IdleTesting.Schema

  schema "users" do
    field(:email, :string)
    field(:favorite_number, :integer)
    field(:first_name, :string)
    field(:last_name, :string)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  def create_changeset(params) do
    cast_params = fields() -- [:id, :inserted_at, :updated_at]

    %IdleTesting.User{}
    |> cast(params, cast_params)
    |> validate_required([:email, :first_name])
    |> unique_constraint(:email)
  end
end
