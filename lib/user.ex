defmodule IdleTesting.User do
  use IdleTesting.Schema

  @required_fields [:email, :first_name]

  schema "users" do
    field(:email, :string)
    field(:favorite_number, :integer)
    field(:first_name, :string)
    field(:last_name, :string)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  def create_changeset(params) do
    %IdleTesting.User{}
    |> cast(params, fields())
    |> validate_required(@required_fields)
  end
end
