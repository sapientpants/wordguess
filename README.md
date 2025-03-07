# WordGuess

A classic word guessing game built with Phoenix LiveView, styled with Tailwind CSS and DaisyUI components.

## Running with Docker

You can easily run the application using Docker Compose:

```bash
# Build and start the containers
docker compose up -d

# View logs
docker compose logs -f
```

The application will be available at [http://localhost:4000](http://localhost:4000).

## Running Locally

To start your Phoenix server without Docker:

1. Ensure you have Elixir, Erlang, and PostgreSQL installed
2. Run `mix setup` to install and setup dependencies
3. Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker Commands

- Start containers: `docker compose up -d`
- Stop containers: `docker compose down`
- View logs: `docker compose logs -f`
- Access PostgreSQL: `docker exec -it word_guess_postgres psql -U postgres -d word_guess_dev`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
