FROM python:3.11-slim
WORKDIR /app

# 系统依赖（可选）
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && rm -rf /var/lib/apt/lists/*

# Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 源码 & 启动脚本
COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 数据卷
VOLUME ["/app/data"]

# 容器内端口与外部一致
EXPOSE 35455

ENTRYPOINT ["./entrypoint.sh"]
