-- ZIGZAGLAB Supabase Storage 設定
-- files bucket作成・ファイル管理基盤

-- =============================================================================
-- Storage Bucket 作成
-- =============================================================================

-- files bucket作成（公開バケット）
INSERT INTO storage.buckets (id, name, public) 
VALUES ('files', 'files', true);

-- =============================================================================
-- Storage ポリシー設定
-- =============================================================================

-- ファイル読み取り（公開ファイルのみ）
CREATE POLICY "public_read_files_storage" ON storage.objects
FOR SELECT USING (
  bucket_id = 'files' AND
  (
    -- 商品ファイルは全て公開
    name LIKE 'products/%' OR
    -- ニュースファイルは公開記事のみ
    (name LIKE 'news/%' AND EXISTS (
      SELECT 1 FROM news 
      WHERE status = 'published' 
      AND id::text = SPLIT_PART(name, '/', 2)
    ))
  )
);

-- 管理者によるファイルアップロード
CREATE POLICY "admin_upload_files_storage" ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (
  bucket_id = 'files' AND
  EXISTS (
    SELECT 1 FROM admin_users 
    WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
  )
);

-- 管理者によるファイル更新・削除
CREATE POLICY "admin_manage_files_storage" ON storage.objects
FOR UPDATE, DELETE TO authenticated
USING (
  bucket_id = 'files' AND
  EXISTS (
    SELECT 1 FROM admin_users 
    WHERE clerk_user_id = auth.jwt() ->> 'sub' AND is_active = true
  )
);