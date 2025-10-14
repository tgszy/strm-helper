#!/bin/sh
set -e

# 创建数据目录（若不存在）
mkdir -p /app/data

# 根据传入的参数决定启动模式
case "${1:-api}" in
  api)
    echo "Starting STRM Helper API server..."
    exec uvicorn backend.main:app --host 0.0.0.0 --port 35455
    ;;
  worker)
    echo "Starting Celery worker..."
    exec celery -A backend.celery_app.celery worker -l info -Q default -c 4
    ;;
  beat)
    echo "Starting Celery beat scheduler..."
    exec celery -A backend.celery_app.celery beat -l info
    ;;
  *)
    echo "Usage: $0 {api|worker|beat}"
    echo "  api     - 启动后端API服务 (默认)"
    echo "  worker  - 启动Celery工作进程"
    echo "  beat    - 启动Celery定时任务调度器"
    exit 1
    ;;
esac
