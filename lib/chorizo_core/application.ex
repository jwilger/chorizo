defmodule ChorizoCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      ChorizoCore.Repositories.Users.Server,
      ChorizoCore.Repositories.Chores.Server
      # Starts a worker by calling: ChorizoCore.Worker.start_link(arg)
      # {ChorizoCore.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChorizoCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
