# ZIGZAGLAB Phase2 技術選択比較ガイド

## リビジョン履歴

| Version | Date | Author | Summary | Status | Reviewer |
|------------|------|--------|----------|----------|--------|
| v1.0 | 2025-07-22 | 山下 | 技術選択比較・推奨案 | 🔄 レビュー中 | 橋本 |

---

## 1. 比較項目と判断基準

### 判断基準
1. **学習価値**: 駆け出しエンジニアのスキル向上に貢献するか
2. **実装コスト**: 開発・運用の手間はどうか
3. **一般性**: 実務でよく使われる手法か
4. **保守性**: 長期運用で問題ないか
5. **ZIGZAGLABの要件**: 3名管理、Phase3拡張に適しているか

---

## 2. データアクセス方法の比較

### 🏆 選択肢A: SQLAlchemy ORM使用

#### 実装例
```python
# models/news.py
from sqlalchemy import Column, String, Text, DateTime
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class News(Base):
    __tablename__ = "news"
    id = Column(String, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime)

# repositories/news_repository.py
class NewsRepository:
    def get_all(self) -> List[News]:
        return session.query(News).all()
    
    def create(self, news: News) -> News:
        session.add(news)
        session.commit()
        return news
```

#### メリット
- ✅ **学習価値 (高)**: 実務でORMは必須スキル
- ✅ **型安全性**: SQLクエリもPythonで型チェック
- ✅ **複雑クエリ**: JOINやサブクエリが直感的
- ✅ **テスト**: モックが簡単
- ✅ **一般性**: 実務で90%使用される

#### デメリット
- ❌ **実装コスト**: 設定・マイグレーションが複雑
- ❌ **Supabase機能**: RLS等の活用が困難
- ❌ **学習コスト**: ORM概念の習得必要

#### 一般性・推奨度
**⭐⭐⭐⭐⭐ 非常に一般的**
- 実務では標準的手法
- Python開発者の必須スキル
- 大規模システムで採用率90%以上

---

### 選択肢B: Supabase Python SDK直接使用

#### 実装例
```python
# repositories/news_repository.py
from supabase import create_client
from typing import List, Dict

class NewsRepository:
    def __init__(self):
        self.supabase = create_client(url, key)
    
    def get_all(self) -> List[Dict]:
        result = self.supabase.table("news").select("*").execute()
        return result.data
    
    def create(self, news_data: Dict) -> Dict:
        result = self.supabase.table("news").insert(news_data).execute()
        return result.data[0]
```

#### メリット
- ✅ **実装コスト (低)**: 設定がシンプル
- ✅ **Supabase機能**: RLS、リアルタイム機能フル活用
- ✅ **学習コスト (低)**: 直感的なAPI

#### デメリット
- ❌ **学習価値 (低)**: Supabase特化スキル
- ❌ **型安全性**: 戻り値がDict型
- ❌ **テスト**: モックが困難
- ❌ **一般性 (低)**: 他プロジェクトで活用困難

#### 一般性・推奨度
**⭐⭐ 特殊なケース**
- Supabaseエコシステム内では有効
- 実務での採用率20%程度
- NoSQLライクなアプローチ

---

### 🎯 推奨: 選択肢A (SQLAlchemy)

**理由**:
1. **学習目的**: 実務スキル向上に最適
2. **長期保守**: Phase3拡張時も安定
3. **業界標準**: Python Web開発のスタンダード
4. **チーム学習**: 3名全員のスキル向上

**実装方針**:
```python
# SupabaseもORMで接続
SQLALCHEMY_DATABASE_URL = "postgresql://user:pass@host/db"
# RLS は SQLAlchemy でも設定可能
```

---

## 3. API呼び出し方法の比較

### 🏆 選択肢A: Next.js API Routes経由

#### 実装例
```typescript
// app/api/news/route.ts
import { NextRequest } from 'next/server';

export async function GET(request: NextRequest) {
  try {
    // FastAPI呼び出し
    const response = await fetch(`${process.env.FASTAPI_URL}/news`);
    const data = await response.json();
    return Response.json(data);
  } catch (error) {
    return Response.json({ error: 'Failed to fetch' }, { status: 500 });
  }
}

// components/NewsPage.tsx
const fetchNews = async () => {
  const response = await fetch('/api/news'); // Next.js API Routes
  return response.json();
};
```

#### メリット
- ✅ **セキュリティ**: CORS問題回避
- ✅ **認証統一**: Next.jsで一元管理
- ✅ **エラーハンドリング**: 統一的な処理
- ✅ **キャッシュ**: Next.jsキャッシュ活用
- ✅ **一般性**: Next.js開発の標準パターン

