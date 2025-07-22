-- ZIGZAGLAB 初期データ投入
-- 開発・テスト用の基本データ

-- =============================================================================
-- 管理者ユーザー（サンプル）
-- =============================================================================

-- 実際のClerk User IDに置き換える必要があります
INSERT INTO admin_users (clerk_user_id, name, email, role, is_active) VALUES
('user_sample1', '橋本太郎', 'hashimoto@zigzaglab.com', 'admin', true),
('user_sample2', '山下花子', 'yamashita@zigzaglab.com', 'admin', true),
('user_sample3', '尾崎次郎', 'ozaki@zigzaglab.com', 'editor', true);

-- =============================================================================
-- タグマスター
-- =============================================================================

INSERT INTO tags (name, color) VALUES
('新商品', '#ff6b6b'),
('缶バッジ', '#4ecdc4'),
('アクリル', '#45b7d1'),
('高品質', '#96ceb4'),
('特許製品', '#9b59b6'),
('展示会', '#f39c12'),
('お知らせ', '#3498db');

-- =============================================================================
-- 商品サンプル
-- =============================================================================

INSERT INTO products (name, description, category, slug, price_min, price_max, specifications, features, is_featured, status, meta_title, meta_description, created_by) VALUES
('高品質缶バッジ', '機構部品メーカーの技術力による精密な缶バッジ製造。1個から45万個まで対応可能。', 'badge', 'high-quality-badge', 100.00, 5000.00, '直径32mm、素材：ブリキ', '高精度、耐久性、Made in Japan品質', true, 'active', '高品質缶バッジ | ZIGZAGLAB', '機構部品メーカーの技術力による高品質缶バッジ製造サービス', (SELECT id FROM admin_users WHERE email = 'yamashita@zigzaglab.com')),
('透明アクリルグッズ', '独自技術による透明度の高いアクリル製品。カスタムデザイン対応。', 'acrylic', 'clear-acrylic-goods', 200.00, 8000.00, '厚み3mm、素材：PMMA', '高透明度、カスタムカット、UV印刷対応', true, 'active', '透明アクリルグッズ | ZIGZAGLAB', '高透明度のアクリル製品製造。カスタムデザイン対応', (SELECT id FROM admin_users WHERE email = 'yamashita@zigzaglab.com')),
('特許製品シリーズ', '当社独自の特許技術を活用した革新的なグッズ製品。', 'patent', 'patent-series', 500.00, 15000.00, '特許第XXXXXXX号技術使用', '独自機構、高付加価値、差別化商品', false, 'active', '特許製品シリーズ | ZIGZAGLAB', '独自特許技術を活用した革新的グッズ製品', (SELECT id FROM admin_users WHERE email = 'yamashita@zigzaglab.com'));

-- =============================================================================
-- ニュース記事サンプル
-- =============================================================================

INSERT INTO news (title, content, slug, status, meta_title, meta_description, published_at, created_by) VALUES
('ZIGZAGLAB サービス開始のお知らせ', 'この度、向陽エンジニアリングの新事業として「ZIGZAGLAB」のサービスを開始いたしました。機構部品メーカーとしての技術力を活かし、高品質なグッズ製造をご提供いたします。', 'service-launch-announcement', 'published', 'ZIGZAGLAB サービス開始 | お知らせ', 'ZIGZAGLABサービス開始のお知らせ。機構部品メーカーの技術力を活かした高品質グッズ製造', NOW(), (SELECT id FROM admin_users WHERE email = 'yamashita@zigzaglab.com')),
('モトヤコラボレーションフェア出展報告', '2024年のモトヤコラボレーションフェアに出展いたしました。多くのお客様にご来場いただき、ありがとうございました。', 'motoya-collaboration-fair-2024', 'published', 'モトヤコラボレーションフェア出展報告 | ZIGZAGLAB', 'モトヤコラボレーションフェア2024出展報告', NOW() - INTERVAL '7 days', (SELECT id FROM admin_users WHERE email = 'yamashita@zigzaglab.com'));

-- =============================================================================
-- タグ関連付け
-- =============================================================================

-- 商品のタグ付け
INSERT INTO taggables (tag_id, entity_type, entity_id) VALUES
((SELECT id FROM tags WHERE name = '缶バッジ'), 'product', (SELECT id FROM products WHERE slug = 'high-quality-badge')),
((SELECT id FROM tags WHERE name = '高品質'), 'product', (SELECT id FROM products WHERE slug = 'high-quality-badge')),
((SELECT id FROM tags WHERE name = 'アクリル'), 'product', (SELECT id FROM products WHERE slug = 'clear-acrylic-goods')),
((SELECT id FROM tags WHERE name = '高品質'), 'product', (SELECT id FROM products WHERE slug = 'clear-acrylic-goods')),
((SELECT id FROM tags WHERE name = '特許製品'), 'product', (SELECT id FROM products WHERE slug = 'patent-series'));

-- ニュースのタグ付け
INSERT INTO taggables (tag_id, entity_type, entity_id) VALUES
((SELECT id FROM tags WHERE name = 'お知らせ'), 'news', (SELECT id FROM news WHERE slug = 'service-launch-announcement')),
((SELECT id FROM tags WHERE name = '新商品'), 'news', (SELECT id FROM news WHERE slug = 'service-launch-announcement')),
((SELECT id FROM tags WHERE name = '展示会'), 'news', (SELECT id FROM news WHERE slug = 'motoya-collaboration-fair-2024'));