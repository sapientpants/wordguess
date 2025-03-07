#!/bin/bash

# Stop any running containers
echo "Stopping any running containers..."
docker compose down

# Build and run tests in the web container
echo "Building and running tests..."
docker compose run --rm -e MIX_ENV=test web sh -c "mix deps.get && mix ecto.create && mix ecto.migrate && mix test"

# Clean up
echo "Cleaning up..."
docker compose down

echo "Tests completed!" 