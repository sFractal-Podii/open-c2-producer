defmodule Emqtt do
  @moduledoc "Emqtt server responsible for handling pubsub between clients and broker"
  use GenServer
  require Logger

  @clean_start false

  def start_link(args \\ %{broker: "emqx"}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init([]) do
    topic = "oc2/cmd/device/t01"

    clientid =
      System.get_env("CLIENT_ID") ||
        raise """
        environment variable CLIENT_ID is missing.
        For example:
        export CLIENT_ID=openc2test2023
        """

    Logger.info("client_id is #{clientid}")

    host =
      ~c"#{System.get_env("MQTT_HOST")}" ||
        raise """
        environment variable HOST is missing.
        Examples:
        export MQTT_HOST="35.221.11.97 "
        export MQTT_HOST="mqtt.broker.com"
        """

    Logger.info("mqtt_host is #{host}")

    port =
      String.to_integer(
        System.get_env("MQTT_PORT") ||
          raise("""
          environment variable MQTT_PORT is missing.
          Example:
          export MQTT_PORT=1883
          """)
      )

    Logger.info("mqtt_port is #{port}")

    name =
      String.to_atom(System.get_env("USER_NAME")) ||
        raise """
        environment variable USER_NAME is missing.
        Examples:
        export USER_NAME="plug"
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
