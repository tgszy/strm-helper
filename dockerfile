# 前端构建阶段
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

# 安装必要的工具
RUN apk add --no-cache python3 make g++

# 设置npm镜像源加速构建
RUN npm config set registry https://registry.npmmirror.com

# 先复制package文件并安装依赖
COPY frontend/package*.json ./
RUN npm install --legacy-peer-deps && \
    echo "Dependencies installed successfully" && \
    ls -la node_modules/@vitejs/plugin-vue && \
    ls -la node_modules/vite

# 再复制源代码并构建
COPY frontend/ ./

# 构建前端应用
RUN echo "Building frontend application..." && \
    npm run build && \
    echo "Build completed successfully" && \
    ls -la dist/

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
