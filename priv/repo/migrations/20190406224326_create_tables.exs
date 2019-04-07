defmodule PostgrexBug.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add(:email, :string, null: false)
    end

    create table("profiles") do
      add(:account_id, references("accounts", on_delete: :delete_all), null: false)
      add(:name, :string, null: false)
    end

    create(unique_index("profiles", [:account_id], name: :profiles_account_id_index))
  end
end
