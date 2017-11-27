defmodule ChorizoCoreTest do
  use ExUnit.Case
  doctest ChorizoCore

  test "greets the world" do
    assert ChorizoCore.hello() == :world
  end
end
