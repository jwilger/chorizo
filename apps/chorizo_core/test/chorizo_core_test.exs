defmodule ChorizoCoreTest do
  use ExUnit.Case
  doctest ChorizoCore

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ChorizoCore.Repositories.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(ChorizoCore.Repositories.Repo,
                                   {:shared, self()})
  end
end
