from fastapi import FastAPI
from backend.api import ws   # 只导入存在的模块
# from backend.core.db import create_table  # 注释掉不存在的导入

app = FastAPI(title="STRM Center API", version="0.5.0")
# 注释掉不存在的路由
# app.include_router(media.router, prefix="/api/media")
# app.include_router(organize.router, prefix="/api/organize")
# app.include_router(settings.router, prefix="/api/settings")
app.include_router(ws.router, prefix="/api")            # WebSocket 路由
# 找到 app = FastAPI(...) 下方追加
import uvicorn
if __name__ == "__main__":
    uvicorn.run("backend.main:app", host="0.0.0.0", port=35455)
