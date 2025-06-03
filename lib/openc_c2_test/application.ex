defmodule OpencC2Test.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OpencC2TestWeb.Telemetry,
      {Phoenix.PubSub, name: OpencC2Test.PubSub},
      {Finch, name: OpencC2Test.Finch},
      OpencC2Test.Emqtt.Hivemq,
      OpencC2Test.Emqtt.Emqx,
      OpencC2TestWeb.Endpoint
    ]

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
