# ZIGZAGLAB Phase2 ディレクトリ構造設計

## リビジョン履歴

| Version | Date | Author | Summary | Status | Reviewer |
|------------|------|--------|----------|----------|--------|
| v1.0 | 2025-07-22 | 山下 | ディレクトリ構造設計 | 🔄 レビュー中 | 橋本 |
| v1.1 | 2025-07-22 | 山下 | 直接API呼び出し対応 | 🔄 レビュー中 | 橋本 |
| v1.2 | 2025-07-22 | 山下 | JWT検証 + 直接ファイルアクセス対応 | 🔄 レビュー中 | 橋本 |

---

## 1. 全体構造

```
zigzaglab-02/
├── README.md
├── .gitignore
├── docs/                           # 設計書（既存）
├── frontend/                       # Next.js フロントエンド
├── backend/                        # FastAPI バックエンド
├── .env.example                    # 環境変数テンプレート
└── docker-compose.yml              # 開発環境（オプション）
```

---

## 2. フロントエンド構造 (frontend/)

### 2.1 Next.js App Router 構造

```
frontend/
├── public/                         # 静的ファイル
│   ├── images/                     # サイト用画像
│   ├── icons/                      # アイコン
│   ├── favicon.ico
│   ├── robots.txt
│   └── sitemap.xml
├── src/
│   ├── app/                        # App Router
│   │   ├── (public)/               # 公開サイトグループ
│   │   │   ├── page.tsx            # トップページ (/)
│   │   │   ├── company/
│   │   │   │   └── page.tsx        # 会社概要 (/company)
│   │   │   ├── strength/
│   │   │   │   └── page.tsx        # 自社の強み (/strength)
│   │   │   ├── products/
│   │   │   │   ├── page.tsx        # 商品一覧 (/products)
│   │   │   │   ├── [slug]/
│   │   │   │   │   └── page.tsx    # 商品詳細 (/products/[slug])
│   │   │   │   └── category/
│   │   │   │       └── [category]/
│   │   │   │           └── page.tsx # カテゴリ別一覧
│   │   │   ├── news/
│   │   │   │   ├── page.tsx        # ニュース一覧 (/news)
│   │   │   │   └── [slug]/
│   │   │   │       └── page.tsx    # ニュース詳細 (/news/[slug])
│   │   │   ├── process/
│   │   │   │   └── page.tsx        # 制作プロセス (/process)
│   │   │   ├── quality/
│   │   │   │   └── page.tsx        # 品質へのこだわり (/quality)
│   │   │   ├── contact/
│   │   │   │   └── page.tsx        # お問い合わせ (/contact)
│   │   │   ├── privacy/
│   │   │   │   └── page.tsx        # プライバシーポリシー
│   │   │   ├── terms/
│   │   │   │   └── page.tsx        # 利用規約
│   │   │   ├── sitemap/
│   │   │   │   └── page.tsx        # サイトマップ
│   │   │   ├── not-found.tsx       # 404ページ
│   │   │   └── layout.tsx          # 公開サイト共通レイアウト
│   │   ├── admin/                  # 管理画面グループ
│   │   │   ├── page.tsx            # ダッシュボード (/admin)
│   │   │   ├── news/
│   │   │   │   ├── page.tsx        # ニュース管理一覧
│   │   │   │   ├── new/
│   │   │   │   │   └── page.tsx    # ニュース作成
│   │   │   │   └── [id]/
│   │   │   │       ├── page.tsx    # ニュース編集
│   │   │   │       └── edit/
│   │   │   │           └── page.tsx
│   │   │   ├── products/
│   │   │   │   ├── page.tsx        # 商品管理一覧
│   │   │   │   ├── new/
│   │   │   │   │   └── page.tsx    # 商品作成
│   │   │   │   └── [id]/
│   │   │   │       └── edit/
│   │   │   │           └── page.tsx # 商品編集
│   │   │   ├── inquiries/
│   │   │   │   ├── page.tsx        # 問い合わせ管理一覧
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx    # 問い合わせ詳細・返信
│   │   │   ├── tags/
│   │   │   │   └── page.tsx        # タグ管理
│   │   │   ├── analytics/
│   │   │   │   └── page.tsx        # アクセス解析
│   │   │   ├── settings/
│   │   │   │   └── page.tsx        # システム設定
│   │   │   └── layout.tsx          # 管理画面共通レイアウト
│   │   ├── api/                    # Next.js API Routes（ISRのみ）
│   │   │   └── revalidate/
│   │   │       └── route.ts        # ISR用webhook（FastAPI直接呼び出しのため最小限）
│   │   ├── globals.css             # グローバルCSS
│   │   ├── layout.tsx              # ルートレイアウト
│   │   └── loading.tsx             # 共通ローディング
│   ├── components/                 # 再利用可能コンポーネント
│   │   ├── ui/                     # shadcn/ui コンポーネント
│   │   │   ├── button.tsx          # shadcn Button
│   │   │   ├── input.tsx           # shadcn Input
│   │   │   ├── card.tsx            # shadcn Card
│   │   │   ├── dialog.tsx          # shadcn Dialog
│   │   │   ├── form.tsx            # shadcn Form
│   │   │   ├── table.tsx           # shadcn Table
│   │   │   ├── badge.tsx           # shadcn Badge
│   │   │   ├── select.tsx          # shadcn Select
│   │   │   ├── textarea.tsx        # shadcn Textarea
│   │   │   ├── toast.tsx           # shadcn Toast
│   │   │   ├── dropdown-menu.tsx   # shadcn Dropdown
│   │   │   ├── navigation-menu.tsx # shadcn Navigation
│   │   │   └── loading-spinner.tsx # カスタムLoading
│   │   ├── layout/                 # レイアウト関連
│   │   │   ├── Header.tsx
│   │   │   ├── Footer.tsx
│   │   │   ├── Navigation.tsx
│   │   │   └── AdminSidebar.tsx
│   │   ├── forms/                  # フォームコンポーネント
│   │   │   ├── ContactForm.tsx
│   │   │   ├── NewsForm.tsx
│   │   │   ├── ProductForm.tsx
│   │   │   └── FileUpload.tsx
│   │   ├── cards/                  # カード系コンポーネント
│   │   │   ├── NewsCard.tsx
│   │   │   ├── ProductCard.tsx
│   │   │   └── InquiryCard.tsx
│   │   └── common/                 # 共通コンポーネント
│   │       ├── TagList.tsx
│   │       ├── ImageGallery.tsx
│   │       ├── Breadcrumb.tsx
│   │       └── SEOHead.tsx
│   ├── lib/                        # ユーティリティ・設定
│   │   ├── api.ts                  # FastAPI直接呼び出し関数
│   │   ├── auth.ts                 # Clerk設定
│   │   ├── utils.ts                # shadcn utils + 共通ユーティリティ
│   │   ├── constants.ts            # 定数
│   │   └── validations.ts          # バリデーションスキーマ
│   ├── hooks/                      # カスタムフック
│   │   ├── useNews.ts
│   │   ├── useProducts.ts
│   │   ├── useInquiries.ts
│   │   └── useAuth.ts
│   ├── types/                      # TypeScript型定義
│   │   ├── news.ts
│   │   ├── product.ts
│   │   ├── inquiry.ts
│   │   ├── user.ts
│   │   └── api.ts
├── components.json                 # shadcn/ui設定ファイル
├── .env.local                      # ローカル環境変数
├── .gitignore
├── next.config.js                  # Next.js設定
├── tailwind.config.ts              # Tailwind設定（shadcn対応）
├── tsconfig.json                   # TypeScript設定
└── package.json                    # 依存関係
```

