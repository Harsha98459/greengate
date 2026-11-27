#!/usr/bin/env bash
set -euo pipefail

# Stop Git Bash from mangling Docker paths
export MSYS_NO_PATHCONV=1

curl -fsS http://localhost:8000/health | tee /dev/stderr | grep -q '"status":"ok"'
echo "✅ Smoke test passed"