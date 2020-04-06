defmodule IdleTesting.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: IdleTesting.Worker.start_link(arg)
      # {IdleTesting.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IdleTesting.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
