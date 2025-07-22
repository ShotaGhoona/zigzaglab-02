# ZIGZAGLAB Supabase データベース

7テーブル構成のPostgreSQLデータベース・RLS権限設計・Storage設定

## プロジェクト情報

- **Project Ref**: `hdwdudvsncibvjtuoscr`
- **Database URL**: `https://hdwdudvsncibvjtuoscr.supabase.co`
- **RLS設計**: 🌐公開・👑管理者（Clerk認証3名限定）

## マイグレーション実行

### 1. Supabase Console での実行（推奨）

1. [Supabase Dashboard](https://supabase.com/dashboard/project/hdwdudvsncibvjtuoscr) にアクセス
2. SQL Editor を開く
3. 以下の順序でマイグレーションファイルを実行：

```sql
-- 1. 初期スキーマ・全テーブル作成
-- migrations/20250722000001_initial_schema.sql をコピペして実行

-- 2. RLSポリシー設定
-- migrations/20250722000002_setup_rls.sql をコピペして実行

-- 3. Storage bucket作成・ポリシー設定
-- migrations/20250722000003_create_storage.sql をコピペして実行

-- 4. 初期データ投入（オプション）
-- seed.sql をコピペして実行
```

### 2. Supabase CLI での実行（CLI利用可能な場合）

```bash
# プロジェクトをリンク
supabase link --project-ref hdwdudvsncibvjtuoscr

# マイグレーション実行
supabase db push

# 型生成
supabase gen types typescript > types/database.ts
```

## テーブル構成

| テーブル名 | 用途 | RLSポリシー |
|-----------|------|-------------|
| **admin_users** | 管理者ユーザー | 👑 管理者のみ |
| **news** | ニュース記事 | 🌐 公開記事は匿名可・👑 管理は認証必須 |
| **products** | 商品情報 | 🌐 アクティブ商品は匿名可・👑 管理は認証必須 |
| **inquiries** | 問い合わせ | 🌐 匿名投稿可・👑 閲覧は認証必須 |
| **files** | ファイル管理 | 🌐 公開ファイルは匿名可・👑 管理は認証必須 |
| **tags** | タグマスタ | 🌐 匿名可・👑 管理は認証必須 |
| **taggables** | タグ関連 | 🌐 匿名可・👑 管理は認証必須 |

## Storage構成

- **Bucket**: `files` （公開バケット）
- **構造**: 
  - `products/{product_id}/` - 商品画像
  - `news/{news_id}/` - ニュース画像
  - `temp/` - 一時アップロード

## RLS権限設計

### 🌐 公開アクセス（認証不要）
- 公開ニュース記事（`status = 'published'`）
- アクティブ商品（`status = 'active'`）
- 全タグ・タグ関連
- 問い合わせ投稿
- 公開ファイル

### 👑 管理者限定（Clerk認証必須）
- 管理者ユーザー情報
- 全データの作成・更新・削除
- 問い合わせ閲覧・管理
- ファイルアップロード・管理

## 環境変数

```bash
# 既存設定確認
SUPABASE_URL=https://hdwdudvsncibvjtuoscr.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhkd2R1ZHZzbmNpYnZqdHVvc2NyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTIzMzUsImV4cCI6MjA2ODc2ODMzNX0.yzf-2H1MKXVe6FsFg9qhmtA2NqKpHCe1jwWNn1G013I
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhkd2R1ZHZzbmNpYnZqdHVvc2NyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzE5MjMzNSwiZXhwIjoyMDY4NzY4MzM1fQ.HHxSV0sZ4_BqKzI2Kn8ZvDgKH9SHAcinwkOUqeHQqJU
```

## 動作確認

### 1. 基本動作確認
```sql
-- テーブル作成確認
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

-- RLS有効化確認
SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';
```

### 2. RLSポリシー動作確認
```sql
-- 匿名での公開データアクセス（成功する）
SELECT * FROM news WHERE status = 'published';
SELECT * FROM products WHERE status = 'active';

-- 匿名での管理データアクセス（失敗する）
SELECT * FROM admin_users; -- RLSエラー
```

### 3. Storage動作確認
- Supabase Dashboard の Storage から `files` バケットを確認
- テストファイルのアップロード・アクセス確認

## 開発参考

- **データベース設計詳細**: [Phase2データベース設計](../docs/requirement-definition/02-tech/02-database-phase2.md)
- **API連携**: [バックエンドアーキテクチャ](../docs/requirement-definition/02-tech/05-be-architecture-phase2.md)
- **型定義**: `types/database.ts` - TypeScript型定義ファイル