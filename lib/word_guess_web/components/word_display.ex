defmodule WordGuessWeb.Components.WordDisplay do
  @moduledoc """
  Component for rendering the word display in the Word Guess game.
  Provides visual representation of the word with masked and revealed letters.
  """
  use Phoenix.Component

  attr(:word, :string, required: true)
  attr(:guessed_letters, :any, required: true)
  attr(:game_state, :atom, required: true)

  def render(assigns) do
    ~H"""
    <div class="mb-8">
      <div class="flex justify-center flex-wrap gap-2">
        <%= for {letter, index} <- Enum.with_index(String.graphemes(@word)) do %>
          <div class="relative letter-container" style={"--animation-delay: #{index}"}>
            <svg width="60" height="80" viewBox="0 0 60 80">
              <!-- Letter background -->
              <rect
                x="5"
                y="5"
                width="50"
                height="70"
                rx="5"
                ry="5"
                fill="#4a5568"
                class="transition-all duration-300 ease-in-out"
                style={"fill: #{letter_background_color(letter, @guessed_letters, @game_state)};"}
              />
              
    <!-- Letter -->
              <text
                x="30"
                y="50"
                font-size="30"
                font-weight="bold"
                fill="white"
                text-anchor="middle"
                dominant-baseline="middle"
                class={"transition-all duration-300 ease-in-out #{if letter in @guessed_letters, do: "letter-reveal", else: ""}"}
                style={"opacity: #{if letter in @guessed_letters || @game_state == :lost, do: "1", else: "0"};"}
              >
                {String.upcase(letter)}
              </text>
              
    <!-- Underline -->
              <line
                x1="15"
                y1="65"
                x2="45"
                y2="65"
                stroke="white"
                stroke-width="3"
                stroke-linecap="round"
                class="transition-all duration-300 ease-in-out"
                style={"opacity: #{if letter in @guessed_letters || @game_state == :lost, do: "0.3", else: "1"};"}
              />
              
    <!-- Animation effect for correct guess -->
              <%= if letter in @guessed_letters && @game_state == :in_progress do %>
                <circle
                  cx="30"
                  cy="40"
                  r="0"
                  fill="none"
                  stroke="#48bb78"
                  stroke-width="3"
                  class="animate-ping"
                >
                  <animate
                    attributeName="r"
                    from="0"
                    to="30"
                    dur="0.5s"
                    begin="0s"
                    fill="freeze"
                    restart="never"
                  />
                  <animate
                    attributeName="opacity"
                    from="1"
                    to="0"
                    dur="0.5s"
                    begin="0s"
                    fill="freeze"
                    restart="never"
                  />
                </circle>
              <% end %>
              
    <!-- Shake animation for incorrect guess -->
              <%= if @game_state == :lost && letter not in @guessed_letters do %>
                <g class="animate-shake">
                  <text
                    x="30"
                    y="50"
                    font-size="30"
                    font-weight="bold"
                    fill="#f56565"
                    text-anchor="middle"
                    dominant-baseline="middle"
                    class="letter-reveal"
                  >
                    {String.upcase(letter)}
                  </text>
                </g>
              <% end %>
            </svg>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # Helper function to determine the background color of the letter box
  defp letter_background_color(letter, guessed_letters, game_state) do
    cond do
      # Green for win
      game_state == :won -> "#48bb78"
      # Red for unguessed letters in loss
      game_state == :lost && letter not in guessed_letters -> "#f56565"
      # Purple for correctly guessed letters
      letter in guessed_letters -> "#6366f1"
      # Default gray
      true -> "#4a5568"
    end
  end
end
