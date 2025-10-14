#!/bin/sh
set -e

log() {
  echo "[$(date '+%F %T')] $*"
}

# 创建数据目录
mkdir -p /app/data

case "${1:-api}" in
  api)
    log "Starting STRM Helper API server..."
    exec uvicorn backend.main:app \
      --host 0.0.0.0 \
      --port 35455 \
      --access-log \
      --log-level info \
      --workers 1
    ;;
  worker)
    log "Starting Celery worker..."
    exec celery -A backend.celery_app.celery worker -l info -Q default -c 4
    ;;
  beat)
    log "Starting Celery beat scheduler..."
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
