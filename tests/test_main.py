from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_check_returns_healthy_status():
    response = client.get("/health")

    assert response.status_code == 200
    payload = response.json()
    assert payload["status"] == "healthy"
    assert payload["service"] == "pulsecheck"
    assert "timestamp" in payload


def test_root_points_to_health_endpoint():
    response = client.get("/")

    assert response.status_code == 200
    assert response.json()["health_url"] == "/health"