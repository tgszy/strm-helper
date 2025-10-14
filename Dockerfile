FROM python:3.11-slim
WORKDIR /app

# 1. 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 2. 复制源码
COPY backend ./backend
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# 3. 数据卷（持久化 SQLite）
VOLUME ["/app/data"]

# 4. 暴露端口
EXPOSE 8000

# 5. 启动
ENTRYPOINT ["./entrypoint.sh"]
