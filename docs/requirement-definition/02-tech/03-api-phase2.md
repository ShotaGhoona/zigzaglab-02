# Phase2 API設計書

## リビジョン履歴

| Version | Date | Author | Summary | Status | Reviewer |
|------------|------|--------|----------|----------|--------|
| v1.0 | 2025-07-22 | 山下 | Phase2版初版作成 | 🔄 レビュー中 | 橋本 |


## 1. API概要

### 1.1 使用技術
- **フレームワーク**: FastAPI (Python)
- **認証**: Clerk JWT認証
- **データベース**: Supabase (PostgreSQL)
- **ファイルストレージ**: Supabase Storage
- **ドキュメント**: OpenAPI 3.0 (自動生成)

### 1.2 設計方針
- RESTful API設計
- 管理者認証必須（Clerk JWT）
- フロントエンド向けのパブリックAPI
- 適切なHTTPステータスコード使用
- レスポンス形式の統一

### 1.3 ベースURL
- **開発環境**: `http://localhost:8000/api/v1`
- **本番環境**: `https://api.zigzaglab.biz/api/v1`


## 2. 認証

### 2.1 認証方式
```
Authorization: Bearer <clerk_jwt_token>
```

### 2.2 権限レベル
- **public**: 認証不要（公開API）
- **admin**: 管理者認証必須（橋本、山下、尾崎）


## 3. 共通レスポンス形式

### 3.1 成功レスポンス
```json
{
  "success": true,
  "data": {},
  "message": "Success"
}
```

### 3.2 エラーレスポンス
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description",
    "details": {}
  }
}
```

### 3.3 ページネーション
```json
{
  "success": true,
  "data": {
    "items": [],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total_items": 100,
      "total_pages": 5,
      "has_next": true,
      "has_prev": false
    }
  }
}
```


## 4. エンドポイント一覧

## 4.1 ニュース API

### GET /news
**説明**: 公開ニュース一覧取得  
**権限**: public  
**パラメータ**:
```
?page=1&per_page=20&status=published&tags=tag1,tag2&search=keyword
```

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "uuid",
        "title": "新商品のお知らせ",
        "content": "記事内容...",
        "slug": "new-product-announcement",
        "published_at": "2025-07-22T10:00:00Z",
        "created_at": "2025-07-22T09:00:00Z",
        "meta_title": "SEO用タイトル",
        "meta_description": "SEO用説明文",
        "tags": [
          {"id": "tag-001", "name": "新商品", "color": "#ff6b6b"}
        ],
        "thumbnail": {
          "id": "file-001",
          "file_path": "news/thumb.jpg",
          "alt_text": "新商品画像"
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total_items": 10,
      "total_pages": 1,
      "has_next": false,
      "has_prev": false
    }
  }
}
```

### GET /news/{slug}
**説明**: 公開ニュース詳細取得  
**権限**: public  

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "新商品のお知らせ",
    "content": "詳細な記事内容...",
    "slug": "new-product-announcement",
    "published_at": "2025-07-22T10:00:00Z",
    "created_at": "2025-07-22T09:00:00Z",
    "meta_title": "SEO用タイトル",
    "meta_description": "SEO用説明文",
    "tags": [
      {"id": "tag-001", "name": "新商品", "color": "#ff6b6b"},
      {"id": "tag-002", "name": "缶バッジ", "color": "#4ecdc4"}
    ],
    "files": [
      {
        "id": "file-001",
        "usage_type": "thumbnail",
        "file_path": "news/thumb.jpg",
        "alt_text": "サムネイル",
        "caption": ""
      },
      {
        "id": "file-002", 
        "usage_type": "inline",
        "sort_order": 1,
        "file_path": "news/image1.jpg",
        "alt_text": "商品画像1",
        "caption": "新商品の外観"
      }
    ]
  }
}
```

### GET /news/tags
**説明**: ニュース用タグ一覧取得  
**権限**: public  

**レスポンス例**:
```json
{
  "success": true,
  "data": [
    {"id": "tag-001", "name": "新商品", "color": "#ff6b6b", "count": 5},
    {"id": "tag-002", "name": "缶バッジ", "color": "#4ecdc4", "count": 8}
  ]
}
```


## 4.2 商品 API

### GET /products
**説明**: 公開商品一覧取得  
**権限**: public  
**パラメータ**:
```
?page=1&per_page=20&category=badge&is_featured=true&search=keyword&tags=tag1,tag2
```

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "uuid",
        "name": "高品質缶バッジ",
        "description": "機構部品メーカーの技術力による...",
        "category": "badge",
        "slug": "high-quality-badge",
        "price_min": 100.00,
        "price_max": 5000.00,
        "specifications": "直径32mm、素材：ブリキ",
        "features": "高精度、耐久性",
        "is_featured": true,
        "meta_title": "SEO用タイトル",
        "meta_description": "SEO用説明文",
        "created_at": "2025-07-22T09:00:00Z",
        "tags": [
          {"id": "tag-003", "name": "高品質", "color": "#45b7d1"}
        ],
        "thumbnail": {
          "id": "file-003",
          "file_path": "products/badge-thumb.jpg",
          "alt_text": "缶バッジサムネイル"
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total_items": 15,
      "total_pages": 1,
      "has_next": false,
      "has_prev": false
    }
  }
}
```

