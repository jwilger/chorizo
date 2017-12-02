defmodule ChorizoCoreTest do
  use ExUnit.Case
  doctest ChorizoCore

  setup do
    ChorizoCore.Repositories.Users.reset()
    on_exit &ChorizoCore.Repositories.Users.reset/0
  end
end
