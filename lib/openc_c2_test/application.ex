defmodule OpencC2Test.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OpencC2TestWeb.Telemetry,
      # Start the Ecto repository
      # OpencC2Test.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: OpencC2Test.PubSub},
      # Start Finch
      {Finch, name: OpencC2Test.Finch},
      # Start the Endpoint (http/https)
      OpencC2TestWeb.Endpoint,
      {DynamicSupervisor, name: EmqttSupervisor, strategy: :one_for_one}
      # Start a worker by calling: OpencC2Test.Worker.start_link(arg)
      # {OpencC2Test.Worker, arg}
      # start emqtt connection
      # Emqtt
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OpencC2Test.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OpencC2TestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
