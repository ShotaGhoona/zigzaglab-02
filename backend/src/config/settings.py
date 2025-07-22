from pydantic_settings import BaseSettings
from typing import List
import os

class Settings(BaseSettings):
    # Supabase
    supabase_url: str = ""
    supabase_service_role_key: str = ""
    
    # Clerk認証
    clerk_secret_key: str = ""
    
    # 管理者
    admin_emails: List[str] = []
    
    # CORS設定
    allowed_origins: List[str] = [
        "https://zigzaglab.com",
        "http://localhost:3000",
        "http://localhost:3001"
    ]
    
    # 開発設定
    debug: bool = True
    host: str = "0.0.0.0"
    port: int = 8000

    class Config:
        env_file = ".env"
        
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # admin_emailsを文字列から分割
        if isinstance(self.admin_emails, str):
            self.admin_emails = [email.strip() for email in self.admin_emails.split(",")]

settings = Settings()