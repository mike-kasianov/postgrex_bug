defmodule PostgrexBug.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {PostgrexBug.Repo, []}
      # Starts a worker by calling: PostgrexBug.Worker.start_link(arg)
      # {PostgrexBug.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PostgrexBug.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
