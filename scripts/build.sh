#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-greengate}"
TAG="${TAG:-latest}"

echo ">>> Building ${IMAGE}:${TAG}"
docker build -t "${IMAGE}:${TAG}" -t "${IMAGE}:latest" .
docker image ls | grep "${IMAGE}"
