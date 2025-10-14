#!/bin/bash

# Docker构建测试脚本
# 用于本地测试Docker构建过程

echo "=== STRM Helper Docker Build Test ==="
echo "Timestamp: $(date)"

# 清理之前的构建缓存
echo "Cleaning previous build cache..."
docker system prune -f

# 测试简化版Dockerfile
echo "=== Testing Simplified Dockerfile ==="
docker build -f Dockerfile.test -t strm-helper-test:simplified . || {
    echo "❌ Simplified Dockerfile build failed"
    exit 1
}

# 测试生产版Dockerfile（仅前端部分）
echo "=== Testing Production Dockerfile (Frontend Only) ==="
docker build --target frontend-builder -t strm-helper-test:frontend . || {
    echo "❌ Production Dockerfile frontend build failed"
    exit 1
}

# 如果前端构建成功，测试完整构建
echo "=== Testing Full Production Build ==="
docker build -t strm-helper-test:full . || {
    echo "❌ Full production build failed"
    exit 1
}

echo "✅ All Docker builds completed successfully!"

# 显示构建结果
echo "=== Build Results ==="
docker images | grep strm-helper-test

echo "=== Test Summary ==="
echo "✅ Simplified Dockerfile: PASSED"
echo "✅ Frontend-only build: PASSED" 
echo "✅ Full production build: PASSED"
echo ""
echo "You can now run:"
echo "  docker run -it strm-helper-test:full"
echo ""
echo "Or test the frontend build:"
echo "  docker run -it --entrypoint /bin/sh strm-helper-test:frontend"
echo "  ls -la /app/frontend/dist/"
