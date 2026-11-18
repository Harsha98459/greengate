#!/usr/bin/env bash
set -euo pipefail
curl -fsS http://localhost:8000/health | tee /dev/stderr | grep -q '"status":"ok"'
echo "✅ Smoke test passed"
