defmodule WordGuessWeb.GameLive do
  use WordGuessWeb, :live_view
  alias WordGuess.GameStatistics
  alias WordGuess.WordDictionary

  @max_incorrect_guesses 6
  @alphabet Enum.map(?a..?z, &<<&1::utf8>>)

  def mount(_params, _session, socket) do
    # Fetch game statistics on mount
    {:ok, stats} = GameStatistics.get_or_create_stats()

    {:ok,
     assign(socket,
       word: nil,
       difficulty: nil,
       guessed_letters: MapSet.new(),
       incorrect_guesses: 0,
       max_incorrect_guesses: @max_incorrect_guesses,
       alphabet: @alphabet,
       game_state: :not_started,
       show_instructions: true,
       show_game_over_modal: false,
       stats: stats,
       hint_used: false,
       show_hint: false,
       current_theme: "wordguess",
       available_themes: [
         "wordguess",
         "light",
         "dark",
         "cyberpunk",
         "halloween",
         "forest",
         "aqua"
       ]
     )}
  end

  def render(assigns) do
    ~H"""
    <div style="min-height: 100vh; padding: 1rem;" data-theme={@current_theme} phx-hook="Theme" id="theme-container">
      <div style="max-width: 64rem; margin: 0 auto;">
        <div style="text-align: center; margin-bottom: 2rem;">
          <h1 style="font-size: 3rem; font-weight: 800; color: #6366f1; margin-bottom: 0.5rem;">
            Word Guess
          </h1>
          <p style="font-size: 1.125rem; color: #e2e8f0;">
            Challenge your vocabulary and deduction skills
          </p>
        </div>

        <div class="flex justify-end mb-4">
          <div class="dropdown dropdown-end">
            <label tabindex="0" class="btn btn-sm m-1">
              Theme: {String.capitalize(@current_theme)}
            </label>
            <ul
              tabindex="0"
              class="dropdown-content z-[1] menu p-2 shadow bg-base-200 rounded-box w-52"
            >
              <%= for theme <- @available_themes do %>
                <li>
                  <a phx-click="change_theme" phx-value-theme={theme}>{String.capitalize(theme)}</a>
                </li>
              <% end %>
            </ul>
          </div>
        </div>

        <%= if @game_state == :not_started do %>
          <div class="bg-base-200 rounded-lg p-8 text-center shadow-lg">
            <h2 class="text-3xl font-bold text-primary mb-4">
              Select Difficulty
            </h2>

            <hr class="my-6 border-base-300" />

            <div class="flex flex-col gap-4 max-w-md mx-auto">
              <button
                phx-click="start_game"
                phx-value-difficulty="easy"
                class="btn btn-success btn-lg"
              >
                Easy
              </button>
              <button
                phx-click="start_game"
                phx-value-difficulty="medium"
                class="btn btn-primary btn-lg"
              >
                Medium
              </button>
              <button phx-click="start_game" phx-value-difficulty="hard" class="btn btn-error btn-lg">
                Hard
              </button>
            </div>

            <hr class="my-6 border-base-300" />

            <div class="mb-8">
              <div class="mb-6">
                <h3 class="text-xl font-bold text-base-content mb-2">
                  Difficulty Levels
                </h3>
                <p class="text-base-content/70 mb-2">Easy: Shorter words (3-4 letters)</p>
                <p class="text-base-content/70 mb-2">Medium: Medium-length words (5-6 letters)</p>
                <p class="text-base-content/70">Hard: Longer words (7-8 letters)</p>
              </div>
            </div>
          </div>
        <% else %>
          <%= if @show_instructions do %>
            <div class="bg-base-200 rounded-lg p-8 text-center shadow-lg">
              <h2 class="text-3xl font-bold text-primary mb-4">
                How to Play
              </h2>

              <hr class="my-6 border-base-300" />

              <div class="mb-8">
                <div class="mb-6">
                  <h3 class="text-xl font-bold text-base-content mb-2">
                    Guess Letters
                  </h3>
                  <p class="text-base-content/70">Click on letters to reveal the hidden word</p>
                </div>

                <div class="mb-6">
                  <h3 class="text-xl font-bold text-base-content mb-2">
                    Limited Attempts
                  </h3>
                  <p class="text-base-content/70">
                    You have {@max_incorrect_guesses} incorrect guesses before losing
                  </p>
                </div>

                <div class="mb-6">
                  <h3 class="text-xl font-bold text-base-content mb-2">
                    Need Help?
                  </h3>
                  <p class="text-base-content/70">
                    Use the hint button if you're stuck, but use it wisely!
                  </p>
                </div>
              </div>

              <button phx-click="hide_instructions" class="btn btn-primary">
                Start Playing
              </button>
            </div>
          <% else %>
            <div class="bg-base-200 rounded-lg p-8 shadow-lg">
              <div class="flex justify-between items-center mb-6">
                <div>
                  <h2 class="text-2xl font-bold text-primary">
                    Difficulty: {display_difficulty(@difficulty)}
                  </h2>
                </div>
                <div>
                  <span class="text-xl font-bold text-error">
                    Incorrect Guesses: {@incorrect_guesses}/{@max_incorrect_guesses}
                  </span>
                </div>
              </div>

              <div class="flex flex-col items-center justify-center mb-8">
                <div class="mb-8 text-center">
                  <div class="flex justify-center gap-2 mb-8">
                    <%= for letter <- String.graphemes(@word) do %>
                      <div class="w-12 h-16 flex items-center justify-center border-b-4 border-primary text-4xl font-bold">
                        <%= if MapSet.member?(@guessed_letters, letter) do %>
                          <span class="text-success">{letter}</span>
                        <% else %>
                          <span class="opacity-0">X</span>
                        <% end %>
                      </div>
                    <% end %>
                  </div>
                </div>

                <%= if @game_state == :in_progress do %>
                  <div class="mb-4">
                    <button phx-click="toggle_hint" class="btn btn-secondary btn-sm">
                      <%= if @show_hint do %>
                        Hide Hint
                      <% else %>
                        Show Hint
                      <% end %>
                    </button>
                  </div>

                  <%= if @show_hint do %>
                    <div class="bg-base-300 p-4 rounded-lg mb-6 max-w-md">
                      <h3 class="text-lg font-bold text-base-content mb-2">Hint:</h3>
                      <%= if @hint_used do %>
                        <p class="text-base-content/70 mb-2">
                          The word starts with "<span class="font-bold text-accent"><%= WordDictionary.get_hint(@word).first_letter %></span>"
                        </p>
                        <p class="text-base-content/70">
                          Definition: {WordDictionary.get_hint(@word).definition}
                        </p>
                      <% else %>
                        <p class="text-base-content/70 mb-2">
                          Using a hint will reveal the first letter and definition.
                        </p>
                        <button phx-click="use_hint" class="btn btn-accent btn-sm">
                          Use Hint
                        </button>
                      <% end %>
                    </div>
                  <% end %>

                  <div class="grid grid-cols-6 sm:grid-cols-9 gap-2 mb-8">
                    <%= for letter <- @alphabet do %>
                      <button
                        phx-click="guess"
                        phx-value-letter={letter}
                        disabled={letter in @guessed_letters}
                        class={
                          "btn w-10 h-10 font-bold text-lg " <>
                          if letter in @guessed_letters do
                            if String.contains?(@word, letter) do
                              "btn-success"
                            else
                              "btn-error"
                            end
                          else
                            "btn-primary"
                          end
                        }
                      >
                        {letter}
                      </button>
                    <% end %>
                  </div>
                <% end %>
              </div>

              <div class="flex justify-center">
                <button phx-click="new_game" class="btn btn-secondary">
                  New Game
                </button>
              </div>
            </div>
          <% end %>
        <% end %>

        <%= if @show_game_over_modal do %>
          <div class="fixed inset-0 flex items-center justify-center z-50 bg-black/50">
            <div class="bg-base-200 rounded-lg p-8 max-w-md w-full shadow-lg">
              <h2 class="text-3xl font-bold mb-4 text-center">
                <%= if @game_state == :won do %>
                  <span class="text-success">You Won!</span>
                <% else %>
                  <span class="text-error">Game Over</span>
                <% end %>
              </h2>

              <div class="mb-6 text-center">
                <p class="text-xl mb-2">
                  The word was: <span class="font-bold text-primary">{@word}</span>
                </p>
                <p class="text-base-content/70 mb-4">
                  {WordDictionary.get_definition(@word)}
                </p>
                <p class="text-base-content/70">
                  Difficulty: {display_difficulty(@difficulty)}
                </p>
              </div>

              <div class="bg-base-300 p-4 rounded-lg mb-6">
                <h3 class="text-lg font-bold mb-2">Statistics</h3>
                <div class="grid grid-cols-2 gap-2">
                  <div>
                    <p class="text-base-content/70">Games Played:</p>
                    <p class="font-bold">{@stats.total_games}</p>
                  </div>
                  <div>
                    <p class="text-base-content/70">Win Rate:</p>
                    <p class="font-bold">{win_rate(@stats)}%</p>
                  </div>
                  <div>
                    <p class="text-base-content/70">Current Streak:</p>
                    <p class="font-bold">{@stats.streak}</p>
                  </div>
                  <div>
                    <p class="text-base-content/70">Best Streak:</p>
                    <p class="font-bold">{@stats.best_streak}</p>
                  </div>
                </div>
              </div>

              <div class="flex justify-between">
                <button phx-click="return_to_start" class="btn btn-primary">
                  Main Menu
                </button>
                <button
                  phx-click="start_game"
                  phx-value-difficulty={@difficulty}
                  class="btn btn-accent"
                >
                  Play Again
                </button>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("start_game", %{"difficulty" => difficulty_string}, socket) do
    difficulty = String.to_atom(difficulty_string)
    word = WordDictionary.random_word(difficulty)

    {:noreply,
     assign(socket,
       word: word,
       difficulty: difficulty,
       guessed_letters: MapSet.new(),
       incorrect_guesses: 0,
       game_state: :in_progress,
       show_instructions: true,
       show_game_over_modal: false,
       hint_used: false,
       show_hint: false
     )}
  end

  def handle_event("hide_instructions", _params, socket) do
    {:noreply, assign(socket, show_instructions: false)}
  end

  def handle_event("guess", %{"letter" => letter}, socket) do
    %{
      word: word,
      guessed_letters: guessed_letters,
      incorrect_guesses: incorrect_guesses,
      max_incorrect_guesses: max_incorrect_guesses
    } = socket.assigns

    # Only process the guess if the game is still in progress
    if socket.assigns.game_state != :in_progress do
      {:noreply, socket}
    else
      # Add the guessed letter to the set of guessed letters
      updated_guessed_letters = MapSet.put(guessed_letters, letter)

      # Check if the guessed letter is in the word
      updated_incorrect_guesses =
        if String.contains?(word, letter) do
          incorrect_guesses
        else
          incorrect_guesses + 1
        end

      # Determine the new game state
      new_game_state =
        determine_game_state(
          word,
          updated_guessed_letters,
          updated_incorrect_guesses,
          max_incorrect_guesses
        )

      # Update statistics if the game is over
      updated_socket =
        if new_game_state in [:won, :lost] do
          {:ok, updated_stats} =
            GameStatistics.update_stats(new_game_state == :won, socket.assigns.difficulty)

          socket
          |> assign(stats: updated_stats)
          |> assign(show_game_over_modal: true)
        else
          socket
        end

      {:noreply,
       assign(updated_socket,
         guessed_letters: updated_guessed_letters,
         incorrect_guesses: updated_incorrect_guesses,
         game_state: new_game_state
       )}
    end
  end

  def handle_event("toggle_hint", _params, socket) do
    {:noreply, assign(socket, show_hint: !socket.assigns.show_hint)}
  end

  def handle_event("use_hint", _params, socket) do
    {:noreply, assign(socket, hint_used: true)}
  end

  def handle_event("change_theme", %{"theme" => theme}, socket) do
    # Update the document element's data-theme attribute using JavaScript
    socket =
      socket
      |> assign(current_theme: theme)
      |> push_event("update-theme", %{theme: theme})

    {:noreply, socket}
  end

  def handle_event("return_to_start", _params, socket) do
    {:noreply,
     assign(socket,
       word: nil,
       difficulty: nil,
       guessed_letters: MapSet.new(),
       incorrect_guesses: 0,
       game_state: :not_started,
       show_game_over_modal: false
     )}
  end

  def handle_event("new_game", _params, socket) do
    {:noreply, assign(socket, show_game_over_modal: true)}
  end

  # Helper functions
  defp display_difficulty(difficulty) do
    difficulty
    |> Atom.to_string()
    |> String.capitalize()
  end

  defp win_rate(stats) do
    if stats.total_games > 0 do
      win_percentage = stats.wins / stats.total_games * 100
      :erlang.float_to_binary(win_percentage, decimals: 1)
    else
      "0.0"
    end
  end

  # Determine if the game is won, lost, or still in progress
  defp determine_game_state(word, guessed_letters, incorrect_guesses, max_incorrect_guesses) do
    cond do
      # Game is lost if max incorrect guesses reached
      incorrect_guesses >= max_incorrect_guesses ->
        :lost

      # Game is won if all letters in the word have been guessed
      all_letters_guessed?(word, guessed_letters) ->
        :won

      # Game is still in progress
      true ->
        :in_progress
    end
  end

  # Check if all letters in the word have been guessed
  defp all_letters_guessed?(word, guessed_letters) do
    word
    |> String.graphemes()
    |> Enum.all?(fn letter -> letter in guessed_letters end)
  end
end
