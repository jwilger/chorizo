defmodule ChorizoCore.Entities.User do
  @moduledoc """
  Provides functions for working with user data
  """

  use ChorizoCore.Entities.Schema

  alias __MODULE__
  alias ChorizoCore.Authentication.Hasher
  alias ChorizoCore.Entities.UUID

  @typedoc """
  Contains the data related to an individual user of the system
  """
  @type t() :: %User{
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
  end

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
  def new(properties \\ []) when is_list(properties) do
    properties
    |> Enum.into(%{})
    |> ensure_id_present
    |> hash_password
    |> (&(struct(__MODULE__, &1))).()
  end

  defp ensure_id_present(%{id: id} = properties)
  when is_binary(id), do: properties

  defp ensure_id_present(%{id_generator: id_generator} = properties) do
    id = id_generator.uuidv4
    Map.put(properties, :id, id)
  end

  defp ensure_id_present(properties) do
    properties
    |> Map.put(:id_generator, UUID)
    |> ensure_id_present
  end

  defp hash_password(%{password: password,
    password_hasher: password_hasher} = properties)
  do
    hash = password_hasher.hashpwsalt(password)
    properties
    |> Map.delete(:password)
    |> Map.put(:password_hash, hash)
  end

  defp hash_password(%{password: password} = properties)
  when is_binary(password) do
    properties
    |> Map.put(:password_hasher, Hasher)
    |> hash_password
  end

  defp hash_password(properties), do: properties
end
