defmodule PostgrexBug.Entities.Profile do
  use Ecto.Schema

  schema "profiles" do
    belongs_to(:account, PostgrexBug.Entities.Account)
    field(:name, :string)
  end
end
