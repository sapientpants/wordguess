defmodule WordGuessWeb.PageController do
  use WordGuessWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def game(conn, _params) do
    render(conn, :game)
  end
end
