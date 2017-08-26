defmodule WebScript.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @pool_options [
    name: {:local, :pool},
    worker_module: WebScript.Worker,
    size: 10,
    max_overflow: 0,
  ]


  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: WebScript.Worker.start_link(arg)
      # {WebScript.Worker, arg},
      :poolboy.child_spec(:pool, @pool_options, []),
      Plug.Adapters.Cowboy.child_spec(:http, WebScript.HTTP, [], port: 4000),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebScript.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
