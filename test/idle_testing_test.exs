defmodule IdleTestingTest do
  use ExUnit.Case
  doctest IdleTesting

  test "greets the world" do
    assert IdleTesting.hello() == :world
  end
end
