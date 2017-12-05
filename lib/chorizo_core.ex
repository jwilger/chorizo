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
  iex> user = new_user(username: "bob")
  iex> user.username
  "bob"
  ```

  Invalid attributes are ignored:

  ```
  iex> import ChorizoCore
  iex> user = new_user(foo: "bar", username: "bob")
  iex> user.username
  "bob"
  iex> Map.has_key?(user, :foo)
  false
  ```

  It hashes the plain-text password into the password_hash and removes it:

  ```
  iex> import ChorizoCore
  iex> user = new_user(username: "bob", password: "^L3t^ ^me^ ^1n^ ^here!^")
  iex> user.password
  nil
  iex> is_binary(user.password_hash)
  true
  ```
  """
  @spec new_user(keyword()) :: user
  defdelegate new_user(attributes), to: ChorizoCore.Entities.User, as: :new

  @doc """
  Builds and returns a new user with default attributes.

  ```
  iex> import ChorizoCore
  iex> user = new_user()
  iex> user.username
  ""
  iex> user.password_hash
  nil
  iex> user.admin
  false
  ```
  """
  @spec new_user() :: user
  defdelegate new_user(), to: ChorizoCore.Entities.User, as: :new

  @doc """
  Returns an anonymous user that should be used when no user has been
  authenticated.

  ```
  iex> import ChorizoCore
  iex> user = anonymous_user!()
  iex> user.username
  ""
  iex> user.anonymous
  true
  iex> user.admin
  false
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
  iex> {:ok, bob} = create_user(new_user(username: "bob"), anonymous_user!())
  iex> bob.username
  "bob"
  iex> bob.admin
  true
  ```

  Otherwise users who are admins can create new users:

  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(new_user(username: "bob"), anonymous_user!())
  iex> {:ok, ann} = create_user(new_user(username: "ann"), bob)
  iex> ann.username
  "ann"
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
  Authenticates a user via username and password; returns matching user

  When the username and password match an existing user, that user is returned:

  ```
  iex> import ChorizoCore
  iex> {:ok, user} = create_user(
  ...>   new_user(username: "bob", password: "5r*J7H9YsQ"), anonymous_user!()
  ...> )
  iex> {:ok, authenticated} = authenticate_user(username: "bob",
  ...>                                          password: "5r*J7H9YsQ")
  iex> user.id == authenticated.id
  true
  ```

  When the username is incorrect, it returns a failure:

  ```
  iex> import ChorizoCore
  iex> {:ok, _user} = create_user(
  ...>   new_user(username: "bob", password: "5r*J7H9YsQ"), anonymous_user!()
  ...> )
  iex> {:failed, nil} = authenticate_user(username: "tom",
  ...>                                    password: "5r*J7H9YsQ")
  {:failed, nil}
  ```

  When the password is incorrect, it returns a failure:

  ```
  iex> import ChorizoCore
  iex> {:ok, _user} = create_user(
  ...>   new_user(username: "bob", password: "5r*J7H9YsQ"), anonymous_user!()
  ...> )
  iex> {:failed, nil} = authenticate_user(username: "bob",
  ...>                                    password: "badpassword")
  {:failed, nil}
  ```
  """
  @spec authenticate_user(username: String.t, password: String.t)
    :: {:ok, user} | {:failed, nil}
  defdelegate authenticate_user(credentials), to: ChorizoCore.Authentication

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
