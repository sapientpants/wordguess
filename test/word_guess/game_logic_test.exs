defmodule WordGuess.GameLogicTest do
  use ExUnit.Case, async: true

  # Since the game logic is embedded in the LiveView, we'll test the core game functions
  # by simulating the game state and transitions

  # Define a simplified game state for testing
  defmodule TestGame do
    defstruct word: "test",
              guessed_letters: MapSet.new(),
              incorrect_guesses: 0,
              max_incorrect_guesses: 6,
              game_state: :in_progress

    # Process a guess
    def guess(game, letter) do
      # Return early if game is already over
      if game.game_state != :in_progress do
        game
      else
        process_guess(game, letter)
      end
    end

    # Process a guess when the game is in progress
    defp process_guess(game, letter) do
      # Add letter to guessed letters
      game = %{game | guessed_letters: MapSet.put(game.guessed_letters, letter)}

      # Check if letter is in the word
      if String.contains?(game.word, letter) do
        check_for_win(game)
      else
        check_for_loss(%{game | incorrect_guesses: game.incorrect_guesses + 1})
      end
    end

    # Check if the player has won
    defp check_for_win(game) do
      if all_letters_guessed?(game) do
        %{game | game_state: :won}
      else
        game
      end
    end

    # Check if the player has lost
    defp check_for_loss(game) do
      if game.incorrect_guesses >= game.max_incorrect_guesses do
        %{game | game_state: :lost}
      else
        game
      end
    end

    # Check if all letters in the word have been guessed
    defp all_letters_guessed?(game) do
      game.word
      |> String.graphemes()
      |> Enum.all?(fn letter -> MapSet.member?(game.guessed_letters, letter) end)
    end
  end

  describe "game logic" do
    test "correctly processes a correct guess" do
      game = %TestGame{}
      game = TestGame.guess(game, "t")

      assert MapSet.member?(game.guessed_letters, "t")
      assert game.incorrect_guesses == 0
      assert game.game_state == :in_progress
    end

    test "correctly processes an incorrect guess" do
      game = %TestGame{}
      game = TestGame.guess(game, "z")

      assert MapSet.member?(game.guessed_letters, "z")
      assert game.incorrect_guesses == 1
      assert game.game_state == :in_progress
    end

    test "detects when the game is won" do
      game = %TestGame{}

      # Guess all letters in "test"
      game = TestGame.guess(game, "t")
      game = TestGame.guess(game, "e")
      game = TestGame.guess(game, "s")

      assert game.game_state == :won
    end

    test "detects when the game is lost" do
      game = %TestGame{max_incorrect_guesses: 3}

      # Make 3 incorrect guesses
      game = TestGame.guess(game, "a")
      game = TestGame.guess(game, "b")
      game = TestGame.guess(game, "c")

      assert game.game_state == :lost
    end

    test "ignores guesses after game is over" do
      game = %TestGame{}

      # Win the game
      game = TestGame.guess(game, "t")
      game = TestGame.guess(game, "e")
      game = TestGame.guess(game, "s")

      assert game.game_state == :won

      # Try to make another guess
      original_guessed_letters = game.guessed_letters
      game = TestGame.guess(game, "z")

      # Should not change the game state
      assert game.guessed_letters == original_guessed_letters
      assert game.game_state == :won
    end
  end
end
