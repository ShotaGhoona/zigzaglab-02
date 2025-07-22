# 技術スタック概要

## リビジョン履歴

| Version | Date | Author | Summary | Status | Reviewer |
|------------|------|--------|----------|----------|--------|
| v1.0 | 2025-07-20 | techPM | 初版作成 | 🔄 レビュー中 | 橋本さん |
| v1.1 | 2025-07-22 | techPM | Clerk統一認証への変更 | 🔄 レビュー中 | 橋本さん |
| v1.2 | 2025-07-22 | techPM | Supabase SDK + 直接API呼び出し対応 | 🔄 レビュー中 | 橋本さん |
| v1.3 | 2025-07-22 | techPM | Clerk認証簡素化 + 直接ファイルアクセス対応 | 🔄 レビュー中 | 橋本さん |
| v1.4 | 2025-07-22 | techPM | 認証をClerk管理画面のみに簡素化 | 🔄 レビュー中 | 橋本さん |
| v1.5 | 2025-07-22 | techPM | データアクセスをSupabase SDK最大限活用に変更 | 🔄 レビュー中 | 橋本さん |

## 1. システム構成

```
Frontend (Next.js) ◄──► Backend (FastAPI) ◄──► Database (Supabase)
    Vercel                   Railway                PostgreSQL + RLS
        |                       |                      |
        ▼                       ▼                      ▼
   直接API呼び出し         Supabase SDK    認証：Clerk管理画面
                          + RLS自動適用           (管理者3名のみ)
        |                       |
        ▼                       ▼
   Supabase Storage         型生成
   (直接アクセス)         自動API生成
```

**技術選定方針**: 自作システム構築・勉強目的・TypeScript型安全性・直接API呼び出し・Supabase最大限活用

## 2. フロントエンド

| 技術 | 用途 | 理由 |
|------|------|------|
| **Next.js 15** | Reactフレームワーク | SSG/SSR、SEO対応 |
| **TypeScript** | 型システム | 型安全性、開発効率 |
| **Tailwind CSS** | CSSフレームワーク | 高速開発、レスポンシブ |
| **shadcn/ui** | UIコンポーネント | 高品質、カスタマイズ性 |
| **Clerk** | 認証SDK | Next.js統合、管理画面 |

**フェーズ別構成**:
- 第1フェーズ: 静的エクスポート
- 第2フェーズ: SSG/ISR + 自作管理画面
- 第3・4フェーズ: フルスタック + 会員システム

## 3. バックエンド

| 技術 | 用途 | 理由 |
|------|------|------|
| **FastAPI** | APIフレームワーク | 高速、自動ドキュメント生成 |
| **Python 3.11** | プログラミング言語 | FastAPI対応 |
| **Pydantic** | データバリデーション | 型安全性 |
| **Supabase SDK** | データアクセス | RLS自動適用、リアルタイム機能、型生成 |

## 4. データベース・認証

**Supabase**:
- PostgreSQL (メインDB) + Row Level Security (RLS)
- Storage (画像保存) + 直接アクセス
- Auto API (CRUD API自動生成)
- 型生成 (TypeScript型自動生成)

**Clerk**:
- ユーザー認証・管理
- JWT発行・検証
- 招待制ユーザー管理（管理者3名）

## 5. インフラ・デプロイ

| 環境 | Frontend | Backend |
|------|----------|---------|
| 開発 | Docker | Docker |
| 本番 | Vercel | Railway |

**CI/CD**: GitHub Actions (テスト・ビルド・デプロイ自動化)

## 6. セキュリティ

- **認証**: Clerk管理画面（招待制・管理者3名のみ）
- **認可**: 不要（公開サイトのみ、管理画面はClerkで制御）
- **ファイルアクセス**: Supabase Storage直接アクセス
- **HTTPS**: 自動SSL証明書
- **入力検証**: Zod + Pydantic
- **DB**: Row Level Security (RLS)

## 7. 開発ツール

- **IDE**: VS Code
- **API テスト**: Thunder Client
- **DB管理**: Supabase CLI
- **認証管理**: Clerk Dashboard
- **コンテナ**: Docker Desktop
- **品質管理**: ESLint, Prettier, Jest, pytest
