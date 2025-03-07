defmodule WordGuess.GameStatistics do
  @moduledoc """
  Manages game statistics for the WordGuess application.
  Tracks wins, losses, streaks, and other game-related statistics.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias WordGuess.Repo
  alias __MODULE__

  schema "game_statistics" do
    field :wins, :integer, default: 0
    field :losses, :integer, default: 0
    field :streak, :integer, default: 0
    field :total_games, :integer, default: 0
    field :best_streak, :integer, default: 0
    field :easy_wins, :integer, default: 0
    field :medium_wins, :integer, default: 0
    field :hard_wins, :integer, default: 0

    timestamps()
  end

  @doc """
  Creates a changeset for game statistics.
  """
  def changeset(stats, attrs) do
    stats
    |> cast(attrs, [
      :wins,
      :losses,
      :streak,
      :total_games,
      :best_streak,
      :easy_wins,
      :medium_wins,
      :hard_wins
    ])
    |> validate_required([
      :wins,
      :losses,
      :streak,
      :total_games,
      :best_streak,
      :easy_wins,
      :medium_wins,
      :hard_wins
    ])
    |> validate_number(:wins, greater_than_or_equal_to: 0)
    |> validate_number(:losses, greater_than_or_equal_to: 0)
    |> validate_number(:streak, greater_than_or_equal_to: 0)
    |> validate_number(:total_games, greater_than_or_equal_to: 0)
    |> validate_number(:best_streak, greater_than_or_equal_to: 0)
    |> validate_number(:easy_wins, greater_than_or_equal_to: 0)
    |> validate_number(:medium_wins, greater_than_or_equal_to: 0)
    |> validate_number(:hard_wins, greater_than_or_equal_to: 0)
  end

  @doc """
  Gets the current game statistics or creates a new record if none exists.
  """
  def get_or_create_stats do
    case Repo.one(from s in GameStatistics, limit: 1) do
      nil ->
        %GameStatistics{}
        |> changeset(%{
          wins: 0,
          losses: 0,
          streak: 0,
          total_games: 0,
          best_streak: 0,
          easy_wins: 0,
          medium_wins: 0,
          hard_wins: 0
        })
        |> Repo.insert()

      stats ->
        {:ok, stats}
    end
  end

  @doc """
  Updates the game statistics after a game is completed.
  """
  def update_stats(game_won, difficulty) do
    {:ok, stats} = get_or_create_stats()

    new_streak = calculate_new_streak(stats, game_won)
    best_streak = max(stats.best_streak, new_streak)

    difficulty_wins = calculate_difficulty_wins(stats, difficulty, game_won)

    attrs = %{
      wins: stats.wins + if(game_won, do: 1, else: 0),
      losses: stats.losses + if(game_won, do: 0, else: 1),
      streak: new_streak,
      total_games: stats.total_games + 1,
      best_streak: best_streak,
      easy_wins: if(difficulty == :easy, do: difficulty_wins, else: stats.easy_wins),
      medium_wins: if(difficulty == :medium, do: difficulty_wins, else: stats.medium_wins),
      hard_wins: if(difficulty == :hard, do: difficulty_wins, else: stats.hard_wins)
    }

    stats
    |> changeset(attrs)
    |> Repo.update()
  end

  # Calculate the new streak based on the game resul
  defp calculate_new_streak(stats, game_won) do
    if game_won, do: stats.streak + 1, else: 0
  end

  # Calculate the new win count for the specific difficulty
  defp calculate_difficulty_wins(stats, difficulty, game_won) do
    case difficulty do
      :easy -> stats.easy_wins + if game_won, do: 1, else: 0
      :medium -> stats.medium_wins + if game_won, do: 1, else: 0
      :hard -> stats.hard_wins + if game_won, do: 1, else: 0
    end
  end
end
