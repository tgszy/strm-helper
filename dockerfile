# 前端构建阶段
FROM node:18-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# 后端构建阶段
FROM python:3.11-slim
WORKDIR /app

# 安装系统依赖和Node.js（用于前端开发模式）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 源码 & 启动脚本
COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 复制前端构建结果
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist
COPY frontend/package.json ./frontend/
COPY frontend/vite.config.ts ./frontend/

# 在前端目录安装依赖（用于开发模式）
RUN cd frontend && npm install

# 数据卷
VOLUME ["/app/data", "/media", "/strm"]

# 容器内端口与外部一致
EXPOSE 35455 5173

ENTRYPOINT ["./entrypoint.sh"]
