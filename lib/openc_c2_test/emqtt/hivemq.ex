defmodule Emqtt.Hivemq do
  @moduledoc "Emqtt server responsible for handling pubsub between clients and broker"
  use GenServer
  require Logger

  @clean_start false

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    topic = "oc2/cmd/device/t02"

    clientid =
      System.get_env("HIVEMQ_CLIENT_ID") ||
        raise """
        environment variable HIVEMQ_CLIENT_ID is missing.
        For example:
        export HIVEMQ_CLIENT_ID=sfractal2020
        """

    Logger.info("client_id is #{clientid}")

    host =
      ~c"#{System.get_env("HIVEMQ_HOST")}" ||
        raise """
        environment variable HIVEMQ_HOST is missing.
        Examples:
        export HIVEMQ_HOST="35.221.11.97 "
        export HIVEMQ_HOST="mqtt.sfractal.com"
        """

    Logger.info("mqtt_host is #{host}")

    port =
      String.to_integer(
        System.get_env("HIVEMQ_PORT") ||
          raise("""
          environment variable HIVEMQ_PORT is missing.
          Example:
          export HIVEMQ_PORT=1883
          """)
      )

    Logger.info("mqtt_port is #{port}")

    name =
      String.to_atom(System.get_env("HIVEMQ_USER_NAME")) ||
        raise """
        environment variable HIVEMQ_USER_NAME is missing.
        Examples:
        export HIVEMQ_USER_NAME="plug"
        """

    Logger.info("user_name is #{name}")

    emqtt_opts = [
      host: host,
      port: port,
      clientid: clientid,
      clean_start: @clean_start,
      name: name
    ]

    {:ok, pid} = :emqtt.start_link(emqtt_opts)

    state = %{pid: pid, topic: topic}

    {:ok, state, {:continue, :start_emqtt}}
  end

  def handle_continue(:start_emqtt, %{pid: pid} = state) do
    {:ok, _} = :emqtt.connect(pid)

    {:noreply, state}
  end

  def handle_cast({:publish, message}, %{topic: topic, pid: pid} = state) do
    :emqtt.publish(
      pid,
      topic,
      message
    )

    {:noreply, state}
  end

  def publish(message) do
    Logger.info("publish #{message}")
    GenServer.cast(__MODULE__, {:publish, message})
  end
end
