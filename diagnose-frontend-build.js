#!/usr/bin/env node

/**
 * 前端构建环境诊断脚本
 * 用于诊断npm run build失败的原因
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('=== Frontend Build Environment Diagnostic ===');
console.log(`Timestamp: ${new Date().toISOString()}`);
console.log(`Working Directory: ${process.cwd()}`);

// 检查基本环境
console.log('\n--- Environment Check ---');
console.log(`Node.js Version: ${process.version}`);
console.log(`Platform: ${process.platform}`);
console.log(`Architecture: ${process.arch}`);

// 检查npm版本
try {
  const npmVersion = execSync('npm --version', { encoding: 'utf8' }).trim();
  console.log(`NPM Version: ${npmVersion}`);
} catch (error) {
  console.error('❌ Failed to get NPM version:', error.message);
}

// 检查package.json
console.log('\n--- Package.json Check ---');
const packagePath = path.join(process.cwd(), 'package.json');
if (fs.existsSync(packagePath)) {
  try {
    const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    console.log(`Package Name: ${pkg.name}`);
    console.log(`Package Version: ${pkg.version}`);
    console.log('Available Scripts:', Object.keys(pkg.scripts || {}));
    console.log('Dependencies count:', Object.keys(pkg.dependencies || {}).length);
    console.log('DevDependencies count:', Object.keys(pkg.devDependencies || {}).length);
  } catch (error) {
    console.error('❌ Failed to parse package.json:', error.message);
  }
} else {
  console.error('❌ package.json not found in current directory');
}

// 检查node_modules
console.log('\n--- Node Modules Check ---');
const nodeModulesPath = path.join(process.cwd(), 'node_modules');
if (fs.existsSync(nodeModulesPath)) {
  console.log('✅ node_modules directory exists');
  
  // 检查关键依赖
  const criticalDeps = ['vite', '@vitejs/plugin-vue', 'vue', 'typescript'];
  criticalDeps.forEach(dep => {
    const depPath = path.join(nodeModulesPath, dep);
    if (fs.existsSync(depPath)) {
      try {
        const depPkg = JSON.parse(fs.readFileSync(path.join(depPath, 'package.json'), 'utf8'));
        console.log(`✅ ${dep}: ${depPkg.version}`);
      } catch (error) {
        console.log(`⚠️  ${dep}: exists but version unknown`);
      }
    } else {
      console.log(`❌ ${dep}: not found`);
    }
  });
  
  // 检查可执行文件
  const binPath = path.join(nodeModulesPath, '.bin');
  if (fs.existsSync(binPath)) {
    const bins = fs.readdirSync(binPath).filter(f => !f.startsWith('.'));
    console.log(`Available binaries: ${bins.slice(0, 10).join(', ')}${bins.length > 10 ? '...' : ''}`);
  }
} else {
  console.error('❌ node_modules directory not found');
}

// 检查TypeScript配置
console.log('\n--- TypeScript Configuration ---');
const tsconfigPath = path.join(process.cwd(), 'tsconfig.json');
if (fs.existsSync(tsconfigPath)) {
  console.log('✅ tsconfig.json exists');
  try {
    const tsconfig = JSON.parse(fs.readFileSync(tsconfigPath, 'utf8'));
    console.log(`Target: ${tsconfig.compilerOptions?.target || 'not specified'}`);
    console.log(`Module: ${tsconfig.compilerOptions?.module || 'not specified'}`);
  } catch (error) {
    console.error('❌ Failed to parse tsconfig.json:', error.message);
  }
} else {
  console.log('⚠️  tsconfig.json not found');
}

// 检查Vite配置
console.log('\n--- Vite Configuration ---');
const viteConfigPath = path.join(process.cwd(), 'vite.config.ts');
if (fs.existsSync(viteConfigPath)) {
  console.log('✅ vite.config.ts exists');
  try {
    const viteConfig = fs.readFileSync(viteConfigPath, 'utf8');
    console.log('Vite config preview:');
    console.log(viteConfig.split('\n').slice(0, 10).join('\n'));
  } catch (error) {
    console.error('❌ Failed to read vite.config.ts:', error.message);
  }
} else {
  console.log('❌ vite.config.ts not found');
}

// 尝试执行构建脚本
console.log('\n--- Build Script Test ---');
try {
  console.log('Testing npm run build...');
  const buildOutput = execSync('npm run build', { 
    encoding: 'utf8', 
    timeout: 30000,
    stdio: 'pipe'
  });
  console.log('✅ Build completed successfully');
  console.log('Build output preview:', buildOutput.slice(0, 500));
} catch (error) {
  console.error('❌ Build failed:', error.message);
  if (error.stdout) {
    console.log('Build stdout:', error.stdout.slice(0, 1000));
  }
  if (error.stderr) {
    console.log('Build stderr:', error.stderr.slice(0, 1000));
  }
}

// 检查构建输出
console.log('\n--- Build Output Check ---');
const distPath = path.join(process.cwd(), 'dist');
if (fs.existsSync(distPath)) {
  console.log('✅ dist directory exists');
  const distFiles = fs.readdirSync(distPath, { recursive: true });
  console.log(`Build files: ${distFiles.length}`);
  console.log('First 10 files:', distFiles.slice(0, 10));
} else {
  console.log('⚠️  dist directory not found (build may have failed)');
}

console.log('\n=== Diagnostic Complete ===');
console.log('If you see any ❌ marks above, those are likely the causes of your build failures.');
console.log('Please fix the issues and run this script again.');
