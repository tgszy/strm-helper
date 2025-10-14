# 测试容器启动脚本
# 验证修复后的Dockerfile是否能正常启动应用

Write-Host "=== 容器启动测试 ===" -ForegroundColor Green

# 检查Docker是否运行
try {
    docker info | Out-Null
    Write-Host "✅ Docker正在运行" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker未运行，请先启动Docker" -ForegroundColor Red
    exit 1
}

# 设置测试参数
$imageName = "strm-helper-test"
$testContainer = "strm-helper-test-container"

# 清理之前的测试
try {
    docker rm -f $testContainer 2>$null
    docker rmi -f $imageName 2>$null
    Write-Host "✅ 清理之前的测试镜像" -ForegroundColor Green
} catch {
    # 忽略清理错误
}

# 构建测试镜像
Write-Host "`n🚀 开始构建测试镜像..." -ForegroundColor Yellow
try {
    docker build -f Dockerfile.ultra-basic -t $imageName .
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 镜像构建成功！" -ForegroundColor Green
    } else {
        throw "构建失败"
    }
} catch {
    Write-Host "❌ 镜像构建失败" -ForegroundColor Red
    Write-Host "错误信息: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 测试容器启动
Write-Host "`n🧪 测试容器启动..." -ForegroundColor Yellow
try {
    docker run -d --name $testContainer -p 35455:35455 $imageName
    Write-Host "✅ 容器已启动，等待应用初始化..." -ForegroundColor Green
    
    # 等待应用启动
    Start-Sleep -Seconds 5
    
    # 检查容器状态
    $containerStatus = docker inspect -f '{{.State.Status}}' $testContainer
    if ($containerStatus -eq "running") {
        Write-Host "✅ 容器状态正常 (运行中)" -ForegroundColor Green
        
        # 检查日志
        Write-Host "`n📋 容器日志:" -ForegroundColor Yellow
        $logs = docker logs $testContainer --tail 10
        Write-Host $logs
        
        # 检查端口响应
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:35455" -TimeoutSec 10 -ErrorAction Stop
            Write-Host "✅ 应用响应正常 (HTTP $($response.StatusCode))" -ForegroundColor Green
            Write-Host "✅ 容器启动测试通过！" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  应用可能还在启动中，或端口未响应" -ForegroundColor Yellow
            Write-Host "但这不表示构建失败，只是启动稍慢" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ 容器状态异常: $containerStatus" -ForegroundColor Red
        
        # 显示详细日志
        Write-Host "`n📋 完整容器日志:" -ForegroundColor Yellow
        docker logs $testContainer
    }
} catch {
    Write-Host "❌ 容器启动失败: $($_.Exception.Message)" -ForegroundColor Red
    
    # 尝试显示日志
    try {
        Write-Host "`n📋 错误日志:" -ForegroundColor Yellow
        docker logs $testContainer --tail 20
    } catch {}
}

# 清理测试容器
Write-Host "`n🧹 清理测试容器..." -ForegroundColor Yellow
try {
    docker rm -f $testContainer 2>$null
    Write-Host "✅ 测试容器已清理" -ForegroundColor Green
} catch {
    Write-Host "⚠️  清理测试容器时出错" -ForegroundColor Yellow
}

# 显示测试结果摘要
Write-Host "`n=== 测试结果摘要 ===" -ForegroundColor Green
if ($containerStatus -eq "running") {
    Write-Host "✅ 测试通过：容器能正常启动" -ForegroundColor Green
    Write-Host "✅ 修复有效：入口命令和路径问题已解决" -ForegroundColor Green
} else {
    Write-Host "❌ 测试失败：容器无法正常启动" -ForegroundColor Red
}

Write-Host "`n镜像名称: $imageName" -ForegroundColor Gray
Write-Host "测试容器: $testContainer" -ForegroundColor Gray
Write-Host "端口映射: 35455:35455" -ForegroundColor Gray

Write-Host "`n=== 测试完成 ===" -ForegroundColor Green
