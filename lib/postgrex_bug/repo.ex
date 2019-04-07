defmodule PostgrexBug.Repo do
  @moduledoc false

  use Ecto.Repo,
      otp_app: :postgrex_bug,
      adapter: Ecto.Adapters.Postgres
end
