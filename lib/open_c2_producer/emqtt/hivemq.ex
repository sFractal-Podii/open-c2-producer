defmodule OpenC2Producer.Emqtt.Hivemq do
  @moduledoc "Emqtt server responsible for handling pubsub between clients and broker"
  use GenServer
  require Logger

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    emqtt_opts = Application.fetch_env!(:open_c2_producer, OpenC2Producer.Emqtt.Hivemq)

    {:ok, pid} = :emqtt.start_link(emqtt_opts)

    Logger.info(%{
      event: :starting,
      module: __MODULE__,
      options: emqtt_opts
    })

    {:ok, %{pid: pid}, {:continue, :start_emqtt}}
  end

  def handle_continue(:start_emqtt, %{pid: pid} = state) do
    {:ok, _} = :emqtt.connect(pid)

    Logger.info(%{event: :connected, module: __MODULE__})

    {:noreply, state}
  end

  def handle_cast({:publish, {message, topic}}, %{topic: topic, pid: pid} = state) do
    :emqtt.publish(pid, topic, message)

    {:noreply, state}
  end

  def terminate(reason, state) do
    Logger.info(%{
      event: :terminated,
      module: __MODULE__,
      reason: reason,
      state: state
    })
  end
end
