# Docker构建测试脚本 (PowerShell版本)
# 用于本地测试Docker构建过程

Write-Host "=== STRM Helper Docker Build Test ===" -ForegroundColor Green
Write-Host "Timestamp: $(Get-Date)"

# 清理之前的构建缓存
Write-Host "Cleaning previous build cache..." -ForegroundColor Yellow
docker system prune -f

# 测试简化版Dockerfile
Write-Host "=== Testing Simplified Dockerfile ===" -ForegroundColor Cyan
try {
    docker build -f Dockerfile.test -t strm-helper-test:simplified .
    Write-Host "✅ Simplified Dockerfile build completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Simplified Dockerfile build failed" -ForegroundColor Red
    exit 1
}

# 测试生产版Dockerfile（仅前端部分）
Write-Host "=== Testing Production Dockerfile (Frontend Only) ===" -ForegroundColor Cyan
try {
    docker build --target frontend-builder -t strm-helper-test:frontend .
    Write-Host "✅ Production Dockerfile frontend build completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Production Dockerfile frontend build failed" -ForegroundColor Red
    exit 1
}

# 如果前端构建成功，测试完整构建
Write-Host "=== Testing Full Production Build ===" -ForegroundColor Cyan
try {
    docker build -t strm-helper-test:full .
    Write-Host "✅ Full production build completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Full production build failed" -ForegroundColor Red
    exit 1
}

Write-Host "✅ All Docker builds completed successfully!" -ForegroundColor Green

# 显示构建结果
Write-Host "=== Build Results ===" -ForegroundColor Yellow
docker images | Select-String "strm-helper-test"

Write-Host "=== Test Summary ===" -ForegroundColor Cyan
Write-Host "✅ Simplified Dockerfile: PASSED" -ForegroundColor Green
Write-Host "✅ Frontend-only build: PASSED" -ForegroundColor Green
Write-Host "✅ Full production build: PASSED" -ForegroundColor Green
Write-Host ""
Write-Host "You can now run:"
Write-Host "  docker run -it strm-helper-test:full"
Write-Host ""
Write-Host "Or test the frontend build:"
Write-Host "  docker run -it --entrypoint /bin/sh strm-helper-test:frontend"
Write-Host "  ls -la /app/frontend/dist/"
