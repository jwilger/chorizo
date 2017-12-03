defmodule ChorizoCore do
  @moduledoc """
  Public API for the ChorizoCore Application

  The top-level `ChorizoCore` module provides all of the functions that will be
  used by other applications. The other modules under the `ChorizoCore`
  namespace are intended to be used only within the `ChorizoCore` application.
  (They are documented here, to aid the development of `ChorizoCore` itself,
  however.).
  """

  @typedoc """
  A struct representing a User
  """
  @type user :: ChorizoCore.Entities.User.t

  @typedoc """
  A struct representing a Chore
  """
  @type chore :: ChorizoCore.Entities.Chore.t

  @doc """
  Builds and returns a new user with the specified attributes.

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
  Builds and returns a new user with default attributes.

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
  Determines if the User is anonymous

  ```
  iex> import ChorizoCore
  iex> user = new_user()
  iex> is_anonymous(user)
  false
  ```

  ```
  iex> import ChorizoCore
  iex> user = anonymous_user!()
  iex> is_anonymous(user)
  true
  ```
  """
  @spec is_anonymous(user) :: boolean
  defdelegate is_anonymous(user), to: ChorizoCore.Entities.User

  @doc """
  Creates new users in the system

  When no users yet exist, the anonymous user can create a new user:

  ```
  iex> import ChorizoCore
  iex> create_user(new_user(username: "bob"), anonymous_user!())
  {:ok, %ChorizoCore.Entities.User{
    username: "bob",
    anonymous: false,
    admin: true
  }}
  ```

  Otherwise users who are admins can create new users:

  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(new_user(username: "bob"), anonymous_user!())
  iex> create_user(new_user(username: "ann"), bob)
  {:ok, %ChorizoCore.Entities.User{
    username: "ann",
    anonymous: false,
    admin: false
  }}
  ```

  and users who are not admins can not create new users:
  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(new_user(username: "bob"), anonymous_user!())
  iex> {:ok, ann} = create_user(new_user(username: "ann"), bob)
  iex> create_user(new_user(username: "foo"), ann)
  :not_authorized
  ```
  """
  @spec create_user(user, user) :: {:ok, user} | :not_authorized
  defdelegate create_user(user, as_user), to: ChorizoCore.UserManagement

  @doc """
  Builds and returns a new chore with the specified attributes.

  ```
  iex> import ChorizoCore
  iex> new_chore(name: "Eat the food.")
  %ChorizoCore.Entities.Chore{
    name: "Eat the food."
  }
  ```

  Invalid attributes are ignored:

  ```
  iex> import ChorizoCore
  iex> new_chore(name: "Eat the food.", foo: :bar)
  %ChorizoCore.Entities.Chore{
    name: "Eat the food."
  }
  ```
  """
  @spec new_chore(keyword()) :: chore
  defdelegate new_chore(attributes), to: ChorizoCore.Entities.Chore, as: :new

  @doc """
  Creates a new chore in the system

  Users who are admins can create a new chore:

  ```
  iex> import ChorizoCore
  iex> {:ok, admin} = create_user(new_user(username: "admin", admin: true),
  iex>                                     anonymous_user!())
  iex> create_chore(new_chore(name: "Foo"), admin)
  {:ok, %ChorizoCore.Entities.Chore{
    name: "Foo"
  }}
  ```

  Users who are not admins can not create new chores:

  ```
  iex> import ChorizoCore
  iex> {:ok, admin} = create_user(new_user(username: "admin", admin: true),
  iex>                                     anonymous_user!())
  iex> {:ok, user} = create_user(new_user(username: "non_admin", admin: false),
  iex>                                    admin)
  iex> create_chore(new_chore(name: "Foo"), user)
  :not_authorized
  ```

  Anonymous users can not create new chores:
  ```
  iex> import ChorizoCore
  iex> create_chore(new_chore(name: "Foo"), anonymous_user!())
  :not_authorized
  """
  @spec create_chore(chore, user) :: {:ok, chore} | :not_authorized
  defdelegate create_chore(chore, as_user), to: ChorizoCore.ChoreManagement
end
