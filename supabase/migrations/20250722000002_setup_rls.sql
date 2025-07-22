-- ZIGZAGLAB RLS（Row Level Security）ポリシー設定
-- 🌐公開アクセス・👑管理者権限の設定

-- =============================================================================
-- 公開データ：news テーブル
-- =============================================================================

-- 公開記事の閲覧（匿名OK）
CREATE POLICY "public_read_published" ON news
FOR SELECT USING (status = 'published');

-- 管理者のみ全操作可能
CREATE POLICY "admin_full_access_news" ON news
FOR ALL TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));

-- =============================================================================
-- 公開データ：products テーブル
-- =============================================================================

-- 商品は全商品公開
CREATE POLICY "public_read_products" ON products
FOR SELECT USING (status = 'active');

-- 管理者のみ全操作可能
CREATE POLICY "admin_full_access_products" ON products
FOR ALL TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));

-- =============================================================================
-- 公開データ：tags テーブル
-- =============================================================================

-- タグは全て公開
CREATE POLICY "public_read_tags" ON tags
FOR SELECT USING (true);

-- 管理者のみ全操作可能
CREATE POLICY "admin_full_access_tags" ON tags
FOR ALL TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));

-- =============================================================================
-- 公開データ：taggables テーブル
-- =============================================================================

-- タグ関連は公開
CREATE POLICY "public_read_taggables" ON taggables
FOR SELECT USING (true);

-- 管理者のみ全操作可能
CREATE POLICY "admin_full_access_taggables" ON taggables
FOR ALL TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));

-- =============================================================================
-- 管理限定データ：admin_users テーブル
-- =============================================================================

CREATE POLICY "admin_only_access" ON admin_users
FOR ALL TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));

-- =============================================================================
-- 投稿許可データ：inquiries テーブル
-- =============================================================================

-- 匿名での問い合わせ投稿
CREATE POLICY "anonymous_insert_inquiry" ON inquiries
FOR INSERT WITH CHECK (true);

-- 管理者のみ閲覧・更新
CREATE POLICY "admin_manage_inquiries" ON inquiries
FOR SELECT, UPDATE, DELETE TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));

-- =============================================================================
-- ファイル管理：files テーブル
-- =============================================================================

-- 公開用ファイルは匿名アクセス可能
CREATE POLICY "public_read_files" ON files
FOR SELECT USING (
  entity_type = 'product' OR 
  (entity_type = 'news' AND EXISTS (
    SELECT 1 FROM news WHERE id = files.entity_id AND status = 'published'
  ))
);

-- 管理者はファイルの全操作可能
CREATE POLICY "admin_manage_files" ON files
FOR ALL TO authenticated
USING (EXISTS (
  SELECT 1 FROM admin_users 
  WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
));