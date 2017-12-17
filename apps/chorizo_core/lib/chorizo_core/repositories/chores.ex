defmodule ChorizoCore.Repositories.Chores do
  @moduledoc """
  """

  use ChorizoCore.Repositories.Repo
  import Ecto.Query
  alias ChorizoCore.Entities.Chore

  def count do
    aggregate(Chore, :count, :id)
  end

  def first(matching) when is_list(matching) do
    with %Chore{} = chore <- Chore
                    |> where(^matching)
                    |> first(:inserted_at)
                    |> one
    do
      {:ok, chore}
    else
      nil -> {:not_found, nil}
    end
  end
end
