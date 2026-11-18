from fastapi.testclient import TestClient
from app.main import app, _cache

client = TestClient(app)

def test_health():
    r = client.get("/health")
    assert r.status_code == 200 and r.json()["status"] == "ok"

def test_gate_allows_when_grid_is_clean():
    _cache.update(ts=0, data=None)
    r = client.get("/gate?threshold=10000")
    body = r.json()
    assert r.status_code == 200
    assert body["allowed"] is True

def test_gate_blocks_when_threshold_is_low():
    _cache.update(ts=0, data=None)
    r = client.get("/gate?threshold=1")
    body = r.json()
    assert body["allowed"] is False
    assert body["recommendation"] == "defer"
