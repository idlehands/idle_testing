defmodule IdleTesting.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: true)
      add(:email, :string, null: false)
      add(:favorite_number, :integer)

      timestamps()
    end
  end
end
