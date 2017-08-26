defmodule WebScriptTest do
  use ExUnit.Case
  doctest WebScript

  test "greets the world" do
    assert WebScript.hello() == :world
  end
end
