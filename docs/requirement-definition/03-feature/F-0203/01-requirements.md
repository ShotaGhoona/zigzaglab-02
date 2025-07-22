# 機能要件

## 必須機能
- 7テーブル（admin_users, news, products, inquiries, files, tags, taggables）作成
- RLS（Row Level Security）ポリシー設定・管理者権限制御
- Supabase Storage bucket作成・ファイル管理基盤
- インデックス・制約・外部キー設定
- Supabase型生成（TypeScript連携）
- Supabaseプロジェクト標準ディレクトリ構成での管理
- **既存プロジェクト使用**: PROJECT_REF = `hdwdudvsncibvjtuoscr`

## オプション機能
- データベースパフォーマンス監視設定
- 自動バックアップスケジュール設定

# 制約・除外事項

## 技術制約
- **既存Supabaseプロジェクト**: `hdwdudvsncibvjtuoscr` を使用（新規作成不要）
- **RLS権限設計**: 🌐公開（匿名）・👑管理者（Clerk認証3名限定）
- **認証連携**: Clerk JWT の `sub` フィールドで admin_users 照合
- Supabase PostgreSQL仕様準拠（UUID主キー必須）
- ファイルサイズ制限: 5MB/ファイル（Storage制限）
- ディレクトリ構成: `supabase/migrations/` でのマイグレーション管理必須
- 命名規則: `YYYYMMDDHHMMSS_description.sql` 形式

## ビジネス制約
- 実装期間: 2日以内
- 管理者3名限定（橋本、山下、尾崎）
- 多言語対応なし（Phase2はシンプル構成）

## スコープ外
- 初期データ投入（各機能実装時に実施）
- 本番環境パフォーマンスチューニング（運用開始後）
- 複雑なクエリ最適化（実運用データ蓄積後）
- データマイグレーション機能（新規構築のため不要）