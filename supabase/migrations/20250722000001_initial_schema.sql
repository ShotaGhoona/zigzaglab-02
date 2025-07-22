-- ZIGZAGLAB Database Initial Schema
-- 全テーブル作成・制約・インデックス設定

-- UUID拡張の有効化（必要に応じて）
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- 1. admin_users テーブル（管理者ユーザー）
-- =============================================================================

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

-- =============================================================================
-- 2. news テーブル（ニュース記事）
-- =============================================================================

CREATE TABLE news (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    title text NOT NULL,
    content text NOT NULL,
    slug text UNIQUE NOT NULL,
    status text NOT NULL DEFAULT 'draft' CHECK(status IN ('draft', 'published', 'archived')),
    meta_title text,
    meta_description text,
    created_by uuid REFERENCES admin_users(id),
    updated_by uuid REFERENCES admin_users(id),
    published_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- インデックス作成
CREATE INDEX idx_news_slug ON news(slug);
CREATE INDEX idx_news_status ON news(status);
CREATE INDEX idx_news_published_at ON news(published_at);

-- RLS有効化
ALTER TABLE news ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- 3. products テーブル（商品情報）
-- =============================================================================

CREATE TABLE products (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    category text NOT NULL CHECK(category IN ('badge', 'acrylic', 'patent', 'other')),
    slug text UNIQUE NOT NULL,
    price_min decimal(10,2),
    price_max decimal(10,2),
    specifications text,
    features text,
    is_featured boolean NOT NULL DEFAULT false,
    status text NOT NULL DEFAULT 'active' CHECK(status IN ('active', 'inactive', 'discontinued')),
    meta_title text,
    meta_description text,
    created_by uuid REFERENCES admin_users(id),
    updated_by uuid REFERENCES admin_users(id),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- インデックス作成
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_is_featured ON products(is_featured);

-- RLS有効化
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- 4. inquiries テーブル（問い合わせ）
-- =============================================================================

CREATE TABLE inquiries (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    inquiry_type text NOT NULL CHECK(inquiry_type IN ('estimate', 'general', 'sample')),
    company_name text,
    contact_name text NOT NULL,
    email text NOT NULL,
    phone text,
    subject text NOT NULL,
    message text NOT NULL,
    product_category text CHECK(product_category IN ('badge', 'acrylic', 'patent', 'other')),
    quantity integer,
    status text NOT NULL DEFAULT 'new' CHECK(status IN ('new', 'in_progress', 'replied', 'closed')),
    admin_notes text,
    assigned_to uuid REFERENCES admin_users(id),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- インデックス作成
CREATE INDEX idx_inquiries_status ON inquiries(status);
CREATE INDEX idx_inquiries_inquiry_type ON inquiries(inquiry_type);
CREATE INDEX idx_inquiries_created_at ON inquiries(created_at);

-- RLS有効化
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- 5. tags テーブル（タグマスタ）
-- =============================================================================

CREATE TABLE tags (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    name text UNIQUE NOT NULL,
    color text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- インデックス作成
CREATE INDEX idx_tags_name ON tags(name);

-- RLS有効化
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- 6. taggables テーブル（汎用タグ関連）
-- =============================================================================

CREATE TABLE taggables (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    tag_id uuid REFERENCES tags(id) NOT NULL,
    entity_type text NOT NULL CHECK(entity_type IN ('news', 'product', 'achievement')),
    entity_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE(tag_id, entity_type, entity_id)
);

-- インデックス作成
CREATE INDEX idx_taggables_tag ON taggables(tag_id);
CREATE INDEX idx_taggables_entity ON taggables(entity_type, entity_id);

-- RLS有効化
ALTER TABLE taggables ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- 7. files テーブル（ファイル管理）
-- =============================================================================

CREATE TABLE files (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
    original_name text NOT NULL,
    file_path text NOT NULL,
    file_type text NOT NULL,
    file_size integer NOT NULL,
    usage_type text NOT NULL CHECK(usage_type IN ('thumbnail', 'inline', 'attachment')),
    sort_order integer,
    caption text,
    alt_text text,
    entity_type text NOT NULL CHECK(entity_type IN ('news', 'product', 'inquiry')),
    entity_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- インデックス作成
CREATE INDEX idx_files_entity ON files(entity_type, entity_id);
CREATE INDEX idx_files_usage_order ON files(entity_type, entity_id, usage_type, sort_order);

-- RLS有効化
ALTER TABLE files ENABLE ROW LEVEL SECURITY;