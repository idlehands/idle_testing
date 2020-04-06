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
end