### GET /products/{slug}
**説明**: 公開商品詳細取得  
**権限**: public  

### GET /products/categories
**説明**: 商品カテゴリ一覧取得  
**権限**: public  

**レスポンス例**:
```json
{
  "success": true,
  "data": [
    {"category": "badge", "name": "缶バッジ", "count": 8},
    {"category": "acrylic", "name": "アクリル", "count": 5},
    {"category": "patent", "name": "特許製品", "count": 2}
  ]
}
```


## 4.3 問い合わせ API

### POST /inquiries
**説明**: 問い合わせ送信  
**権限**: public  

**リクエスト例**:
```json
{
  "inquiry_type": "estimate",
  "company_name": "株式会社サンプル",
  "contact_name": "田中太郎",
  "email": "tanaka@example.com",
  "phone": "03-1234-5678",
  "subject": "缶バッジの見積依頼",
  "message": "1000個の缶バッジ製作をお願いしたいです...",
  "product_category": "badge",
  "quantity": 1000
}
```

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "inquiry_number": "INQ-20250722-001",
    "message": "お問い合わせを承りました。24時間以内にご返信いたします。"
  }
}
```


## 4.4 ファイル API

### GET /files/{file_path}
**説明**: ファイル取得（プロキシ）  
**権限**: public（パブリックファイルのみ）


## 5. 管理者 API

### 5.1 ニュース管理

#### GET /admin/news
**説明**: 管理者向けニュース一覧（全ステータス）  
**権限**: admin  
**パラメータ**:
```
?page=1&per_page=20&status=all&search=keyword&tags=tag1,tag2
```

#### POST /admin/news
**説明**: ニュース作成  
**権限**: admin  

**リクエスト例**:
```json
{
  "title": "新商品のお知らせ",
  "content": "記事内容...",
  "slug": "new-product-announcement",
  "status": "draft",
  "meta_title": "SEO用タイトル",
  "meta_description": "SEO用説明文",
  "published_at": "2025-07-22T10:00:00Z",
  "tag_ids": ["tag-001", "tag-002"]
}
```

#### GET /admin/news/{id}
**説明**: ニュース取得  
**権限**: admin  

#### PUT /admin/news/{id}
**説明**: ニュース更新  
**権限**: admin  

#### DELETE /admin/news/{id}
**説明**: ニュース削除  
**権限**: admin  

### 5.2 商品管理

#### GET /admin/products
**説明**: 管理者向け商品一覧（全ステータス）  
**権限**: admin  

#### POST /admin/products
**説明**: 商品作成  
**権限**: admin  

#### PUT /admin/products/{id}
**説明**: 商品更新  
**権限**: admin  

#### DELETE /admin/products/{id}
**説明**: 商品削除  
**権限**: admin  

### 5.3 問い合わせ管理

#### GET /admin/inquiries
**説明**: 管理者向け問い合わせ一覧  
**権限**: admin  
**パラメータ**:
```
?page=1&per_page=20&status=new&inquiry_type=estimate&assigned_to=uuid
```

#### GET /admin/inquiries/{id}
**説明**: 問い合わせ詳細取得  
**権限**: admin  

#### PUT /admin/inquiries/{id}
**説明**: 問い合わせ更新（ステータス、担当者、メモ）  
**権限**: admin  

**リクエスト例**:
```json
{
  "status": "in_progress",
  "assigned_to": "uuid",
  "admin_notes": "見積書を作成中"
}
```

#### GET /admin/inquiries/stats
**説明**: 問い合わせ統計データ  
**権限**: admin  

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "total_inquiries": 150,
    "new_inquiries": 5,
    "in_progress": 8,
    "this_month": 25,
    "by_type": {
      "estimate": 80,
      "general": 50,
      "sample": 20
    },
    "by_category": {
      "badge": 70,
      "acrylic": 50,
      "patent": 30
    }
  }
}
```

