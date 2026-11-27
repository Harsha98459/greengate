#!/usr/bin/env bash
set -euo pipefail

# Stop Git Bash from mangling Docker paths
export MSYS_NO_PATHCONV=1

echo ">>> Waiting for deployed application to be ready..."
# Wait up to 30 seconds for the app to respond
for i in {1..15}; do
    if curl -fsS http://localhost:8000/health >/dev/null 2>&1; then
        echo "✅ Smoke test passed! App is running smoothly."
        exit 0
    fi
    sleep 2
done

echo "❌ Smoke test failed: Could not reach the application."
exit 1