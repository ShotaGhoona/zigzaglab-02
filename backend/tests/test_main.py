import pytest
from fastapi.testclient import TestClient
import sys
import os

# srcディレクトリをPythonパスに追加
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from main import app

client = TestClient(app)

def test_root_endpoint():
    """ルートエンドポイントのテスト"""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "ZIGZAGLAB API is running"}

def test_health_check():
    """ヘルスチェックエンドポイントのテスト"""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

def test_api_docs():
    """API ドキュメントエンドポイントのテスト"""
    response = client.get("/docs")
    assert response.status_code == 200

def test_openapi_json():
    """OpenAPI スキーマのテスト"""
    response = client.get("/openapi.json")
    assert response.status_code == 200
    assert "openapi" in response.json()