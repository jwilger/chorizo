defmodule ChorizoCore.Entities.User do
  @moduledoc """
  """
  @typedoc """
  Contains the data related to an individual user of the system
  """
  @type t() :: %ChorizoCore.Entities.User{
    username: String.t,
    anonymous: boolean(),
    admin: boolean()
  }
  defstruct [
    username: "",
    anonymous: false,
    admin: false
  ]

  @doc """
  Builds and returns an anonymous `%ChorizoCore.Entities.User{}`
  """
  @spec anonymous!() :: t()
  def anonymous!, do: new(anonymous: true)

  @doc """
  Builds and returns a `%ChorizoCore.Entities.User{}` from `propterties`
  """
  @spec new(keyword()) :: t()
  def new(properties \\ []) when is_list(properties),
    do: struct(__MODULE__, properties)
end
