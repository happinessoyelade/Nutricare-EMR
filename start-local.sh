#!/usr/bin/env bash
# Start local Docker Compose environment (Postgres + app)
set -e
echo "Starting local dev stack..."
docker-compose up --build
