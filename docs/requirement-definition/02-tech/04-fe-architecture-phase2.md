# Phase2 フロントエンド アーキテクチャ設計書

## リビジョン履歴

| Version | Date | Author | Summary | Status | Reviewer |
|------------|------|--------|----------|----------|--------|
| v1.0 | 2025-07-22 | 山下 | Phase2版初版作成 | 🔄 レビュー中 | 橋本さん |

---

## 1. アーキテクチャ決定事項

### 1.1 技術スタック
- **Next.js 15 (App Router)** + TypeScript
- **shadcn/ui** (Tailwind CSS基盤)
- **Clerk認証** (管理画面のみ)
- **React Hook Form + Zod** (フォームバリデーション)
- **Vercel** (ホスティング)

### 1.2 重要な設計決定
- **公開サイト**: SSG/ISR (SEO最優先)
- **管理画面**: CSR (UX最優先)
- **API通信**: FastAPI直接呼び出し (Next.js API Routes使わない)
- **ファイル**: Supabase Storage直接アクセス
- **認証**: 管理画面のみ (Clerk管理画面で制御)

---

## 2. ディレクトリ構造

### 2.1 ファイル配置ルール
```
frontend/src/
├── app/                        # Next.js App Router
│   ├── (public)/               # 公開サイト → SSG/ISR適用
│   │   ├── page.tsx            # トップページ
│   │   ├── news/[id]/          # ニュース詳細
│   │   └── products/[id]/      # 商品詳細
│   ├── admin/                  # 管理画面 → CSR適用 + Clerk認証
│   │   ├── page.tsx            # ダッシュボード
│   │   ├── news/
│   │   └── products/
│   └── api/revalidate/         # ISR用のみ（最小限）
├── components/
│   ├── ui/                     # shadcn/ui（インストール済み）
│   ├── forms/                  # React Hook Form + Zod
│   └── layout/
├── lib/
│   ├── api.ts                  # FastAPI直接呼び出し用クライアント
│   ├── auth.ts                 # Clerk設定
│   └── storage.ts              # Supabase Storage直接アクセス
└── types/                      # Supabase型生成 + 追加型定義
```

### 2.2 レンダリング適用ルール
- **app/(public)**: 全て `export const revalidate = 3600` でISR
- **app/admin**: 全て `'use client'` でCSR + Clerk認証
- **API Routes**: ISR用webhook以外は作らない

---

## 3. API通信設計

### 3.1 通信方針
- **Next.js API Routes使わない**: フロントエンド → FastAPI直接
- **認証ヘッダー**: `Authorization: Bearer ${clerkJWT}`
- **環境変数**: `NEXT_PUBLIC_API_URL`

### 3.2 エラーハンドリング統一
- **401**: Clerk再認証
- **403**: 権限不足メッセージ
- **500**: 汎用エラーメッセージ

---

## 4. 認証設計

### 4.1 認証範囲（簡素化）
- **公開サイト**: 認証なし
- **管理画面**: Clerk管理画面で簡単制御（3名のみ招待制）
- **API通信**: Clerkトークンを自動付与

### 4.2 実装方針
- `app/admin/*` 全体をClerk認証コンポーネントでラップ
- 認証チェックはClerkが自動処理
- 複雑な認証実装は不要

---

## 5. コンポーネント設計

### 5.1 UI統一ルール
- **ベース**: shadcn/ui + Tailwind CSS
- **フォーム**: React Hook Form + Zod（必須）
- **状態管理**: React Query（APIデータ）+ useState（ローカル）

### 5.2 ファイルアップロード
- **直接アップロード**: フロントエンド → Supabase Storage
- **メタデータ保存**: アップロード後 → FastAPI

---

## 6. SEO最適化

### 6.1 メタデータ必須対応
- **generateMetadata**: 全公開ページで実装
- **構造化データ**: Article, Organization, BreadcrumbList

### 6.2 画像最適化
- **Next.js Image**: 必須使用
- **Supabase Storage**: 直接URL使用OK

---

## 7. 環境設定

### 7.1 必須環境変数
```bash
# .env.local
NEXT_PUBLIC_API_URL=https://api.zigzaglab.biz/api/v1
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
```

### 7.2 Next.js設定
```javascript
// next.config.js - 画像ドメイン登録必須
module.exports = {
  images: {
    domains: ['your-project.supabase.co'],
  },
};
```

---

**更新日**: 2025年7月22日  
**ステータス**: v1.0・Phase2対応  
**重要**: コーダーは迷わず上記ルールに従って実装すること