# Docker Compose Setup for WordGuess

This document provides detailed instructions for running the WordGuess application using Docker Compose.

## Prerequisites

- Docker Engine installed (version 20.10.0 or higher)
- Docker Compose installed (version 2.0.0 or higher)

## Quick Start

```bash
# Clone the repository (if you haven't already)
git clone <repository-url>
cd word_guess

# Build and start the containers in detached mode
docker compose up -d

# View the application logs
docker compose logs -f
```

The application will be available at [http://localhost:4000](http://localhost:4000).

## Docker Compose Commands

| Command | Description |
|---------|-------------|
| `docker compose up -d` | Build and start containers in detached mode |
| `docker compose down` | Stop and remove containers |
| `docker compose logs -f` | Follow the logs from all containers |
| `docker compose up -d --build` | Rebuild and restart containers |
| `docker compose exec web mix <command>` | Run a mix command in the web container |
| `docker compose exec db psql -U postgres -d word_guess_dev` | Access the PostgreSQL database |

## Container Architecture

The Docker Compose setup includes the following services:

1. **db**: PostgreSQL database
   - Stores game data and statistics
   - Persists data using a named volume

2. **web**: Phoenix application
   - Runs the Elixir/Phoenix application
   - Depends on the database service
   - Automatically runs migrations on startup

## Development Workflow

When developing with Docker Compose:

1. Make changes to your code
2. The changes will be automatically picked up (live reload)
3. If you add dependencies:
   - Update mix.exs
   - Run `docker compose exec web mix deps.get`

## Troubleshooting

- **Database connection issues**: Ensure the database container is healthy with `docker compose ps`
- **Application not starting**: Check logs with `docker compose logs web`
- **Port conflicts**: If port 4000 is already in use, modify the port mapping in docker-compose.yml 