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

  ```
  iex> ChorizoCore.Entities.User.anonymous!()
  %ChorizoCore.Entities.User{
    username: "",
    anonymous: true,
    admin: false
  }
  ```
  """
  @spec anonymous!() :: t()
  def anonymous!, do: new(anonymous: true)

  @doc """
  Builds and returns a `%ChorizoCore.Entities.User{}` from `propterties`

  ## Provides default values when no attributes are specified:

  ```
  iex> ChorizoCore.Entities.User.new()
  %ChorizoCore.Entities.User{
    username: "",
    anonymous: false,
    admin: false
  }
  ```

  ## Values can be specified:

  ```
  iex> ChorizoCore.Entities.User.new(username: "bob", admin: true)
  %ChorizoCore.Entities.User{
    username: "bob",
    anonymous: false,
    admin: true
  }
  ```

  ## Invalid keys are simply ignored:

  ```
  iex> ChorizoCore.Entities.User.new(not_a_valid_key: "foobar", username: "bob")
  %ChorizoCore.Entities.User{
    username: "bob",
    anonymous: false,
    admin: false
  }
  ```
  """
  @spec new(keyword()) :: t()
  def new(properties \\ []) when is_list(properties),
    do: struct(__MODULE__, properties)
end
