#!/usr/bin/env bash
set -euo pipefail
export IMAGE="${IMAGE:-greengate}"; export TAG="${TAG:-latest}"
docker compose -f docker-compose.yml up -d --build
docker compose -f docker-compose.yml ps
