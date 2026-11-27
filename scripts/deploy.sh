#!/usr/bin/env bash
set -euo pipefail

# Stop Git Bash from mangling Docker paths
export MSYS_NO_PATHCONV=1

export IMAGE="${IMAGE:-greengate}"; export TAG="${TAG:-latest}"

echo ">>> Deploying with Docker Compose..."
# Check if 'docker compose' (v2) is available, otherwise use 'docker-compose' (v1)
if docker compose version >/dev/null 2>&1; then
    docker compose up -d --build
    docker compose ps
else
    docker-compose up -d --build
    docker-compose ps
fi