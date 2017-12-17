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
  Returns an anonymous user that should be used when no user has been
  authenticated.

  ```
  iex> import ChorizoCore
  iex> user = anonymous_user!()
  iex> user.username
  nil
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
  iex> user = %ChorizoCore.Entities.User{}
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

  When no users yet exist, the anonymous user can create a new user, and that
  user becomes the first admin:

  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(%{username: "bob"}, anonymous_user!())
  iex> bob.username
  "bob"
  iex> bob.admin
  true
  ```

  Otherwise users who are admins can create new users:

  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(%{username: "bob"}, anonymous_user!())
  iex> {:ok, ann} = create_user(%{username: "ann"}, bob)
  iex> ann.username
  "ann"
  ```

  and users who are not admins can not create new users:
  ```
  iex> import ChorizoCore
  iex> {:ok, bob} = create_user(%{username: "bob"}, anonymous_user!())
  iex> {:ok, ann} = create_user(%{username: "ann"}, bob)
  iex> create_user(%{username: "foo"}, ann)
  :not_authorized
  ```
  """
  @spec create_user(user | map, user) :: {:ok, user} | :not_authorized
  defdelegate create_user(user, as_user), to: ChorizoCore.UserManagement

  @doc """
  Authenticates a user via username and password; returns matching user

  When the username and password match an existing user, that user is returned:

  ```
  iex> import ChorizoCore
  iex> {:ok, user} = create_user(
  ...>   %{username: "bob", password: "5r*J7H9YsQ"}, anonymous_user!()
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
  ...>   %{username: "bob", password: "5r*J7H9YsQ"}, anonymous_user!()
  ...> )
  iex> {:failed, nil} = authenticate_user(username: "tom",
  ...>                                    password: "5r*J7H9YsQ")
  {:failed, nil}
  ```

  When the password is incorrect, it returns a failure:

  ```
  iex> import ChorizoCore
  iex> {:ok, _user} = create_user(
  ...>   %{username: "bob", password: "5r*J7H9YsQ"}, anonymous_user!()
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
  Creates a new chore in the system

  Users who are admins can create a new chore:

  ```
  iex> import ChorizoCore
  iex> {:ok, admin} = create_user(%{username: "admin", admin: true},
  iex>                            anonymous_user!())
  iex> {:ok, chore} = create_chore(%{name: "Foo"}, admin)
  iex> chore.name
  "Foo"
  ```

  Users who are not admins can not create new chores:

  ```
  iex> import ChorizoCore
  iex> {:ok, admin} = create_user(%{username: "admin", admin: true},
  iex>                            anonymous_user!())
  iex> {:ok, user} = create_user(%{username: "non_admin", admin: false}, admin)
  iex> create_chore(%{name: "Foo"}, user)
  :not_authorized
  ```

  Anonymous users can not create new chores:
  ```
  iex> import ChorizoCore
  iex> create_chore(%{name: "Foo"}, anonymous_user!())
  :not_authorized
  """
  @spec create_chore(chore, user) :: {:ok, chore} | :not_authorized
  defdelegate create_chore(chore, as_user), to: ChorizoCore.ChoreManagement
end