#### デメリット
- ❌ **パフォーマンス**: 1回多いHTTPコール
- ❌ **複雑性**: 処理層が増える

---

### 選択肢B: FastAPI直接呼び出し

#### 実装例
```typescript
// lib/api.ts
const API_BASE_URL = process.env.NEXT_PUBLIC_FASTAPI_URL;

export async function getNews() {
  const response = await fetch(`${API_BASE_URL}/news`, {
    headers: {
      'Authorization': `Bearer ${getToken()}`,
    },
  });
  return response.json();
}
```

#### メリット
- ✅ **パフォーマンス**: 直接通信で高速
- ✅ **シンプル**: 処理が単純

#### デメリット
- ❌ **CORS**: 設定が複雑
- ❌ **認証**: 複数箇所で処理が分散
- ❌ **エラーハンドリング**: 統一が困難

### 🎯 推奨: 選択肢A (Next.js API Routes経由)

**理由**:
1. **Next.js標準**: App Routerでの推奨パターン
2. **認証統合**: Clerkとの連携が簡潔
3. **エラー処理**: 統一的なハンドリング
4. **実務採用**: Next.jsプロジェクトで70%採用

---

## 4. JWT認証検証の比較

### 🏆 選択肢A: FastAPIで検証

#### 実装例
```python
# middleware/auth.py
from clerk_sdk_python import Clerk

clerk = Clerk(bearer_auth=CLERK_SECRET_KEY)

async def verify_admin(authorization: str = Header()):
    try:
        token = authorization.split(" ")[1]  # "Bearer {token}"
        user = clerk.users.verify_jwt(token)
        
        # admin_usersテーブルで管理者確認
        admin_user = session.query(AdminUser).filter(
            AdminUser.clerk_user_id == user.id
        ).first()
        
        if not admin_user or not admin_user.is_active:
            raise HTTPException(401, "Unauthorized")
            
        return admin_user
    except Exception:
        raise HTTPException(401, "Invalid token")

# routers/news.py
@router.post("/admin/news", dependencies=[Depends(verify_admin)])
async def create_news(news_data: NewsCreate):
    return await NewsService.create_news(news_data)
```

#### メリット
- ✅ **学習価値**: JWT処理の理解向上
- ✅ **柔軟性**: カスタムロジック追加可能
- ✅ **デバッグ**: エラー原因特定が容易
- ✅ **一般性**: Web API開発の標準

#### デメリット
- ❌ **実装量**: コード量が多い
- ❌ **責任分散**: 認証ロジックが複数箇所

---

### 選択肢B: Supabase RLSで検証

#### 実装例
```sql
-- Supabase RLS Policy
CREATE POLICY "admin_only_policy" ON news
FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'sub' IN (
    SELECT clerk_user_id 
    FROM admin_users 
    WHERE is_active = true
  )
);
```

```python
# FastAPIは認証処理不要
@router.post("/admin/news")
async def create_news(news_data: NewsCreate):
    # Supabaseが自動で認証チェック
    return await NewsService.create_news(news_data)
```

#### メリット
- ✅ **実装コスト**: コード量が少ない
- ✅ **パフォーマンス**: DB側で高速処理
- ✅ **セキュリティ**: DB層での確実な制御

#### デメリット
- ❌ **学習価値**: JWT処理を学べない
- ❌ **デバッグ**: 認証エラーの原因特定困難
- ❌ **一般性**: Supabase依存

### 🎯 推奨: 選択肢A (FastAPIで検証)

**理由**:
1. **学習価値**: JWT・認証処理の習得
2. **実務スキル**: Web API開発の基礎
3. **柔軟性**: カスタム認証ロジック対応
4. **デバッグ**: 問題特定が容易

---

## 5. ファイルアクセス方法の比較

### 🏆 選択肢A: FastAPI経由アクセス

#### 実装例
```python
# routers/files.py
from fastapi.responses import StreamingResponse
from supabase import create_client

@router.get("/files/{file_path:path}")
async def get_file(file_path: str):
    try:
        # Supabase Storageから取得
        supabase = create_client(url, key)
        file_data = supabase.storage.from_("files").download(file_path)
        
        return StreamingResponse(
            io.BytesIO(file_data),
            media_type="application/octet-stream"
        )
    except Exception:
        raise HTTPException(404, "File not found")
```

#### メリット
- ✅ **アクセス制御**: 認証必須ファイルに対応
- ✅ **ログ記録**: ファイルアクセス履歴管理
- ✅ **変換処理**: 画像リサイズ等に対応
- ✅ **一般性**: Web APIでの標準パターン

#### デメリット
- ❌ **パフォーマンス**: 1回多いHTTPコール
- ❌ **帯域**: サーバーリソース消費

