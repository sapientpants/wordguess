defmodule WordGuess.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        WordGuessWeb.Telemetry,
        # Start the Repo
        WordGuess.Repo,
        {DNSCluster, query: Application.get_env(:word_guess, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: WordGuess.PubSub},
        # Start the Finch HTTP client for sending emails
        {Finch, name: WordGuess.Finch},
        # Start a worker by calling: WordGuess.Worker.start_link(arg)
        # {WordGuess.Worker, arg},
        # Start to serve requests, typically the last entry
        WordGuessWeb.Endpoint
      ]
      |> List.flatten()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WordGuess.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordGuessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
