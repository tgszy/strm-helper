#!/bin/bash
# 测试前端构建脚本

echo "🔧 测试前端构建..."

# 进入前端目录
cd frontend

# 清理旧的node_modules
echo "🧹 清理旧的依赖..."
rm -rf node_modules package-lock.json

# 安装依赖
echo "📦 安装依赖..."
npm install --legacy-peer-deps

# 检查是否可以构建
echo "🏗️  测试构建..."
npm run build

# 检查结果
if [ $? -eq 0 ]; then
    echo "✅ 前端构建成功！"
    echo "📊 构建信息："
    ls -la dist/ 2>/dev/null || echo "dist目录不存在"
else
    echo "❌ 前端构建失败！"
    exit 1
fi

echo "🎉 测试完成！"
