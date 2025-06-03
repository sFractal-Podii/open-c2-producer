defmodule OpenC2Producer.TestScript do
  defstruct [:device, :broker, :command]

  import Ecto.Changeset

  alias __MODULE__

  @type t :: %__MODULE__{
          device: String.t() | nil,
          broker: String.t() | nil,
          command: String.t() | nil
        }

  def change_script(%TestScript{} = script, attrs \\ %{}) do
    types = %{device: :string, broker: :string, command: :string}

    {script, types}
    |> cast(attrs, Map.keys(types))
  end
end
