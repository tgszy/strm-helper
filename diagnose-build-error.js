// 前端构建错误诊断脚本
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('=== 前端构建错误诊断 ===\n');

// 检查基本环境
console.log('1. 检查基本环境:');
try {
    console.log('   Node.js:', execSync('node --version', { encoding: 'utf8' }).trim());
    console.log('   npm:', execSync('npm --version', { encoding: 'utf8' }).trim());
} catch (error) {
    console.error('   ❌ 无法获取Node.js/npm版本');
}

// 检查前端目录
const frontendPath = path.join(__dirname, 'frontend');
if (!fs.existsSync(frontendPath)) {
    console.error('❌ 前端目录不存在:', frontendPath);
    process.exit(1);
}

// 检查关键文件
console.log('\n2. 检查关键文件:');
const requiredFiles = ['package.json', 'vite.config.ts', 'tsconfig.json'];
requiredFiles.forEach(file => {
    const filePath = path.join(frontendPath, file);
    if (fs.existsSync(filePath)) {
        console.log(`   ✅ ${file} 存在`);
    } else {
        console.log(`   ❌ ${file} 不存在`);
    }
});

// 检查src目录
const srcPath = path.join(frontendPath, 'src');
if (fs.existsSync(srcPath)) {
    console.log(`   ✅ src/ 目录存在 (${fs.readdirSync(srcPath).length} 个文件)`);
} else {
    console.log(`   ❌ src/ 目录不存在`);
}

// 尝试安装依赖
console.log('\n3. 尝试安装依赖:');
process.chdir(frontendPath);
try {
    console.log('   正在安装依赖...');
    execSync('npm install --legacy-peer-deps', { stdio: 'inherit' });
    console.log('   ✅ 依赖安装成功');
} catch (error) {
    console.error('   ❌ 依赖安装失败');
    console.error('   错误信息:', error.message);
}

// 检查关键依赖
console.log('\n4. 检查关键依赖:');
const nodeModulesPath = path.join(frontendPath, 'node_modules');
if (fs.existsSync(nodeModulesPath)) {
    const criticalDeps = ['vite', '@vitejs/plugin-vue', 'vue', 'typescript'];
    criticalDeps.forEach(dep => {
        const depPath = path.join(nodeModulesPath, dep);
        if (fs.existsSync(depPath)) {
            console.log(`   ✅ ${dep} 已安装`);
        } else {
            console.log(`   ❌ ${dep} 未安装`);
        }
    });
} else {
    console.log('   ❌ node_modules 目录不存在');
}

// 尝试运行构建
console.log('\n5. 尝试运行构建:');
try {
    console.log('   正在运行 npm run build...');
    execSync('npm run build', { stdio: 'inherit' });
    console.log('   ✅ 构建成功！');
    
    // 检查构建结果
    const distPath = path.join(frontendPath, 'dist');
    if (fs.existsSync(distPath)) {
        console.log(`   ✅ dist/ 目录已创建 (${fs.readdirSync(distPath).length} 个文件)`);
        
        // 列出主要文件
        const files = fs.readdirSync(distPath);
        files.forEach(file => {
            const filePath = path.join(distPath, file);
            const stats = fs.statSync(filePath);
            console.log(`      - ${file} (${stats.isDirectory() ? '目录' : `${Math.round(stats.size / 1024)}KB`})`);
        });
    } else {
        console.log('   ❌ dist/ 目录未创建');
    }
} catch (error) {
    console.error('   ❌ 构建失败');
    console.error('   错误信息:', error.message);
    
    // 尝试获取更详细的错误信息
    console.log('\n   尝试获取详细错误信息...');
    try {
        const result = execSync('npm run build 2>&1', { encoding: 'utf8' });
        console.log('   详细输出:', result);
    } catch (detailedError) {
        console.log('   详细错误:', detailedError.stdout || detailedError.message);
    }
}

console.log('\n=== 诊断完成 ===');

// 提供建议
console.log('\n建议:');
console.log('1. 如果依赖安装失败，尝试删除node_modules和package-lock.json后重新安装');
console.log('2. 如果构建失败，检查vite.config.ts配置是否正确');
console.log('3. 检查TypeScript代码是否有语法错误');
console.log('4. 确保所有必要的依赖都在package.json中声明');
