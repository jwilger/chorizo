defmodule ChorizoCore.Repositories.Users do
  @moduledoc """
  """

  use ChorizoCore.Repositories.Repo
  import Ecto.Query
  alias ChorizoCore.Entities.User

  def count do
    aggregate(User, :count, :id)
  end

  def first(matching) when is_list(matching) do
    with %User{} = user <- User
                   |> where(^matching)
                   |> first(:inserted_at)
                   |> one
    do
      {:ok, user}
    else
      nil -> {:not_found, nil}
    end
  end
end
