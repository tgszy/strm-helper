#!/bin/sh
# 创建数据目录 & 运行
mkdir -p /app/data
exec uvicorn backend.main:app --host 0.0.0.0 --port 8000
