defmodule WordGuessWeb.GameLiveTest do
  use WordGuessWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    # Test initial render
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Word Guess"
    assert render(page_live) =~ "Select Difficulty"
  end

  test "starts a new game when difficulty is selected", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    # Select easy difficulty
    render_click(page_live, "start_game", %{"difficulty" => "easy"})

    # Should show instructions firs
    assert render(page_live) =~ "How to Play"

    # Hide instructions
    render_click(page_live, "hide_instructions")

    # Game should be in progress
    assert render(page_live) =~ "Difficulty: Easy"
    assert render(page_live) =~ "Incorrect Guesses: 0/6"
  end

  test "shows hint when requested", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    # Select easy difficulty
    render_click(page_live, "start_game", %{"difficulty" => "easy"})

    # Hide instructions
    render_click(page_live, "hide_instructions")

    # Show hin
    render_click(page_live, "toggle_hint")

    # Hint section should be visible
    assert render(page_live) =~ "Using a hint will reveal the first letter and definition"

    # Use hin
    render_click(page_live, "use_hint")

    # Should show hint conten
    assert render(page_live) =~ "The word starts with"
    assert render(page_live) =~ "Definition:"
  end

  test "processes letter guesses correctly", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    # Select easy difficulty
    render_click(page_live, "start_game", %{"difficulty" => "easy"})

    # Hide instructions
    render_click(page_live, "hide_instructions")

    # Make a guess with 'a' (most words contain 'a')
    render_click(page_live, "guess", %{"letter" => "a"})

    # Check that the game updates after the guess
    rendered = render(page_live)
    # Either 0 or 1 depending on the word
    assert rendered =~ "Incorrect Guesses:"
  end

  test "changes theme when selected", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    # Change theme to dark
    render_click(page_live, "change_theme", %{"theme" => "dark"})

    # Check that theme changed (we can't directly check assigns, so check for a theme-related attribute)
    assert render(page_live) =~ "data-theme=\"dark\""
  end

  test "game can be completed", %{conn: conn} do
    {:ok, page_live, _html} = live(conn, "/")

    # Select easy difficulty
    render_click(page_live, "start_game", %{"difficulty" => "easy"})

    # Hide instructions
    render_click(page_live, "hide_instructions")

    # Guess all letters (a-z)
    for letter <- Enum.map(?a..?z, &<<&1::utf8>>) do
      render_click(page_live, "guess", %{"letter" => letter})
    end

    # After guessing all letters, the game should be over
    # Either won or lost, but the game over modal should be shown
    assert render(page_live) =~ "Game Over"
  end
end
