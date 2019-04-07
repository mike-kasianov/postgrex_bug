defmodule PostgrexBug.Entities.Account do
  use Ecto.Schema

  schema "accounts" do
    field(:email, :string)

    has_one(:profile, PostgrexBug.Entities.Profile)
  end
end
