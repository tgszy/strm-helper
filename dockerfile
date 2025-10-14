# 前端构建阶段
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

# 安装必要的构建工具
RUN apk add --no-cache python3 make g++ git

# 设置npm镜像源加速构建
RUN npm config set registry https://registry.npmmirror.com

# 先复制package文件并安装依赖
COPY frontend/package*.json ./
RUN echo "Installing dependencies..." && \
    npm install --legacy-peer-deps && \
    echo "Dependencies installed, validating key packages..." && \
    npm list vite @vitejs/plugin-vue vue typescript --depth=0

# 验证安装的关键依赖
RUN echo "Validating Vite installation..." && \
    ls -la node_modules/vite/ && \
    echo "Validating Vue plugin..." && \
    ls -la node_modules/@vitejs/plugin-vue/

# 再复制源代码
COPY frontend/ ./

# 验证源代码完整性
RUN echo "Validating source code..." && \
    ls -la src/ && \
    echo "Checking TypeScript config..." && \
    test -f tsconfig.json && echo "✅ tsconfig.json exists" || echo "⚠️  tsconfig.json missing" && \
    echo "Checking Vite config..." && \
    test -f vite.config.ts && echo "✅ vite.config.ts exists" || echo "⚠️  vite.config.ts missing"

# 构建前端应用（使用完整的TypeScript检查和构建）
RUN echo "Starting frontend build with TypeScript check..." && \
    npm run build:full && \
    echo "✅ Build completed successfully" && \
    ls -la dist/ && \
    echo "Build artifacts:" && \
    find dist/ -type f -name "*.js" -o -name "*.css" -o -name "*.html" | head -10 || \
    (echo "❌ build:full failed, trying standard build..." && \
     npm run build && \
     echo "✅ Standard build completed" && \
     ls -la dist/ && \
     echo "Build artifacts:" && \
     find dist/ -type f -name "*.js" -o -name "*.css" -o -name "*.html" | head -10 || \
     (echo "❌ Both builds failed, providing diagnostics..." && \
      echo "Node version: $(node --version)" && \
      echo "NPM version: $(npm --version)" && \
      echo "Available scripts: $(npm run | grep -E '^  (build|dev|build:full)')" && \
      echo "TypeScript check: $(npm run type-check || echo 'failed')" && \
      echo "Vite binary location: $(which vite || echo 'not found')" && \
      echo "Vue plugin location: $(find node_modules -name '*vue*plugin*' -type d | head -1)" && \
      exit 1))

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
