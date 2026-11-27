#!/usr/bin/env python3
import datetime
import os
import time

import httpx
from fastapi import FastAPI, Query

app = FastAPI(title="GreenGate", version="1.0.0")

CARBON_API = os.getenv("CARBON_API_URL", "https://api.carbonintensity.org.uk/intensity")
THRESHOLD = int(os.getenv("CARBON_THRESHOLD", "200"))
CACHE_TTL = int(os.getenv("CACHE_TTL", "300"))
_cache = {"ts": 0, "data": None}


@app.get("/health")
def health():
    return {
        "status": "ok",
        "service": "greengate",
        "time": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    }


def fetch_intensity():
    if time.time() - _cache["ts"] < CACHE_TTL and _cache["data"]:
        return _cache["data"]
    try:
        r = httpx.get(CARBON_API, timeout=5)
        r.raise_for_status()
        item = r.json()["data"][0]["intensity"]
        data = {
            "intensity": item["actual"] or item["forecast"],
            "index": item["index"],
            "source": "live",
        }
    except Exception:  # noqa: BLE001
        data = {"intensity": 150, "index": "moderate", "source": "fallback"}
    _cache.update(ts=time.time(), data=data)
    return data


@app.get("/intensity")
def intensity():
    return fetch_intensity()


@app.get("/gate")
def gate(threshold: int = Query(default=None)):
    t = threshold if threshold is not None else THRESHOLD
    d = fetch_intensity()
    allowed = d["intensity"] <= t
    return {
        "allowed": allowed,
        "intensity": d["intensity"],
        "threshold": t,
        "index": d["index"],
        "source": d["source"],
        "recommendation": "deploy" if allowed else "defer",
    }