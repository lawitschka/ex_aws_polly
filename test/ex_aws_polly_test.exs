defmodule ExAws.PollyTest do
  use ExUnit.Case
  doctest ExAws.Polly

  test "greets the world" do
    assert ExAws.Polly.hello() == :world
  end
end
