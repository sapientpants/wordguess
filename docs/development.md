# WordGuess Project Guide

## Running with Docker Compose
- Build and start: `docker compose up -d` (detached mode)
- View logs: `docker compose logs -f` (follow logs)
- Stop containers: `docker compose down`
- Rebuild containers: `docker compose up -d --build`
- Access PostgreSQL: `docker compose exec db psql -U postgres -d word_guess_dev`

## Code Style
- Use Elixir's builtin formatter (`mix format`) religiously
- Follow Phoenix conventions for web components
- Keep modules short and focused on a single responsibility
- Group aliases alphabetically and split by source (stdlib vs deps vs project)
- Use pattern matching over conditional logic
- Prefer pipe operator (`|>`) for data transformations
- Use explicit types with `@type` and `@spec` for public functions
- Name modules with CamelCase and functions with snake_case
- Prefer explicit error handling with pattern matching or `with` statements
- Use consistent docstrings for public functions