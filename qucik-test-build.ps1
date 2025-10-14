# 快速构建测试脚本
Write-Host "=== STRM Helper Quick Build Test ===" -ForegroundColor Green
Write-Host "Testing simplified Dockerfile..." -ForegroundColor Yellow

# 测试简化版Dockerfile
Write-Host "Building with Dockerfile.simple..." -ForegroundColor Cyan
try {
    docker build -f Dockerfile.simple -t strm-helper-quick:test .
    Write-Host "✅ Simplified build completed successfully!" -ForegroundColor Green
    
    # 检查构建结果
    Write-Host "Checking build artifacts..." -ForegroundColor Yellow
    docker run --rm -it --entrypoint /bin/sh strm-helper-quick:test -c "ls -la /app/frontend/dist/"
    
    Write-Host "✅ Quick test passed!" -ForegroundColor Green
    Write-Host "You can now push your changes with confidence." -ForegroundColor Green
} catch {
    Write-Host "❌ Simplified build failed" -ForegroundColor Red
    Write-Host "Trying debug build to get more information..." -ForegroundColor Yellow
    
    try {
        docker build -f Dockerfile.debug -t strm-helper-debug:test .
        Write-Host "✅ Debug build completed - check the logs above for details" -ForegroundColor Green
    } catch {
        Write-Host "❌ Debug build also failed" -ForegroundColor Red
        Write-Host "Please check the error messages above and refer to docs/build-troubleshooting.md" -ForegroundColor Red
        exit 1
    }
}

Write-Host "=== Test Complete ===" -ForegroundColor Green
