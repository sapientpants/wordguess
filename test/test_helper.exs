ExUnit.start()

# Only set sandbox mode if the Repo is started
try do
  Ecto.Adapters.SQL.Sandbox.mode(WordGuess.Repo, :manual)
rescue
  _ -> :ok
end
