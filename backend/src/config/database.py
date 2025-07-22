from supabase import create_client, Client
from config.settings import settings

class SupabaseManager:
    _client: Client = None
    
    @classmethod
    def get_client(cls) -> Client:
        if cls._client is None:
            cls._client = create_client(
                settings.supabase_url,
                settings.supabase_service_role_key
            )
        return cls._client
    
    @classmethod  
    async def test_connection(cls) -> bool:
        """データベース接続テスト"""
        try:
            client = cls.get_client()
            # admin_users テーブルの存在確認
            result = client.table('admin_users').select("id").limit(1).execute()
            return True
        except Exception as e:
            print(f"Database connection failed: {e}")
            return False

# グローバルクライアントインスタンス
supabase: Client = SupabaseManager.get_client()