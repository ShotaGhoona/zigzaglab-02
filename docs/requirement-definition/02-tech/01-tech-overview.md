# 技術スタック概要


## リビジョン履歴

| バージョン | 日付 | 変更者 | 変更内容 | 承認状況 | 承認者 | 次回レビュー予定 |
|------------|------|--------|----------|----------|--------|------------------|
| v1.0 | 2025-07-20 | techPM | 初版作成 | 🔄 レビュー中 | 橋本さん（クライアント代表者） | 次回ミーティング時 |

## 1. システム構成

```
Frontend (Next.js) ◄──► Backend (FastAPI) ◄──► Database (Supabase)
    Vercel                   Railway                PostgreSQL
```

**技術選定方針**: 一人開発対応・コスト効率・TypeScript型安全性・デプロイ容易性

## 2. フロントエンド

| 技術 | 用途 | 理由 |
|------|------|------|
| **Next.js 14** | Reactフレームワーク | SSG/SSR、SEO対応 |
| **TypeScript** | 型システム | 型安全性、開発効率 |
| **Tailwind CSS** | CSSフレームワーク | 高速開発、レスポンシブ |
| **shadcn/ui** | UIコンポーネント | 高品質、カスタマイズ性 |

**フェーズ別構成**:
- 第1フェーズ: 静的エクスポート
- 第2フェーズ: SSG/ISR
- 第3・4フェーズ: フルスタック

## 3. バックエンド

| 技術 | 用途 | 理由 |
|------|------|------|
| **FastAPI** | APIフレームワーク | 高速、自動ドキュメント生成 |
| **Python 3.11** | プログラミング言語 | FastAPI対応 |
| **Pydantic** | データバリデーション | 型安全性 |
| **SQLAlchemy** | ORM | PostgreSQL対応 |

## 4. データベース・認証

**Supabase**:
- PostgreSQL (メインDB)
- Auth (JWT認証)
- Storage (画像保存)
- Realtime (通知)

## 5. インフラ・デプロイ

| 環境 | Frontend | Backend |
|------|----------|---------|
| 開発 | Docker | Docker |
| 本番 | Vercel | Railway |

**CI/CD**: GitHub Actions (テスト・ビルド・デプロイ自動化)

## 6. セキュリティ

- **認証**: Supabase Auth (JWT)
- **HTTPS**: 自動SSL証明書
- **入力検証**: Zod + Pydantic
- **DB**: Row Level Security (RLS)

## 7. 開発ツール

- **IDE**: VS Code
- **API テスト**: Thunder Client
- **DB管理**: Supabase CLI
- **コンテナ**: Docker Desktop
- **品質管理**: ESLint, Prettier, Jest, pytest
