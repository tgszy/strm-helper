# ============== 前端构建阶段 ==============
FROM --platform=$BUILDPLATFORM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

# 基础工具 + 国内镜像
RUN apk add --no-cache python3 make g++ git
RUN npm config set registry https://registry.npmmirror.com

# 依赖 + 构建
COPY frontend/package*.json ./
RUN npm install --legacy-peer-deps
COPY frontend/ ./
# 如果 build:full 需要 .git 版本号，把 .git 目录也拷进去
COPY .git ./.git
RUN npm run build

# ============== 后端运行阶段 ==============
FROM --platform=$BUILDPLATFORM python:3.11-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 前端产物
COPY --from=frontend-builder /app/frontend/dist /app/dist

# 数据卷
VOLUME ["/app/data", "/media", "/strm"]

# 端口
EXPOSE 35455

# 若后端暂未实现 /health，先把 HEALTHCHECK 注释掉
# HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
#   CMD curl -f http://localhost:35455/health || exit 1

ENTRYPOINT ["./entrypoint.sh"]
