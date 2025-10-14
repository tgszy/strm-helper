"""
STRM Center 主入口
包含：REST / WebSocket / 静态文件 / 定时任务 / 健康检查
"""
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from backend.api import media, organize, settings, ws
from backend.core.db import create_table

app = FastAPI(
    title="STRM Center API",
    version="0.5.0",
    description="STRM Helper - 媒体文件管理和 STRM 生成工具",
    docs_url="/docs",
    redoc_url="/redoc",
)

# ---------- CORS ----------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境可改具体域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------- 健康检查 ----------
@app.get("/")
async def root():
    return JSONResponse({
        "message": "STRM Center API 正在运行",
        "version": "0.5.0",
        "docs": "/docs",
        "health": "healthy"
    })

@app.get("/health")
async def health_check():
    return JSONResponse({
        "status": "healthy",
        "service": "strm-helper",
        "version": "0.5.0"
    })

# ---------- 业务路由 ----------
app.include_router(media.router, prefix="/api/media")
app.include_router(organize.router, prefix="/api/organize")
app.include_router(settings.router, prefix="/api/settings")
app.include_router(ws.router, prefix="/api")

# ---------- 前端静态文件（必须放最后，兜底） ----------
app.mount("/", StaticFiles(directory="/app/dist", html=True), name="static")

# ---------- 启动事件 ----------
@app.on_event("startup")
async def on_start():
    create_table()
