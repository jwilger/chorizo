defmodule ChorizoCore do
  @moduledoc """
  Implements the core functionality of Chorizo

  The top-level `ChorizoCore` module provides all of the functions that will be
  used by other applications. The other modules under the `ChorizoCore`
  namespace are intended to be used only within the `ChorizoCore` application.
  (They are documented to aid the development of `ChorizoCore` itself,
  however.).
  """

  @typedoc """
  A struct representing a User
  """
  @type user :: ChorizoCore.Entities.User.t

  @doc """
  Builds and returns a new `%ChorizoCore.Entities.User{}` with the specified
  attributes.

  ```
  iex> import ChorizoCore
  iex> new_user(username: "bob")
  %ChorizoCore.Entities.User{
    username: "bob",
    anonymous: false,
    admin: false
  }
  ```

  Invalid attributes are ignored:

  ```
  iex> import ChorizoCore
  iex> new_user(foo: "bar", username: "bob", baz: "bam")
  %ChorizoCore.Entities.User{
    username: "bob",
    anonymous: false,
    admin: false
  }
  ```
  """
  @spec new_user(keyword()) :: user
  defdelegate new_user(attributes), to: ChorizoCore.Entities.User, as: :new

  @doc """
  Builds and returns a new `%ChorizoCore.Entities.User{}` with default
  attributes.

  ```
  iex> import ChorizoCore
  iex> new_user()
  %ChorizoCore.Entities.User{
    username: "",
    anonymous: false,
    admin: false
  }
  ```
  """
  @spec new_user() :: user
  defdelegate new_user(), to: ChorizoCore.Entities.User, as: :new

  @doc """
  Returns an anonymous user that should be used when no user has been
  authenticated.

  ```
  iex> import ChorizoCore
  iex> anonymous_user!()
  %ChorizoCore.Entities.User{
    username: "",
    anonymous: true,
    admin: false
  }
  """
  @spec anonymous_user!() :: user
  defdelegate anonymous_user!(), to: ChorizoCore.Entities.User, as: :anonymous!

  @doc """
  Creates new users in the system

  When no users yet exist, the anonymous user can create a new user:

  ```
  iex> import ChorizoCore
  iex> create_user(new_user(username: "bob"), as: anonymous_user!())
  {:ok, %ChorizoCore.Entities.User{
    username: "bob",
    anonymous: false,
    admin: true
  }}
  ```

  Otherwise users who are admins can create new users:

  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(new_user(username: "bob"), as: anonymous_user!())
  iex> create_user(new_user(username: "ann"), as: bob)
  {:ok, %ChorizoCore.Entities.User{
    username: "ann",
    anonymous: false,
    admin: false
  }}
  ```

  and users who are not admins can not create new users:
  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(new_user(username: "bob"), as: anonymous_user!())
  iex> {:ok, ann} = create_user(new_user(username: "ann"), as: bob)
  iex> create_user(new_user(username: "foo"), as: ann)
  :not_authorized
  ```
  """
  @spec create_user(user, [as: user]) :: {:ok, user} | :not_authorized
  defdelegate create_user(user, options), to: ChorizoCore.UserManagement
end
