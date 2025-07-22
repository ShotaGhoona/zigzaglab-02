# ZIGZAGLAB Backend API

FastAPI + Supabase SDK + Clerk認証によるバックエンドAPI

## 開発環境構築

### 1. 仮想環境作成・有効化
```bash
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 2. 依存関係インストール
```bash
pip install -r requirements.txt
```

### 3. 環境変数設定
`.env` ファイルに以下を設定：
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...your-service-role-key
CLERK_SECRET_KEY=sk_...your-clerk-secret-key
ADMIN_EMAILS=admin1@example.com,admin2@example.com,admin3@example.com
```

### 4. 開発サーバー起動
```bash
cd src
uvicorn main:app --reload
```

## API ドキュメント

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## テスト実行

```bash
pytest
```

## コードフォーマット

```bash
black src/
flake8 src/
```

## プロジェクト構造

```
backend/
├── src/
│   ├── main.py              # FastAPI アプリケーション
│   ├── config/
│   │   ├── database.py      # Supabase 接続設定
│   │   ├── settings.py      # 環境変数管理
│   │   └── auth.py          # Clerk設定
│   ├── routers/             # API エンドポイント
│   ├── services/            # ビジネスロジック
│   ├── repositories/        # データアクセス
│   ├── schemas/             # Pydantic スキーマ
│   └── middleware/          # 認証ミドルウェア
├── tests/                   # テスト
├── requirements.txt         # 依存関係
├── .env                     # 環境変数
└── pytest.ini              # テスト設定
```

## API 仕様
詳細なAPI仕様は[Phase2 API設計書](../docs/requirement-definition/02-tech/03-api-phase2.md)を参照