# 技術スタック概要

## リビジョン履歴

| バージョン | 日付 | 変更者 | 変更内容 | 承認状況 | 承認者 | 次回レビュー予定 |
|------------|------|--------|----------|----------|--------|------------------|
| v1.0 | 2025-07-20 | techPM | 初版作成 | 🔄 レビュー中 | 橋本さん（クライアント代表者） | 次回ミーティング時 |
| - | - | - | - | - | - | - |
| - | - | - | - | - | - | - |

## 1. 技術アーキテクチャ概要

### 1.1 システム構成図

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   (Next.js)     │◄──►│   (FastAPI)     │◄──►│   (Supabase)    │
│   Vercel        │    │   Railway       │    │   PostgreSQL    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         ▲                        ▲                        ▲
         │                        │                        │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CI/CD         │    │   Container     │    │   Auth & API    │
│   GitHub Actions│    │   Docker        │    │   Supabase      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 1.2 技術選定方針

**開発効率重視**: 一人開発に適したモダンな技術スタック  
**コスト効率**: オープンソース中心、低コストでスケーラブル  
**保守性**: TypeScript全面採用による型安全性確保  
**デプロイ容易性**: クラウドネイティブな構成

## 2. フロントエンド技術

### 2.1 コア技術スタック

| 技術 | バージョン | 用途 | 選定理由 |
|------|------------|------|----------|
| **Next.js** | 14.x | Reactフレームワーク | SSG/SSR対応、SEO最適化、パフォーマンス |
| **TypeScript** | 5.x | 型システム | 型安全性、開発効率、バグ削減 |
| **Tailwind CSS** | 3.x | CSSフレームワーク | 高速開発、レスポンシブ対応、保守性 |
| **shadcn/ui** | Latest | UIコンポーネント | 高品質コンポーネント、カスタマイズ性 |

### 2.2 フェーズ別構成

#### 第1フェーズ（展示会向けLP）
```typescript
// 静的エクスポート構成
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  }
}
```

#### 第2フェーズ（toB向けHP）
```typescript
// SSG/ISR構成
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['supabase.co']
  },
  experimental: {
    appDir: true
  }
}
```

#### 第3・4フェーズ（toC向けEC）
```typescript
// フルスタック構成
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: ['supabase.co', 'zigzaglab.biz']
  },
  experimental: {
    appDir: true,
    serverActions: true
  }
}
```

### 2.3 UI/UXライブラリ

| ライブラリ | 用途 | 備考 |
|------------|------|------|
| **Radix UI** | プリミティブコンポーネント | shadcn/uiの基盤 |
| **Lucide React** | アイコン | 軽量、豊富なアイコンセット |
| **Framer Motion** | アニメーション | マイクロインタラクション |
| **React Hook Form** | フォーム管理 | バリデーション、パフォーマンス |
| **Zod** | スキーマバリデーション | 型安全なバリデーション |

## 3. バックエンド技術

### 3.1 コア技術スタック

| 技術 | バージョン | 用途 | 選定理由 |
|------|------------|------|----------|
| **FastAPI** | 0.104.x | APIフレームワーク | 高速、自動ドキュメント生成、型安全 |
| **Python** | 3.11+ | プログラミング言語 | FastAPI対応、豊富なライブラリ |
| **Pydantic** | 2.x | データバリデーション | FastAPI統合、型安全性 |
| **SQLAlchemy** | 2.x | ORM | Supabase PostgreSQL対応 |

### 3.2 認証・セキュリティ

| 技術 | 用途 | 備考 |
|------|------|------|
| **Supabase Auth** | 認証基盤 | JWT、多要素認証対応 |
| **python-jose** | JWT処理 | トークン検証・生成 |
| **passlib** | パスワードハッシュ化 | bcrypt対応 |
| **python-multipart** | ファイルアップロード | 商品画像対応 |

### 3.3 API設計

```python
# FastAPI基本構成
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client

app = FastAPI(
    title="ZIGZAGLAB API",
    description="缶バッジ・アクリルグッズ販売API",
    version="1.0.0"
)

# CORS設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://zigzaglab.biz"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## 4. データベース・ストレージ

### 4.1 Supabase構成

| サービス | 用途 | 特徴 |
|----------|------|------|
| **PostgreSQL** | メインDB | 高性能、ACID準拠 |
| **Supabase Auth** | ユーザー認証 | OAuth、RLS対応 |
| **Supabase Storage** | ファイル保存 | 商品画像、資料保存 |
| **Supabase Realtime** | リアルタイム通信 | 在庫更新、通知 |

### 4.2 データベーススキーマ例

```sql
-- 商品テーブル
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description TEXT,
  image_url TEXT,
  stock_quantity INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 注文テーブル
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  status VARCHAR(50) DEFAULT 'pending',
  total_amount DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## 5. インフラ・デプロイメント

