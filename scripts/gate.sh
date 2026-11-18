#!/usr/bin/env bash
set -euo pipefail
URL="${GATE_URL:-http://localhost:8000/gate}"

echo ">>> Querying carbon gate"
RESP=$(curl -fsS "$URL")
echo "$RESP"

if echo "$RESP" | grep -q '"allowed": *true'; then
  echo "✅ Grid is clean enough — deploy approved"
  exit 0
else
  echo "🛑 Grid is too dirty — deploy DEFERRED (this is the gate working)"
  exit 1
fi
