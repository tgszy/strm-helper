#!/bin/sh
set -e

# 日志带时间戳
log() {
  echo "[$(date '+%F %T')] $*"
}

# 1. 创建运行时目录（即使被卷覆盖，也确保父级存在）
mkdir -p /app/data /media /strm

# 2. 检查前端产物是否存在（.dockerignore 忽略本地 dist，但镜像里必须有多阶段产物）
if [ ! -f "/app/dist/index.html" ]; then
  log "ERROR: Frontend dist not found! Re-build image with frontend-builder stage."
  exit 1
fi

# 3. 根据传入参数启动
case "${1:-api}" in
  api)
    log "Starting STRM Helper API server..."
    # 监听 0.0.0.0:35455，开启 access 日志，单 worker 适合 NAS
    exec uvicorn backend.main:app \
      --host 0.0.0.0 \
      --port 35455 \
      --access-log \
      --log-level info \
      --workers 1
    ;;

  worker)
    log "Starting Celery worker..."
    exec celery -A backend.celery_app.celery worker \
      -l info \
      -Q default \
      -c 4
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
