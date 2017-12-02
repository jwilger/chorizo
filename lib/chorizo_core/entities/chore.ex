defmodule ChorizoCore.Entities.Chore do
  @moduledoc """
  """

  alias __MODULE__

  @typedoc """
  Contains the data related to a chore in the system's chore library
  """
  @type t() :: %Chore{
    name: String.t
  }
  defstruct [
    name: ""
  ]

  def new(attributes \\ []) when is_list(attributes) do
    struct(__MODULE__, attributes)
  end
end
