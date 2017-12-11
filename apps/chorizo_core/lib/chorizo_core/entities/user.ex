defmodule ChorizoCore.Entities.User do
  @moduledoc """
  Provides functions for working with user data
  """

  use ChorizoCore.Entities.Schema
  import Ecto.Changeset

  alias ChorizoCore.Authentication.Hasher

  @typedoc """
  Contains the data related to an individual user of the system
  """
  @type t() :: %__MODULE__{
    id: String.t | nil,
    username: String.t | nil,
    anonymous: boolean,
    admin: boolean,
    password: String.t | nil,
    password_hash: String.t | nil
  }
  schema "users" do
    field :username, :string
    field :anonymous, :boolean, default: false, virtual: true
    field :admin, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  @doc """
  Builds and returns an anonymous `%ChorizoCore.Entities.User{}`
  """
  @spec anonymous!() :: t()
  def anonymous!, do: %__MODULE__{anonymous: true}

  @doc """
  Determines if the User is anonymous
  """
  @spec is_anonymous(t) :: boolean
  def is_anonymous(%__MODULE__{anonymous: true}), do: true
  def is_anonymous(%__MODULE__{anonymous: false}), do: false

  @doc """
  Builds an `Ecto.Changeset` for the user data
  """
  @spec changeset(%{}) :: Ecto.Changeset.t
  def changeset(%{} = params), do: changeset(%__MODULE__{}, params)

  @doc """
  Builds an `Ecto.Changeset` for the user data

  Note that if a `:password` key is present in the params, its value will be
  hashed with `ChorizoCore.Authentication.Hasher.hashpwsalt/1` and stored in the
  `:password_hash` key. The `:password` key will be removed.
  ```
  """
  @spec changeset(__MODULE__.t, %{}) :: Ecto.Changeset.t
  def changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, [:username, :admin, :password])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> hash_password
  end

  defp hash_password(
    %Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset
  ) do
    changeset
    |> put_change(:password_hash, Hasher.hashpwsalt(pass))
    |> delete_change(:password)
  end
  defp hash_password(changeset), do: changeset
end
