# ============== 前端构建阶段 ==============
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

# 基础工具
RUN apk add --no-cache python3 make g++ git

# 国内镜像 + 依赖 + 构建
RUN npm config set registry https://registry.npmmirror.com
COPY frontend/package*.json ./
RUN npm install --legacy-peer-deps
COPY frontend/ ./
RUN npm run build           # 只保留这一行核心构建

# ============== 后端运行阶段 ==============
FROM python:3.11-slim
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 前端产物（必须与 main.py 挂载路径一致）
COPY --from=frontend-builder /app/frontend/dist /app/dist

VOLUME ["/app/data", "/media", "/strm"]
EXPOSE 35455
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:35455/health || exit 1

ENTRYPOINT ["./entrypoint.sh"]
