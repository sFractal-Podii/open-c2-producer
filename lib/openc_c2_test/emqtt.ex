defmodule OpencC2Test.Emqtt do
  require Logger

  def publish(module, topic, message) do
    Logger.info(%{
      event: :publish,
      message: message,
      topic: topic,
      module: module
    })

    GenServer.cast(module, {:publish, {message, topic}})
  end
end