### 5.4 タグ管理

#### GET /admin/tags
**説明**: タグ一覧取得  
**権限**: admin  

#### POST /admin/tags
**説明**: タグ作成  
**権限**: admin  

**リクエスト例**:
```json
{
  "name": "新技術",
  "color": "#9b59b6"
}
```

#### PUT /admin/tags/{id}
**説明**: タグ更新  
**権限**: admin  

#### DELETE /admin/tags/{id}
**説明**: タグ削除  
**権限**: admin  

### 5.5 ファイル管理

#### POST /admin/files/upload
**説明**: ファイルアップロード  
**権限**: admin  

**リクエスト**: multipart/form-data
```
file: <file_data>
entity_type: news|product|inquiry
entity_id: uuid
usage_type: thumbnail|inline|attachment
sort_order: integer (optional)
caption: string (optional)
alt_text: string (optional)
```

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "original_name": "product_image.jpg",
    "file_path": "products/uuid/product_image.jpg",
    "file_type": "image/jpeg",
    "file_size": 1024000,
    "usage_type": "inline",
    "sort_order": 1,
    "caption": "商品画像",
    "alt_text": "高品質缶バッジ",
    "url": "https://supabase.storage.url/products/uuid/product_image.jpg"
  }
}
```

#### DELETE /admin/files/{id}
**説明**: ファイル削除  
**権限**: admin  

### 5.6 ダッシュボード

#### GET /admin/dashboard
**説明**: ダッシュボードデータ  
**権限**: admin  

**レスポンス例**:
```json
{
  "success": true,
  "data": {
    "inquiries": {
      "new": 5,
      "total_this_month": 25
    },
    "news": {
      "published": 12,
      "draft": 3
    },
    "products": {
      "active": 15,
      "featured": 3
    },
    "recent_inquiries": [
      {
        "id": "uuid",
        "company_name": "株式会社サンプル",
        "subject": "見積依頼",
        "created_at": "2025-07-22T10:00:00Z"
      }
    ]
  }
}
```

#### GET /admin/users
**説明**: 管理者ユーザー一覧  
**権限**: admin  

---

## 6. HTTPステータスコード

| コード | 説明 | 使用場面 |
|--------|------|----------|
| 200 | OK | 成功 |
| 201 | Created | 作成成功 |
| 400 | Bad Request | バリデーションエラー |
| 401 | Unauthorized | 認証エラー |
| 403 | Forbidden | 権限エラー |
| 404 | Not Found | リソースが見つからない |
| 422 | Unprocessable Entity | データ形式エラー |
| 500 | Internal Server Error | サーバーエラー |


---

## 8. セキュリティ

### 8.1 認証・認可
- Clerk JWT検証
- 管理者権限チェック
- レート制限実装

### 8.2 データ保護
- SQL injection対策
- XSS対策
- ファイルアップロード検証
- 入力データサニタイズ

---

**更新日**: 2025年7月22日  
**ステータス**: v1.0・レビュー待ち  
**総エンドポイント数**: 30エンドポイント（パブリック8、管理者22）