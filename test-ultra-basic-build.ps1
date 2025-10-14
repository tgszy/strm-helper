# 超基础版Dockerfile快速测试脚本
# 用于本地验证超基础版Dockerfile是否能正常工作

Write-Host "=== 超基础版Dockerfile测试 ===" -ForegroundColor Green

# 检查Docker是否运行
try {
    docker info | Out-Null
    Write-Host "✅ Docker正在运行" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker未运行，请先启动Docker" -ForegroundColor Red
    exit 1
}

# 设置测试参数
$imageName = "strm-helper-ultra-basic-test"
$testContainer = "strm-helper-ultra-basic-container"

# 清理之前的测试
try {
    docker rm -f $testContainer 2>$null
    docker rmi -f $imageName 2>$null
    Write-Host "✅ 清理之前的测试镜像" -ForegroundColor Green
} catch {
    # 忽略清理错误
}

# 构建测试镜像
Write-Host "`n🚀 开始构建超基础版镜像..." -ForegroundColor Yellow
try {
    docker build -f Dockerfile.ultra-basic -t $imageName .
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 超基础版镜像构建成功！" -ForegroundColor Green
    } else {
        throw "构建失败"
    }
} catch {
    Write-Host "❌ 超基础版镜像构建失败" -ForegroundColor Red
    Write-Host "错误信息: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试容器运行
Write-Host "`n🧪 测试容器运行..." -ForegroundColor Yellow
try {
    docker run -d --name $testContainer -p 35455:35455 $imageName
    Start-Sleep -Seconds 3
    
    # 检查容器状态
    $containerStatus = docker inspect -f '{{.State.Status}}' $testContainer
    if ($containerStatus -eq "running") {
        Write-Host "✅ 容器运行正常" -ForegroundColor Green
        
        # 检查端口
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:35455" -TimeoutSec 5 -ErrorAction Stop
            Write-Host "✅ 应用响应正常 (HTTP $($response.StatusCode))" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  应用可能还在启动中，或端口未响应" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ 容器未运行，状态: $containerStatus" -ForegroundColor Red
        
        # 显示日志
        Write-Host "`n容器日志:" -ForegroundColor Yellow
        docker logs $testContainer
    }
} catch {
    Write-Host "❌ 容器测试失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 清理测试容器
Write-Host "`n🧹 清理测试容器..." -ForegroundColor Yellow
try {
    docker rm -f $testContainer 2>$null
    Write-Host "✅ 测试容器已清理" -ForegroundColor Green
} catch {
    Write-Host "⚠️  清理测试容器时出错" -ForegroundColor Yellow
}

# 显示构建结果摘要
Write-Host "`n=== 测试结果摘要 ===" -ForegroundColor Green
Write-Host "超基础版Dockerfile测试完成" -ForegroundColor White
Write-Host "镜像名称: $imageName" -ForegroundColor Gray
Write-Host "测试容器: $testContainer" -ForegroundColor Gray

# 提供下一步建议
Write-Host "`n建议:" -ForegroundColor Yellow
Write-Host "1. 如果构建成功，可以推送到GitHub测试GitHub Actions" -ForegroundColor White
Write-Host "2. 如果构建失败，检查前端代码是否有语法错误" -ForegroundColor White
Write-Host "3. 可以尝试基础版Dockerfile作为备选方案" -ForegroundColor White

Write-Host "`n=== 测试完成 ===" -ForegroundColor Green
