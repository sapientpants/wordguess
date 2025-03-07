#!/bin/bash

# Stop any running containers
echo "Stopping any running containers..."
docker compose down

# Build and run the test service
echo "Building and running tests..."
docker compose run --rm test

# Clean up
echo "Cleaning up..."
docker compose down

echo "Tests completed!" 