# 実装仕様

## 使用技術・ライブラリ
- **Next.js 15**: App Router + TypeScript
- **shadcn/ui**: Button, Form, Input, Card（基本セット）
- **React Hook Form + Zod**: フォームバリデーション
- **ESLint + Prettier**: コード品質管理

## 既存リソース参照
- **アーキテクチャ設計**: [フロントエンド構成](../../02-tech/04-fe-architecture-phase2.md)
- **技術スタック概要**: [技術選定理由](../../02-tech/01-tech-overview.md#2-フロントエンド)

## 実装タスクと工数

### Phase 1: プロジェクト基盤構築（4h）

1. **Next.js プロジェクト作成**（1h）
   ```bash
   npx create-next-app@latest frontend --typescript --tailwind --eslint --app --src-dir
   cd frontend
   ```

2. **TypeScript設定強化**（1h）
   - tsconfig.json strict設定
   - パスエイリアス設定（@/）
   - 型チェック強化

3. **shadcn/ui セットアップ**（2h）
   ```bash
   npx shadcn@latest init
   npx shadcn@latest add button form input card
   ```
   - 基本コンポーネントの導入テスト
   - コンポーネント動作確認

### Phase 2: 環境・設定整備（3h）

4. **ディレクトリ構造作成**（1h）
   ```
   src/
   ├── app/
   │   ├── (public)/     # 公開サイト用
   │   ├── admin/        # 管理画面用
   │   └── api/revalidate/ # ISR用
   ├── components/ui/    # shadcn/ui
   ├── lib/             # ユーティリティ
   └── types/           # 型定義
   ```

5. **環境変数・設定ファイル**（1h）
   - .env.local テンプレート作成
   - next.config.js 基本設定
   - 画像ドメイン設定準備

6. **ESLint + Prettier 設定**（1h）
   - 設定ファイル調整
   - VSCode統合設定

## 注意点・制約
- App Router 使用時の注意点（Pages Router との違い）
- shadcn/ui は公式ドキュメント参照必須
- 環境変数は後続機能で設定（今回はテンプレートのみ）
- ビルドエラーが出ないことを必ず確認

## 依存関係インストール
```bash
# 基本依存関係
npm install react-hook-form @hookform/resolvers zod

# 開発用依存関係  
npm install -D @types/node
```

## 設定ファイルテンプレート

### tsconfig.json 強化設定
```json
{
  "compilerOptions": {
    "strict": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### next.config.js 基本設定
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    domains: [], // Supabase Storage ドメインは後で追加
  },
}

module.exports = nextConfig
```