# Phase2 バックエンド アーキテクチャ設計書

## リビジョン履歴

| Version | Date | Author | Summary | Status | Reviewer |
|------------|------|--------|----------|----------|--------|
| v1.0 | 2025-07-22 | 山下 | Phase2版初版作成 | 🔄 レビュー中 | 橋本 |

---

## 1. アーキテクチャ決定事項

### 1.1 技術スタック
- **FastAPI** (Python 3.11) + Pydantic
- **Supabase Python SDK** (SQLAlchemy不使用)
- **Clerk JWT認証** (最小限の検証のみ)
- **Railway** (デプロイ)

### 1.2 重要な設計決定
- **データアクセス**: Supabase Python SDK + RLS自動適用
- **認証**: Clerk JWT検証（管理者3名のみ）
- **アーキテクチャ**: Router → Service → Repository
- **API**: フロントエンド直接呼び出し対応（CORS設定）
- **セキュリティ**: RLS + JWT検証で二重保護

---

## 2. ディレクトリ構造

### 2.1 ファイル配置ルール
```
backend/src/
├── main.py                     # FastAPIアプリケーション + CORS設定
├── config/
│   ├── database.py             # Supabase接続設定
│   ├── settings.py             # 環境変数管理
│   └── auth.py                 # Clerk JWT検証設定
├── routers/                    # APIエンドポイント（各機能別）
│   ├── news.py                 # GET /news, POST /admin/news
│   ├── products.py             # GET /products, POST /admin/products
│   ├── inquiries.py            # POST /inquiries, GET /admin/inquiries
│   └── files.py                # POST /admin/files/upload
├── services/                   # ビジネスロジック（Repository呼び出し）
│   ├── news_service.py
│   └── product_service.py
├── repositories/               # データアクセス（Supabase SDK使用）
│   ├── base_repository.py      # 共通CRUD操作
│   └── news_repository.py
├── schemas/                    # Pydantic（リクエスト/レスポンス）
│   ├── news.py
│   └── common.py
└── middleware/                 # JWT認証ミドルウェア
    └── auth.py
```

### 2.2 レイヤー責任
- **Router**: HTTPリクエスト/レスポンス + バリデーション
- **Service**: ビジネスロジック（複数Repository呼び出し可）
- **Repository**: Supabase SDK直接呼び出し
- **RLS**: データベースレベルでの自動権限制御

---

## 3. データアクセス設計

### 3.1 Supabase SDK使用方針
- **SQLAlchemy使わない**: `supabase.table("tablename")`で直接操作
- **RLS自動適用**: JWTに基づいて自動でデータ絞り込み
- **型安全性**: `supabase gen types`で型生成活用

### 3.2 Repository パターン
- **BaseRepository**: 共通CRUD（find_all, create, update, delete）
- **具体Repository**: テーブル固有ロジック（find_published等）
- **依存性注入**: FastAPI Dependsで注入

---

## 4. API設計

### 4.1 エンドポイント構成ルール
```
公開API（認証不要）:
- GET /api/v1/news              # 公開ニュース一覧
- GET /api/v1/news/{slug}       # 公開ニュース詳細
- GET /api/v1/products          # 公開商品一覧
- POST /api/v1/inquiries        # 問い合わせ送信

管理API（JWT必須）:
- GET /api/v1/admin/news        # 管理者向けニュース一覧
- POST /api/v1/admin/news       # ニュース作成
- PUT /api/v1/admin/news/{id}   # ニュース更新
- POST /api/v1/admin/files/upload # ファイルアップロード
```

### 4.2 レスポンス統一
- **成功**: `{"success": true, "data": {...}}`
- **エラー**: `{"success": false, "error": {"code": "", "message": ""}}`
- **ページネーション**: `{"data": {...}, "pagination": {...}}`

---

## 5. 認証設計

### 5.1 認証フロー
```
1. フロントエンド: Clerkから JWT取得
2. FastAPI: Authorization Bearer {jwt} で受信
3. middleware/auth.py: JWT検証（Clerk公開鍵）
4. 管理者チェック: email in ADMIN_EMAILS
5. RLS: JWTペイロードで自動データ絞り込み
```

### 5.2 管理者限定API
- `/admin/*` 全エンドポイント
- `Depends(verify_admin)` で保護
- 3名のメールアドレス限定

---

## 6. ファイル管理設計

### 6.1 アップロード方針
- **直接アップロード**: フロントエンド → Supabase Storage
- **メタデータ管理**: FastAPI → PostgreSQL files テーブル
- **URL生成**: `supabase.storage.get_public_url()`

### 6.2 ファイル構造
```
Supabase Storage:
files/
├── news/{news_id}/image1.jpg
├── products/{product_id}/image1.jpg
└── temp/{temp_id}/upload.jpg   # 一時アップロード
```

---

## 7. エラーハンドリング

### 7.1 エラー統一
- **ValidationError**: 400 + field情報
- **AuthenticationError**: 401 + 再認証要求
- **AuthorizationError**: 403 + 権限不足
- **NotFoundError**: 404 + リソース情報
- **ServerError**: 500 + 汎用メッセージ

### 7.2 ログ設定
- **INFO**: API呼び出し + 処理時間
- **WARNING**: バリデーションエラー
- **ERROR**: サーバーエラー + スタックトレース

---

## 8. 環境設定

### 8.1 必須環境変数
```bash
# .env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...        # RLS回避用
CLERK_JWT_PUBLIC_KEY=-----BEGIN...       # JWT検証用
ADMIN_EMAILS=email1@example.com,email2@example.com,email3@example.com
```

### 8.2 CORS設定
```python
# main.py
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://zigzaglab.com", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 9. デプロイ設定

### 9.1 Railway設定
- **Python 3.11**: `runtime.txt`
- **依存関係**: `requirements.txt`
- **起動コマンド**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
- **環境変数**: Railway Dashboard で設定

### 9.2 ヘルスチェック
- **GET /health**: データベース接続チェック
- **GET /**: API稼働確認

---

**更新日**: 2025年7月22日  
**ステータス**: v1.0・Phase2対応  
**重要**: コーダーは迷わず上記ルールに従って実装すること