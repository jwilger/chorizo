defmodule ChorizoCore.Entities.Chore do
  @moduledoc """
  Provides functions for working with chore data
  """

  use ChorizoCore.Entities.Schema
  import Ecto.Changeset

  @typedoc """
  Contains the data related to a chore in the system's chore library
  """
  @type t() :: %__MODULE__{
    id: String.t | nil,
    name: String.t | nil
  }
  schema "chores" do
    field :name, :string
    timestamps()
  end

  @doc """
  Builds an `Ecto.Changeset` for the chore data
  """
  @spec changeset(%{}) :: Ecto.Changeset.t
  def changeset(%{} = params), do: changeset(%__MODULE__{}, params)

  @doc """
  Builds an `Ecto.Changeset` for the chore data
  ```
  """
  @spec changeset(__MODULE__.t, %{}) :: Ecto.Changeset.t
  def changeset(%__MODULE__{} = chore, params \\ %{}) do
    chore
    |> cast(params, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
