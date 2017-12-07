defmodule ChorizoCore.Entities.UUID do
  @moduledoc false

  @callback uuidv4() :: String.t

  defdelegate uuidv4(), to: UUID, as: :uuid4
end