---

## 3. バックエンド構造 (backend/)

### 3.1 FastAPI 構造

```
backend/
├── src/
│   ├── main.py                     # FastAPIアプリケーション
│   ├── config/                     # 設定
│   │   ├── __init__.py
│   │   ├── database.py             # Supabase接続設定
│   │   ├── settings.py             # 環境変数・設定
│   │   └── auth.py                 # Clerk JWT検証設定
│   ├── models/                     # データモデル
│   │   ├── __init__.py
│   │   ├── admin_user.py
│   │   ├── news.py
│   │   ├── product.py
│   │   ├── inquiry.py
│   │   ├── tag.py
│   │   ├── taggable.py
│   │   └── file.py
│   ├── schemas/                    # Pydanticスキーマ
│   │   ├── __init__.py
│   │   ├── admin_user.py
│   │   ├── news.py
│   │   ├── product.py
│   │   ├── inquiry.py
│   │   ├── tag.py
│   │   ├── file.py
│   │   └── common.py               # 共通レスポンス
│   ├── routers/                    # APIルーター
│   │   ├── __init__.py
│   │   ├── news.py                 # ニュース関連エンドポイント
│   │   │   # GET /news, GET /news/{slug}
│   │   │   # GET /admin/news, POST /admin/news, etc.
│   │   ├── products.py             # 商品関連エンドポイント
│   │   │   # GET /products, GET /products/{slug}
│   │   │   # GET /admin/products, POST /admin/products, etc.
│   │   ├── inquiries.py            # 問い合わせ関連エンドポイント
│   │   │   # POST /inquiries
│   │   │   # GET /admin/inquiries, PUT /admin/inquiries/{id}
│   │   ├── tags.py                 # タグ関連エンドポイント
│   │   │   # GET /news/tags, GET /admin/tags, etc.
│   │   ├── files.py                # ファイル関連エンドポイント
│   │   │   # POST /admin/files/upload, GET /files/{path}
│   │   ├── admin.py                # 管理機能エンドポイント
│   │   │   # GET /admin/dashboard, GET /admin/users
│   │   └── health.py               # ヘルスチェック
│   ├── services/                   # ビジネスロジック
│   │   ├── __init__.py
│   │   ├── news_service.py
│   │   ├── product_service.py
│   │   ├── inquiry_service.py
│   │   ├── tag_service.py
│   │   ├── file_service.py
│   │   └── email_service.py
│   ├── repositories/               # データアクセス層
│   │   ├── __init__.py
│   │   ├── base.py                 # 基底リポジトリ
│   │   ├── news_repository.py
│   │   ├── product_repository.py
│   │   ├── inquiry_repository.py
│   │   ├── tag_repository.py
│   │   └── file_repository.py
│   ├── middleware/                 # ミドルウェア
│   │   ├── __init__.py
│   │   ├── cors.py                 # CORS設定（フロントエンド直接呼び出し対応）
│   │   ├── auth.py                 # JWT認証ミドルウェア
│   │   └── error_handler.py        # エラーハンドリング
│   └── utils/                      # ユーティリティ
│       ├── __init__.py
│       ├── auth.py                 # JWT検証ユーティリティ
│       ├── file.py                 # ファイル操作
│       ├── email.py                # メール送信
│       └── helpers.py              # その他ヘルパー
├── migrations/                     # データベースマイグレーション
│   ├── 001_initial_schema.sql
│   ├── 002_add_tags.sql
│   └── README.md
├── tests/                          # テスト
│   ├── __init__.py
│   ├── conftest.py                 # pytest設定
│   ├── test_news.py
│   ├── test_products.py
│   ├── test_inquiries.py
│   └── test_auth.py
├── .env.example                    # 環境変数テンプレート
├── .env                            # 環境変数（Git除外）
├── requirements.txt                # 依存関係
├── pyproject.toml                  # Python設定
├── Dockerfile                      # Railway用Docker
└── README.md
```


---

**更新日**: 2025年7月22日  
**ステータス**: v1.2・直接API呼び出し + JWT検証 + 直接ファイルアクセス対応  
**構成**: モノリポ・フロントバック分離・FastAPI直接呼び出し・FastAPI JWT検証・Supabase Storage直接アクセス