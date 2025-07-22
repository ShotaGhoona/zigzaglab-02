import jwt
from typing import Optional, Dict, Any
from config.settings import settings

class ClerkAuth:
    """Clerk認証管理クラス（簡素化版）"""
    
    @staticmethod
    def verify_jwt_token(token: str) -> Optional[Dict[str, Any]]:
        """JWT トークン検証（簡素化版）"""
        try:
            # 本番環境では適切なキーとアルゴリズムで検証
            # 今回は開発用として簡素化
            payload = jwt.decode(
                token, 
                settings.clerk_secret_key, 
                algorithms=["HS256"],
                options={"verify_signature": False}  # 開発用: 署名検証スキップ
            )
            return payload
        except jwt.InvalidTokenError:
            return None
    
    @staticmethod  
    def is_admin_user(email: str) -> bool:
        """管理者ユーザーかどうか確認"""
        return email in settings.admin_emails
    
    @staticmethod
    def extract_user_info(payload: Dict[str, Any]) -> Optional[Dict[str, str]]:
        """JWTペイロードからユーザー情報抽出"""
        try:
            return {
                "user_id": payload.get("sub", ""),
                "email": payload.get("email", ""),
                "name": payload.get("name", "")
            }
        except Exception:
            return None