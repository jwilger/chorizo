defmodule ChorizoCore.Entities.UUID do
  @callback uuidv4() :: String.t

  defdelegate uuidv4(), to: UUID, as: :uuid4
end
