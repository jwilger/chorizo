defmodule ChorizoCore.Entities.User do
  @moduledoc """
  """

  alias __MODULE__

  @typedoc """
  Contains the data related to an individual user of the system
  """
  @type t() :: %User{
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
  Determines if the User is anonymous
  """
  @spec is_anonymous(t) :: boolean
  def is_anonymous(%User{anonymous: true}), do: true
  def is_anonymous(%User{anonymous: false}), do: false


  @doc """
  Builds and returns a `%ChorizoCore.Entities.User{}` from `propterties`
  """
  @spec new(keyword()) :: t()
  def new(properties \\ []) when is_list(properties),
    do: struct(__MODULE__, properties)
end
