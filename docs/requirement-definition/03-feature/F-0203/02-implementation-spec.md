# 実装仕様

## 使用技術・ライブラリ
- **Supabase Console**: GUI でのテーブル作成・設定
- **SQL DDL**: バージョン管理可能なスキーマ定義
- **RLS（Row Level Security）**: Supabase標準セキュリティ機能
- **Supabase CLI**: 型生成・ローカル開発支援

## 既存リソース参照
- **データベース設計**: [7テーブル詳細設計](../../02-tech/02-database-phase2.md)
- **バックエンド連携**: [アーキテクチャ設計](../../02-tech/05-be-architecture-phase2.md)

## 実装タスクと工数

### Phase 1: プロジェクト初期化・コアテーブル作成（3h）

1. **Supabaseプロジェクト初期化**（30分）
   ```bash
   # プロジェクトルートで実行
   supabase init
   supabase login
   supabase link --project-ref [PROJECT_REF]
   ```
   - `supabase/` ディレクトリ作成
   - config.toml 設定
   - Git管理設定

zigzaglab-02/
  ├── docs/
  ├── frontend/
  ├── backend/
  └── supabase/           # ← ここ
      ├── migrations/
      │   ├── 20250722000001_initial_schema.sql
      │   ├── 20250722000002_setup_rls.sql
      │   └── 20250722000003_create_storage.sql
      ├── seed.sql        # 初期データ
      ├── config.toml     # Supabase CLI設定
      └── types/
          └── database.ts # 生成された型定義

2. **admin_users テーブル作成**（30分）
   - Clerk連携用ユーザーマスタ
   - clerk_user_id（UK）, name, email, role設定
   - インデックス: clerk_user_id, email
   - マイグレーションファイル: `20250722000001_create_admin_users.sql`

3. **news テーブル作成**（45分）
   - ニュース記事管理
   - title, content, slug（UK）, status, SEO項目
   - インデックス: slug, status, published_at
   - マイグレーションファイル: `20250722000002_create_news.sql`

4. **products テーブル作成**（45分）
   - 商品情報管理
   - name, category, slug（UK）, price_min/max, is_featured
   - インデックス: slug, category, status, is_featured
   - マイグレーションファイル: `20250722000003_create_products.sql`

5. **基本動作確認**（30分）
   - テーブル作成確認
   - 制約・インデックス動作テスト
   - `supabase db push` でリモート同期

### Phase 2: 関連テーブル・Storage構築（3h）

5. **inquiries テーブル作成**（45分）
   - 問い合わせ管理
   - inquiry_type, 顧客情報, status, assigned_to
   - インデックス: status, inquiry_type, created_at

6. **files テーブル作成**（45分）
   - Supabase Storage連携
   - file_path, usage_type, entity関連
   - インデックス: entity関連, usage_type

7. **tags・taggables テーブル作成**（45分）
   - 汎用タグシステム
   - 多対多関連テーブル設計
   - UNIQUE制約: 重複防止
   - **RLSポリシー**: 公開アクセス可能

8. **Storage bucket設定**（45分）
   - files bucket作成
   - ファイルアップロード権限設定

### Phase 3: セキュリティ・最適化（2h）

9. **RLS ポリシー設定**（60分）
   ```sql
   -- 管理者権限ポリシー（全テーブル共通）
   USING (EXISTS (
     SELECT 1 FROM admin_users 
     WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
   ));
   
   -- 公開データポリシー
   -- news: status = 'published' のみ公開
   -- products: status = 'active' のみ公開  
   -- inquiries: 匿名投稿のみ許可
   ```

10. **型生成・接続確認**（60分）
    ```bash
    supabase gen types typescript --project-id hdwdudvsncibvjtuoscr
    ```
    - TypeScript型ファイル生成
    - FastAPI連携テスト準備

## 注意点・制約
- **RLS有効化必須**: 各テーブルでRLSをONにする
- **UUID型統一**: すべてのPKはuuid_generate_v4()使用
- **外部キー設定**: admin_users参照時にCASCADE設定注意
- **インデックス戦略**: 検索頻度高いカラム優先（slug, status等）

## SQL DDLサンプル（admin_users）
```sql
-- admin_users テーブル作成例
CREATE TABLE admin_users (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    clerk_user_id text UNIQUE NOT NULL,
    name text NOT NULL,
    email text UNIQUE NOT NULL,
    role text NOT NULL CHECK(role IN ('admin', 'editor')),
    is_active boolean NOT NULL DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- インデックス作成
CREATE INDEX idx_admin_users_clerk_user_id ON admin_users(clerk_user_id);
CREATE INDEX idx_admin_users_email ON admin_users(email);

-- RLS有効化
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
```

## 環境変数更新
```bash
# .env（F-0202で使用）・既存設定確認
SUPABASE_URL=https://hdwdudvsncibvjtuoscr.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhkd2R1ZHZzbmNpYnZqdHVvc2NyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTIzMzUsImV4cCI6MjA2ODc2ODMzNX0.yzf-2H1MKXVe6FsFg9qhmtA2NqKpHCe1jwWNn1G013I
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhkd2R1ZHZzbmNpYnZqdHVvc2NyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MzE5MjMzNSwiZXhwIjoyMDY4NzY4MzM1fQ.HHxSV0sZ4_BqKzI2Kn8ZvDgKH9SHAcinwkOUqeHQqJU
```