# バックエンド開発環境用 Dockerfile
FROM python:3.13.3-slim

# 作業ディレクトリ設定
WORKDIR /app

# システムパッケージ更新・必要ツールインストール
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# requirements.txtコピー（キャッシュ効率化）
COPY requirements.txt .

# Python依存関係インストール
RUN pip install --no-cache-dir -r requirements.txt

# ソースコードコピー
COPY . .

# ポート公開
EXPOSE 8000

# 環境変数設定
ENV PYTHONPATH=/app/src
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 作業ディレクトリをsrcに設定
WORKDIR /app/src

# FastAPI開発サーバー起動（ホットリロード有効）
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]