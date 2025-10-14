#!/bin/sh
# 创建数据目录（若不存在）
mkdir -p /app/data
# 启动 FastAPI —— 监听 35455
exec uvicorn backend.main:app --host 0.0.0.0 --port 35455
