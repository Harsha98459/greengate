#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-greengate}"; TAG="${TAG:-latest}"
REGISTRY="${REGISTRY:?REGISTRY env var required}"   # e.g. docker.io/youruser

docker tag "${IMAGE}:${TAG}" "${REGISTRY}/${IMAGE}:${TAG}"
docker tag "${IMAGE}:${TAG}" "${REGISTRY}/${IMAGE}:latest"
docker push "${REGISTRY}/${IMAGE}:${TAG}"
docker push "${REGISTRY}/${IMAGE}:latest"
