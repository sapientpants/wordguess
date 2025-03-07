defmodule WordGuess.Repo.Migrations.CreateGameStatistics do
  use Ecto.Migration

  def change do
    create table(:game_statistics) do
      add :wins, :integer, default: 0, null: false
      add :losses, :integer, default: 0, null: false
      add :streak, :integer, default: 0, null: false
      add :total_games, :integer, default: 0, null: false
      add :best_streak, :integer, default: 0, null: false
      add :easy_wins, :integer, default: 0, null: false
      add :medium_wins, :integer, default: 0, null: false
      add :hard_wins, :integer, default: 0, null: false

      timestamps()
    end
  end
end
