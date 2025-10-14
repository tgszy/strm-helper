FROM python:3.11-slim
WORKDIR /app

# 安装系统依赖（可选，如需编译）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制源码 & 启动脚本
COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 数据卷（持久化 SQLite）
VOLUME ["/app/data"]

EXPOSE 8000
ENTRYPOINT ["./entrypoint.sh"]
