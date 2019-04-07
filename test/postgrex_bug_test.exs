defmodule PostgrexBugTest do
  use ExUnit.Case

  # Insert is invalid because of triggered constraint `trigger_account_has_profile`.
  # See `PostgrexBug.Repo.Migrations.CreateProfileMustHaveAccountConstraint migration`
  test "invalid insert" do
    account = %PostgrexBug.Entities.Account{
      email: "bug@gmail.com",
    }

    Ecto.Adapters.SQL.Sandbox.unboxed_run(PostgrexBug.Repo, fn ->
      # The problem is here!
      PostgrexBug.Repo.insert(account)
    end)
  end

  test "valid insert" do
    account = %PostgrexBug.Entities.Account{
      email: "bug@gmail.com",
      profile: %PostgrexBug.Entities.Profile{
        name: "Bug"
      }
    }

    Ecto.Adapters.SQL.Sandbox.unboxed_run(PostgrexBug.Repo, fn ->
      {:ok, new_account} = PostgrexBug.Repo.insert(account)
      assert is_integer(new_account.id)
    end)
  end
end
