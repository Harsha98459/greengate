#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-greengate}"; TAG="${TAG:-latest}"
CONTAINER="${CONTAINER:-greengate-ci}"
THRESHOLD="${THRESHOLD:-1000}"

docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER" \
  -p 8000:8000 \
  -e CARBON_THRESHOLD="$THRESHOLD" \
  "${IMAGE}:${TAG}"
echo ">>> Container started, waiting for health..."
for i in $(seq 1 20); do
  if curl -fsS http://localhost:8000/health >/dev/null 2>&1; then echo "healthy"; exit 0; fi
  sleep 2
done
echo "container failed to become healthy"; docker logs "$CONTAINER"; exit 1
