defmodule OpenC2Producer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OpenC2ProducerWeb.Telemetry,
      {Phoenix.PubSub, name: OpenC2Producer.PubSub},
      {Finch, name: OpenC2Producer.Finch},
      OpenC2Producer.Emqtt.Hivemq,
      OpenC2Producer.Emqtt.Emqx,
      OpenC2ProducerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: OpenC2Producer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OpenC2ProducerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
