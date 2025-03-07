defmodule WordGuess.GameStatisticsTest do
  use WordGuess.DataCase, async: true
  alias WordGuess.GameStatistics

  describe "changeset/2" do
    test "validates required fields" do
      changeset = GameStatistics.changeset(%GameStatistics{}, %{})

      assert changeset.valid? == true
      assert changeset.changes == %{}
    end

    test "validates number fields are non-negative" do
      changeset = GameStatistics.changeset(%GameStatistics{}, %{wins: -1})
      assert changeset.valid? == false
      assert "must be greater than or equal to 0" in errors_on(changeset).wins
    end
  end

  describe "get_or_create_stats/0" do
    test "creates new stats record if none exists" do
      # Ensure no stats exist
      Repo.delete_all(GameStatistics)

      {:ok, stats} = GameStatistics.get_or_create_stats()

      assert stats.wins == 0
      assert stats.losses == 0
      assert stats.streak == 0
      assert stats.total_games == 0
      assert stats.best_streak == 0
      assert stats.easy_wins == 0
      assert stats.medium_wins == 0
      assert stats.hard_wins == 0
    end

    test "returns existing stats if they exist" do
      # Create stats
      {:ok, created_stats} = GameStatistics.get_or_create_stats()

      # Update stats
      {:ok, _} = Repo.update(GameStatistics.changeset(created_stats, %{wins: 5}))

      # Get stats again
      {:ok, fetched_stats} = GameStatistics.get_or_create_stats()

      assert fetched_stats.wins == 5
    end
  end

  describe "update_stats/2" do
    test "updates stats correctly when game is won" do
      # Ensure clean state
      Repo.delete_all(GameStatistics)
      {:ok, _} = GameStatistics.get_or_create_stats()

      # Win a game on easy difficulty
      {:ok, stats} = GameStatistics.update_stats(true, :easy)

      assert stats.wins == 1
      assert stats.losses == 0
      assert stats.streak == 1
      assert stats.total_games == 1
      assert stats.best_streak == 1
      assert stats.easy_wins == 1
      assert stats.medium_wins == 0
      assert stats.hard_wins == 0
    end

    test "updates stats correctly when game is lost" do
      # Ensure clean state
      Repo.delete_all(GameStatistics)
      {:ok, _} = GameStatistics.get_or_create_stats()

      # Lose a game on medium difficulty
      {:ok, stats} = GameStatistics.update_stats(false, :medium)

      assert stats.wins == 0
      assert stats.losses == 1
      assert stats.streak == 0
      assert stats.total_games == 1
      assert stats.best_streak == 0
      assert stats.easy_wins == 0
      assert stats.medium_wins == 0
      assert stats.hard_wins == 0
    end

    test "updates streak correctly on consecutive wins and losses" do
      # Ensure clean state
      Repo.delete_all(GameStatistics)
      {:ok, _} = GameStatistics.get_or_create_stats()

      # Win 3 games in a row
      {:ok, _} = GameStatistics.update_stats(true, :easy)
      {:ok, _} = GameStatistics.update_stats(true, :medium)
      {:ok, stats} = GameStatistics.update_stats(true, :hard)

      assert stats.streak == 3
      assert stats.best_streak == 3

      # Lose a game, breaking the streak
      {:ok, stats} = GameStatistics.update_stats(false, :medium)

      assert stats.streak == 0
      assert stats.best_streak == 3

      # Win 2 more games
      {:ok, _} = GameStatistics.update_stats(true, :easy)
      {:ok, stats} = GameStatistics.update_stats(true, :medium)

      assert stats.streak == 2
      assert stats.best_streak == 3
    end
  end
end
