# 基础版Dockerfile快速测试脚本
Write-Host "=== 测试基础版Dockerfile ===" -ForegroundColor Green

# 检查Docker是否运行
try {
    docker info | Out-Null
    Write-Host "✅ Docker正在运行" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker未运行，请先启动Docker" -ForegroundColor Red
    exit 1
}

# 测试基础版构建
Write-Host "`n=== 测试基础版构建 (Dockerfile.basic) ===" -ForegroundColor Yellow
$basicResult = docker build -f Dockerfile.basic -t test-basic . 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 基础版构建成功！" -ForegroundColor Green
    
    # 检查构建结果
    Write-Host "`n=== 检查构建结果 ===" -ForegroundColor Yellow
    docker run --rm test-basic ls -la /app/frontend/dist/ 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 前端构建产物存在" -ForegroundColor Green
    } else {
        Write-Host "⚠️  无法验证前端构建产物" -ForegroundColor Yellow
    }
    
    # 清理测试镜像
    docker rmi test-basic 2>$null | Out-Null
    Write-Host "✅ 测试镜像已清理" -ForegroundColor Green
    
} else {
    Write-Host "❌ 基础版构建失败" -ForegroundColor Red
    Write-Host "错误信息:" -ForegroundColor Red
    $basicResult | Write-Host -ForegroundColor Red
    
    Write-Host "`n=== 尝试原始版构建 ===" -ForegroundColor Yellow
    $originalResult = docker build -f dockerfile -t test-original . 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 原始版构建成功！" -ForegroundColor Green
        docker rmi test-original 2>$null | Out-Null
    } else {
        Write-Host "❌ 原始版也构建失败" -ForegroundColor Red
        Write-Host "建议检查前端代码和依赖配置" -ForegroundColor Red
    }
}

Write-Host "`n=== 测试完成 ===" -ForegroundColor Green
