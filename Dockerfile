# ============== 前端构建阶段 ==============
FROM --platform=$BUILDPLATFORM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

RUN apk add --no-cache python3 make g++ git && \
    npm config set registry https://registry.npmmirror.com

# ① 安装 pnpm
RUN npm install -g pnpm@9 --prefix=/usr/local && \
    ln -s /usr/local/bin/pnpm /usr/bin/pnpm

# ② 装依赖（含 dev）
COPY frontend/pnpm-lock.yaml ./
COPY frontend/package*.json ./
RUN pnpm install --frozen-lockfile

COPY frontend/ ./
COPY .git ./.git

# ③ 用 pnpm exec 显式调用（Alpine 安全）
RUN pnpm exec vue-tsc && pnpm exec vite build

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
COPY --from=frontend-builder /app/frontend/dist /app/dist
RUN mkdir -p /app/data /media /strm
VOLUME ["/app/data", "/media", "/strm"]
EXPOSE 35455
ENTRYPOINT ["./entrypoint.sh"]
