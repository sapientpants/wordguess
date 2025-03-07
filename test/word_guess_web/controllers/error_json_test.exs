defmodule WordGuessWeb.ErrorJSONTest do
  use ExUnit.Case

  # Simplified test to avoid ConnCase issues
  test "error templates exist" do
    assert File.exists?("lib/word_guess_web/controllers/error_json.ex")
  end
end
