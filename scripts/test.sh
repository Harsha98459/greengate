#!/usr/bin/env bash
set -euo pipefail

# Stop Git Bash from mangling Docker paths
export MSYS_NO_PATHCONV=1

IMAGE="${IMAGE:-greengate}"; TAG="${TAG:-latest}"
mkdir -p reports

echo ">>> Running pytest inside container"
docker run --rm --user root \
  -e PYTHONPATH=/app \
  -v "$PWD":/app -w /app \
  "${IMAGE}:${TAG}" \
  sh -c "pip install -q -r requirements-dev.txt && pytest -q --junitxml=reports/junit.xml"