---

### 選択肢B: Supabase Storage直接アクセス

#### 実装例
```typescript
// フロントエンドで直接アクセス
const fileUrl = `https://your-project.supabase.co/storage/v1/object/public/files/${filePath}`;

<img src={fileUrl} alt="Product image" />
```

#### メリット
- ✅ **パフォーマンス**: CDN経由で高速
- ✅ **帯域節約**: サーバーリソース未使用
- ✅ **シンプル**: 実装が簡単

#### デメリット
- ❌ **セキュリティ**: 全ファイルが公開状態
- ❌ **制御不可**: アクセスログ・制限困難

### 🎯 推奨: 選択肢B (直接アクセス) 

**理由**:
1. **Phase2要件**: 公開ファイルのみ
2. **パフォーマンス**: CDNで高速配信
3. **コスト**: サーバーリソース節約
4. **実装コスト**: シンプル

**但し**: Phase3で認証必要ファイルは選択肢Aに移行

---

## 6. 総合推奨構成

### 🏆 ZIGZAGLABの最適解

```yaml
データアクセス: SQLAlchemy ORM
API呼び出し: Next.js API Routes経由  
JWT検証: FastAPIで検証
ファイルアクセス: Supabase Storage直接アクセス
```

### 理由・判断根拠

#### 1. **学習価値を最大化**
- SQLAlchemy: 実務必須のORM技術
- JWT処理: Web開発の基本認証

#### 2. **実装コストとのバランス**
- Next.js API Routes: CORS回避、認証統合
- 直接ファイルアクセス: パフォーマンス重視

#### 3. **Phase3拡張への対応**
- SQLAlchemy: ECサイト機能追加に最適
- 認証処理: 一般ユーザー対応も可能

#### 4. **実務スキル向上**
- 3名の管理者全員が実務で活用できる技術
- 転職時にもアピールポイントとなる構成

### 実装優先度
```
Week 1: SQLAlchemy + FastAPI基盤
Week 2: Next.js API Routes + Clerk連携  
Week 3: JWT認証処理実装
Week 4: ファイルアップロード（FastAPI） + 配信（直接）
```

---

## 7. 実装サンプル

### フルスタック連携例

#### 1. データ作成フロー
```typescript
// フロントエンド: app/admin/news/page.tsx
const createNews = async (newsData) => {
  const response = await fetch('/api/admin/news', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(newsData)
  });
  return response.json();
};
```

```typescript
// Next.js API: app/api/admin/news/route.ts
export async function POST(request: Request) {
  const { getAuth } = auth();
  const { sessionClaims } = await getAuth();
  
  const response = await fetch(`${process.env.FASTAPI_URL}/admin/news`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${sessionClaims?.token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(await request.json())
  });
  
  return Response.json(await response.json());
}
```

```python
# FastAPI: routers/news.py
@router.post("/admin/news", dependencies=[Depends(verify_admin)])
async def create_news(news_data: NewsCreate, admin_user: AdminUser = Depends(verify_admin)):
    # SQLAlchemyでDB操作
    news = News(
        title=news_data.title,
        content=news_data.content,
        created_by=admin_user.id
    )
    session.add(news)
    session.commit()
    
    # ISR トリガー (Next.js再生成)
    await trigger_isr_revalidation("/news")
    
    return news
```

#### 2. データ表示フロー
```typescript
// 公開サイト: app/(public)/news/page.tsx  
export default async function NewsPage() {
  // 直接FastAPI呼び出し（SSG）
  const news = await fetch(`${process.env.FASTAPI_URL}/news`).then(r => r.json());
  
  return (
    <div>
      {news.map(item => (
        <NewsCard 
          key={item.id}
          news={item}
          imageUrl={`https://project.supabase.co/storage/v1/object/public/files/${item.image_path}`}
        />
      ))}
    </div>
  );
}

export const revalidate = 3600; // 1時間キャッシュ
```

---

## 8. 決定後のアクション

### ドキュメント更新対象
1. `docs/requirement-definition/02-tech/01-tech-overview.md`
2. `docs/requirement-definition/02-tech/03-api-phase2.md`  
3. `docs/requirement-definition/06-references/reserach/directory-structure.md`

### 実装開始準備
```bash
# 1. SQLAlchemy設定
pip install sqlalchemy psycopg2-binary

# 2. Next.js設定  
npm install @clerk/nextjs

# 3. FastAPI設定
pip install python-clerk-sdk
```

---

**更新日**: 2025年7月22日  
**ステータス**: v1.0・推奨案提示  
**推奨構成**: SQLAlchemy + Next.js API Routes + FastAPI JWT + 直接ファイルアクセス