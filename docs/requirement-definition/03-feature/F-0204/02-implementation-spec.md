# 実装仕様

## 使用技術・ライブラリ
- **Docker & Docker Compose**: コンテナ統合管理
- **Node.js 18.x**: フロントエンド実行環境
- **Python 3.13.3**: バックエンド実行環境
- **ESLint・Prettier**: コード品質・フォーマット統一

## 既存リソース参照
- **フロントエンド設計**: [Next.js設計](../../02-tech/04-fe-architecture-phase2.md)
- **バックエンド設計**: [FastAPI設計](../../02-tech/05-be-architecture-phase2.md)
- **データベース設計**: [Supabase設計](../../02-tech/02-database-phase2.md)

## 実装タスクと工数

### Phase 1: Docker環境構築（4h）

1. **docker-compose.yml 作成**（60分）
   - フロントエンド・バックエンド・開発用DB設定
   - ポート設定: 3000（Next.js）・8000（FastAPI）
   - ボリュームマウント設定
   
2. **フロントエンドDockerfile**（45分）
   ```dockerfile
   FROM node:18-alpine
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci
   COPY . .
   CMD ["npm", "run", "dev"]
   ```

3. **バックエンドDockerfile**（45分）
   ```dockerfile
   FROM python:3.13.3-slim
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install -r requirements.txt
   COPY . .
   CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
   ```

4. **動作確認・最適化**（90分）
   - `docker-compose up` での正常起動確認
   - ホットリロード動作テスト
   - コンテナ間通信確認

### Phase 2: 環境変数・設定ファイル（2h）

5. **.env.example 作成**（30分）
   ```bash
   # Frontend
   NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...
   NEXT_PUBLIC_SUPABASE_URL=https://hdwdudvsncibvjtuoscr.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
   
   # Backend  
   SUPABASE_URL=https://hdwdudvsncibvjtuoscr.supabase.co
   SUPABASE_SERVICE_ROLE_KEY=eyJ...
   CLERK_SECRET_KEY=sk_...
   ```

6. **.dockerignore・.gitignore 更新**（30分）
   - Docker不要ファイル除外
   - 環境変数ファイルGit管理外設定

7. **環境変数読み込み設定**（60分）
   - Next.js環境変数設定
   - FastAPI環境変数読み込み
   - Supabase接続確認

### Phase 3: 開発ツール統一（2h）

8. **ESLint・Prettier設定**（60分）
   - Next.js用ESLint設定
   - Prettier設定統一
   - package.json scripts追加

9. **editorconfig設定**（30分）
   ```ini
   # .editorconfig
   [*]
   charset = utf-8
   end_of_line = lf
   indent_style = space
   indent_size = 2
   ```

10. **動作確認・ドキュメント作成**（30分）
    - 全環境での動作テスト
    - README開発手順追記

## 注意点・制約
- **ポート競合回避**: 3000・8000ポートが使用済みの場合は設定変更
- **Docker Desktop**: チーム全員でのDocker Desktop最新版インストール必須
- **メモリ設定**: Docker Desktop メモリ制限 4GB以上推奨
- **ファイル権限**: Windows環境でのマウント権限設定注意

## ファイル構成
```
zigzaglab-02/
├── docker-compose.yml          # Docker統合管理
├── .env.example               # 環境変数テンプレート
├── .dockerignore             # Docker除外設定
├── .editorconfig             # エディタ統一設定
├── frontend/
│   ├── Dockerfile
│   ├── .eslintrc.json
│   └── prettier.config.js
└── backend/
    ├── Dockerfile
    └── requirements.txt
```

## 開発コマンド
```bash
# 初回セットアップ・開発環境起動
docker-compose up --build

# 通常の開発環境起動
docker-compose up

# ログ確認
docker-compose logs -f

# 環境停止
docker-compose down
```