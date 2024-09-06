defmodule Emqtt.HivemqSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_hivemq(args \\ []) do
    # If MyWorker is not using the new child specs, we need to pass a map:
    spec = %{id: "hivemq", start: {Emqtt.Hivemq, :start_link, [args]}, restart: :transient}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  @spec init(any()) ::
          {:ok,
           %{
             extra_arguments: list(),
             intensity: non_neg_integer(),
             max_children: :infinity | non_neg_integer(),
             period: pos_integer(),
             strategy: :one_for_one
           }}
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end
end
