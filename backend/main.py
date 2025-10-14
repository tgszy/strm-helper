from fastapi import FastAPI
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from backend.api import ws   # 只导入存在的模块
# from backend.core.db import create_table  # 注释掉不存在的导入

app = FastAPI(
    title="STRM Center API", 
    version="0.5.0",
    description="STRM Helper - 媒体文件管理和 STRM 生成工具",
    docs_url="/docs",
    redoc_url="/redoc"
)

# 添加 CORS 中间件
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 在生产环境中应该设置具体的域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 添加根路径路由
@app.get("/")
async def root():
    return JSONResponse({
        "message": "STRM Center API 正在运行",
        "version": "0.5.0",
        "docs": "/docs",
        "health": "healthy"
    })

# 添加健康检查路由
@app.get("/health")
async def health_check():
    return JSONResponse({
        "status": "healthy",
        "service": "strm-helper",
        "version": "0.5.0"
    })

# 添加基础 API 路由
@app.get("/api/info")
async def api_info():
    """获取 API 信息"""
    return JSONResponse({
        "name": "STRM Center API",
        "version": "0.5.0",
        "features": {
            "websocket": True,
            "celery": True,
            "plugins": True
        },
        "endpoints": {
            "docs": "/docs",
            "health": "/health",
            "websocket": "/api/ws/log/{task_id}"
        }
    })

# 注释掉不存在的路由
# app.include_router(media.router, prefix="/api/media")
# app.include_router(organize.router, prefix="/api/organize")
# app.include_router(settings.router, prefix="/api/settings")
app.include_router(ws.router, prefix="/api")            # WebSocket 路由
# 找到 app = FastAPI(...) 下方追加
import uvicorn
if __name__ == "__main__":
    uvicorn.run("backend.main:app", host="0.0.0.0", port=35455)
