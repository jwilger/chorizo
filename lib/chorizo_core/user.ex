defmodule ChorizoCore.User do
  @moduledoc """
  Represents a person with access to the application
  """

  alias __MODULE__

  defstruct username: "", anonymous: false, admin: false

  def anonymous!, do: %User{anonymous: true}

  def new(properties), do: struct(__MODULE__, properties)
end