### 5.1 コンテナ化（Docker）

```dockerfile
# Frontend Dockerfile
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM base AS build
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/out /usr/share/nginx/html
```

```dockerfile
# Backend Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### 5.2 デプロイメント戦略

| フェーズ | Frontend | Backend | 理由 |
|----------|----------|---------|------|
| 第1・2フェーズ | Vercel | - | 静的サイト、高速配信 |
| 第3・4フェーズ | Vercel | Railway | スケーラビリティ、コスト効率 |

### 5.3 環境管理

```yaml
# docker-compose.yml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_SUPABASE_URL=${SUPABASE_URL}
      - NEXT_PUBLIC_SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
  
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - SUPABASE_URL=${SUPABASE_URL}
      - SUPABASE_SERVICE_KEY=${SUPABASE_SERVICE_KEY}
    depends_on:
      - db
```

## 6. CI/CD・自動化

### 6.1 GitHub Actions設定

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run build
      - run: npm run test
      
  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install -r requirements.txt
      - run: pytest
      - run: docker build -t backend .
```

### 6.2 品質管理

| ツール | 用途 | 設定 |
|--------|------|------|
| **ESLint** | コード品質 | Next.js推奨設定 |
| **Prettier** | コードフォーマット | 統一ルール |
| **Husky** | Git hooks | pre-commit検証 |
| **pytest** | バックエンドテスト | FastAPI対応 |
| **Jest** | フロントエンドテスト | React Testing Library |

## 7. パフォーマンス・監視

### 7.1 パフォーマンス最適化

| 項目 | 技術・手法 | 効果 |
|------|------------|------|
| **画像最適化** | Next.js Image | 自動WebP変換、遅延読み込み |
| **コード分割** | Dynamic imports | 初期読み込み時間短縮 |
| **キャッシュ戦略** | ISR, CDN | ページ表示速度向上 |
| **CSS最適化** | Tailwind CSS | 未使用CSS除去 |

### 7.2 監視・分析

| サービス | 用途 | 備考 |
|----------|------|------|
| **Vercel Analytics** | Webパフォーマンス | Core Web Vitals |
| **Supabase Dashboard** | DB監視 | クエリ最適化 |
| **Google Analytics** | ユーザー行動分析 | GA4対応 |
| **Sentry** | エラー監視 | フロント・バック統合 |

## 8. セキュリティ

### 8.1 セキュリティ対策

| 項目 | 実装方法 | 詳細 |
|------|----------|------|
| **認証** | Supabase Auth | JWT、RLS |
| **HTTPS** | Vercel/Railway | 自動SSL証明書 |
| **CORS** | FastAPI | オリジン制限 |
| **入力検証** | Zod + Pydantic | フロント・バック両方 |
| **SQL Injection対策** | SQLAlchemy ORM | パラメータ化クエリ |

### 8.2 データ保護

```python
# Row Level Security (RLS) 例
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "商品閲覧" ON products
  FOR SELECT USING (is_active = true);

CREATE POLICY "管理者のみ編集" ON products
  FOR ALL USING (auth.role() = 'admin');
```

## 9. 開発環境・ツール

### 9.1 開発ツール

| ツール | 用途 | 設定 |
|--------|------|------|
| **VS Code** | IDE | TypeScript、Python拡張 |
| **Thunder Client** | API テスト | VS Code統合 |
| **Supabase CLI** | DB管理 | ローカル開発 |
| **Docker Desktop** | コンテナ管理 | 開発環境統一 |

### 9.2 パッケージ管理

```json
// package.json (Frontend)
{
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "typescript": "^5.0.0",
    "@supabase/supabase-js": "^2.38.0",
    "tailwindcss": "^3.3.0",
    "@radix-ui/react-dialog": "^1.0.5"
  },
  "devDependencies": {
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "@types/node": "^20.0.0"
  }
}
```

```txt
# requirements.txt (Backend)
fastapi==0.104.1
uvicorn[standard]==0.24.0
supabase==2.0.2
sqlalchemy==2.0.23
pydantic==2.5.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
pytest==7.4.3
```

## 10. 将来拡張性

### 10.1 スケーラビリティ対応

| 項目 | 現在 | 将来対応 |
|------|------|----------|
| **Frontend** | Vercel | CDN拡張 |
| **Backend** | Railway単一インスタンス | 水平スケーリング |
| **Database** | Supabase共有 | 専用インスタンス |
| **ファイルストレージ** | Supabase Storage | AWS S3連携 |

### 10.2 技術的負債対策

- **定期的な依存関係更新**: Dependabot活用
- **コードレビュー**: GitHub Pull Request
- **リファクタリング**: 四半期ごとの技術的改善
- **ドキュメント更新**: 実装と同時更新