from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config.settings import settings

app = FastAPI(
    title="ZIGZAGLAB API",
    description="ZIGZAGLAB Backend API",
    version="1.0.0"
)

# CORS設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ヘルスチェック
@app.get("/")
async def root():
    return {"message": "ZIGZAGLAB API is running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# API v1 ルーター（後で追加予定）
# app.include_router(news_router, prefix="/api/v1", tags=["news"])
# app.include_router(products_router, prefix="/api/v1", tags=["products"])
# app.include_router(inquiries_router, prefix="/api/v1", tags=["inquiries"])
# app.include_router(admin_router, prefix="/api/v1/admin", tags=["admin"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)