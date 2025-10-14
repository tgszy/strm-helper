# 1) 强制 x86_64 平台，保证 NAS 拉到的肯定是 amd64 镜像
FROM --platform=linux/amd64 python:3.11-slim

# 2) 设置工作目录
WORKDIR /app

# 3) 先拷依赖，利用缓存
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4) 再拷源码（包含 app/ 整个包）
COPY . .

# 5) 声明端口
EXPOSE 8000

# 6) 启动命令
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
