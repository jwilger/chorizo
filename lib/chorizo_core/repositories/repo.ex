defmodule ChorizoCore.Repositories.Repo do
  @moduledoc """
  The main Ecto repository for Chorizo
  """

  use Ecto.Repo, otp_app: :chorizo_core

  defmacro __using__(_) do
    quote do
      alias ChorizoCore.Repositories.Repo
      defdelegate insert(struct_or_changeset), to: Repo
      defdelegate aggregate(queryable, aggregate, field), to: Repo
      defdelegate one(queryable), to: Repo
    end
  end

  @callback insert(struct_or_changeset :: Ecto.Changeset.t | EctoSchema.t)
    :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}

  @callback count() :: integer
  @callback first(conditions :: list)
    :: {:ok, Ecto.Schema.t} | {:not_found, nil}
end
