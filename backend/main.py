from backend.api import media, organize, settings, ws   # 新增 ws
from backend.core.db import create_table

app = FastAPI(title="STRM Center API", version="0.5.0")
app.include_router(media.router, prefix="/api/media")
app.include_router(organize.router, prefix="/api/organize")
app.include_router(settings.router, prefix="/api/settings")
app.include_router(ws.router, prefix="/api")            # 新增 WebSocket
# 找到 app = FastAPI(...) 下方追加
import uvicorn
if __name__ == "__main__":
    uvicorn.run("backend.main:app", host="0.0.0.0", port=35455)
