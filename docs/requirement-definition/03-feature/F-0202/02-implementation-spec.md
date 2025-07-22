# 実装仕様

## 使用技術・ライブラリ
- **FastAPI**: Python 3.13.3 + Pydantic v2
- **Supabase SDK**: データアクセス（python supabase クライアント）
- **Clerk**: JWT認証検証
- **uvicorn**: ASGI サーバー（開発・本番）

## 既存リソース参照
- **データベース設計**: [Phase2データベース設計](../../02-tech/02-database-phase2.md)
- **API仕様**: [Phase2 API設計](../../02-tech/03-api-phase2.md)
- **バックエンドアーキテクチャ**: [Phase2 バックエンド設計](../../02-tech/05-be-architecture-phase2.md)
- **技術スタック概要**: [技術選定理由](../../02-tech/01-tech-overview.md#3-バックエンド)

## 実装タスクと工数

### Phase 1: プロジェクト基盤構築（3h）

1. **FastAPI プロジェクト作成**（1h）
   ```bash
   mkdir backend && cd backend
   python -m venv venv
   source venv/bin/activate  # Windows: venv\\Scripts\\activate
   pip install fastapi uvicorn python-dotenv
   ```

2. **ディレクトリ構造作成**（1h）
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
   ├── requirements.txt         # 依存関係
   ├── .env                     # 環境変数
   └── pytest.ini              # テスト設定
   ```

3. **基本設定・CORS**（1h）
   - main.py でFastAPI アプリ初期化
   - CORS ミドルウェア設定
   - ヘルスチェックエンドポイント作成

### Phase 2: データベース・認証設定（2h）

4. **Supabase SDK セットアップ**（1h）
   ```bash
   pip install supabase
   ```
   - database.py で接続設定
   - 基本Repository クラス作成
   - テスト接続確認

5. **Clerk認証ミドルウェア**（1h）
   ```bash
   pip install pyjwt cryptography
   ```
   - JWT 検証ミドルウェア実装
   - 管理者権限チェック機能
   - 認証不要エンドポイント設定

### Phase 3: 開発環境整備（2h）

6. **依存関係・設定ファイル**（1h）
   - requirements.txt 作成
   - .env テンプレート作成
   - settings.py 環境変数管理

7. **開発ツール設定**（1h）
   ```bash
   pip install pytest pytest-asyncio black flake8
   ```
   - pytest 設定・サンプルテスト
   - コードフォーマッター設定
   - 開発サーバー起動確認

## 注意点・制約
- Supabase SDK は SQLAlchemy を使わず直接使用
- RLS（Row Level Security）は Supabase 側で設定済み前提
- Clerk認証は最小限実装（管理者3名のみ）
- エラーハンドリングは統一フォーマット必須
- 本番デプロイ用設定は後フェーズで実装

## 依存関係インストール
```bash
# 基本依存関係
pip install fastapi uvicorn python-dotenv pydantic

# Supabase
pip install supabase

# 認証
pip install pyjwt cryptography

# 開発用依存関係  
pip install pytest pytest-asyncio black flake8
```

## 設定ファイルテンプレート

### requirements.txt
```
fastapi==0.104.1
uvicorn[standard]==0.24.0
python-dotenv==1.0.0
pydantic==2.5.0
supabase==2.2.1
pyjwt==2.8.0
cryptography==41.0.8

# 開発用
pytest==7.4.3
pytest-asyncio==0.21.1
black==23.11.0
flake8==6.1.0
```

### .env テンプレート
```bash
# Supabase
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Clerk認証
CLERK_SECRET_KEY=sk_...

# 管理者
ADMIN_EMAILS=email1@example.com,email2@example.com,email3@example.com

# 開発設定
DEBUG=True
HOST=0.0.0.0
PORT=8000
```

### main.py 基本構造
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config.settings import settings

app = FastAPI(
    title="ZIGZAGLAB API",
    description="ZIGZAGLAB Backend API",
    version="1.0.0"
)

# CORS設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ヘルスチェック
@app.get("/")
async def root():
    return {"message": "ZIGZAGLAB API is running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```