# 前端构建阶段
FROM node:18-alpine AS frontend-builder
WORKDIR /app/frontend

# 设置npm镜像源加速构建
RUN npm config set registry https://registry.npmmirror.com

# 先复制package文件并安装依赖
COPY frontend/package*.json ./
RUN npm install

# 再复制源代码并构建
COPY frontend/ ./
RUN npm run build

# 后端构建阶段
FROM python:3.11-slim
WORKDIR /app

# 安装系统依赖（仅Python需要）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 源码 & 启动脚本
COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 复制前端构建结果（仅生产构建）
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist
COPY frontend/package.json ./frontend/
COPY frontend/vite.config.ts ./frontend/

# 数据卷
VOLUME ["/app/data", "/media", "/strm"]

# 容器内端口与外部一致
EXPOSE 35455

ENTRYPOINT ["./entrypoint.sh"]
