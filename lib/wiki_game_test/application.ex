defmodule WikiGameTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  # defp poolboy_config do
  #   [
  #     name: {:local, :worker},
  #     worker_module: WikiGameTest.Spider,
  #     size: 50,
  #     max_overflow: 3
  #   ]
  # end

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WikiGameTestWeb.Telemetry,
      # Start the Ecto repository
      WikiGameTest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WikiGameTest.PubSub},
      # Start Finch
      {Finch, name: WikiGameTest.Finch},
      # Start the Endpoint (http/https)
      WikiGameTestWeb.Endpoint,
      # :poolboy.child_spec(:worker, poolboy_config()),
      WikiGameTest.Ets.Cache,
      WikiGameTest.Scrapper.Starter
      # WikiGameTest.Spider
      # Start a worker by calling: WikiGameTest.Worker.start_link(arg)
      # {WikiGameTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :one_for_one, name: WikiGameTest.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WikiGameTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
