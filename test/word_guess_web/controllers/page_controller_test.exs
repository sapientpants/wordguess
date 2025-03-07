defmodule WordGuessWeb.PageControllerTest do
  use ExUnit.Case

  # Simple test to check if the route exists
  test "page controller module exists" do
    assert Code.ensure_loaded?(WordGuessWeb.PageController)
  end
end
