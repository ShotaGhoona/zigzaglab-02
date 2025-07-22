from abc import ABC, abstractmethod
from typing import List, Dict, Any, Optional
from config.database import supabase
from schemas.common import PaginationInfo

class BaseRepository(ABC):
    """共通CRUD操作を提供する基底リポジトリクラス"""
    
    def __init__(self, table_name: str):
        self.table_name = table_name
        self.client = supabase
    
    async def find_all(
        self, 
        page: int = 1, 
        per_page: int = 20,
        filters: Optional[Dict[str, Any]] = None,
        order_by: Optional[str] = "created_at",
        desc: bool = True
    ) -> tuple[List[Dict], PaginationInfo]:
        """全件検索（ページネーション対応）"""
        
        query = self.client.table(self.table_name).select("*")
        
        # フィルタ適用
        if filters:
            for key, value in filters.items():
                if isinstance(value, list):
                    query = query.in_(key, value)
                else:
                    query = query.eq(key, value)
        
        # 総件数取得
        count_result = query.execute()
        total_items = len(count_result.data) if count_result.data else 0
        
        # ページネーション
        start = (page - 1) * per_page
        end = start + per_page - 1
        
        # ソート・制限適用
        if order_by:
            if desc:
                query = query.order(order_by, desc=True)
            else:
                query = query.order(order_by)
        
        query = query.range(start, end)
        
        result = query.execute()
        items = result.data if result.data else []
        
        # ページネーション情報作成
        total_pages = (total_items + per_page - 1) // per_page
        pagination = PaginationInfo(
            current_page=page,
            per_page=per_page,
            total_items=total_items,
            total_pages=total_pages,
            has_next=page < total_pages,
            has_prev=page > 1
        )
        
        return items, pagination
    
    async def find_by_id(self, id: str) -> Optional[Dict]:
        """ID検索"""
        result = self.client.table(self.table_name).select("*").eq("id", id).execute()
        return result.data[0] if result.data else None
    
    async def create(self, data: Dict[str, Any]) -> Dict:
        """作成"""
        result = self.client.table(self.table_name).insert(data).execute()
        return result.data[0] if result.data else None
    
    async def update(self, id: str, data: Dict[str, Any]) -> Optional[Dict]:
        """更新"""
        result = self.client.table(self.table_name).update(data).eq("id", id).execute()
        return result.data[0] if result.data else None
    
    async def delete(self, id: str) -> bool:
        """削除"""
        result = self.client.table(self.table_name).delete().eq("id", id).execute()
        return len(result.data) > 0 if result.data else False