
# 构建故障排除指南

本文档提供了STRM Helper项目构建失败的详细故障排除步骤，特别是针对前端npm run build失败的问题。

## 常见错误

### 1. npm run build 失败

**错误症状：**
```
ERROR: failed to build: failed to solve: process "/bin/sh -c npm run build ..." did not complete successfully: exit code: 1
```

**可能原因和解决方案：**

#### A. 依赖安装问题

1. **检查依赖安装**
   ```bash
   # 在Dockerfile中验证依赖安装
   RUN npm install --legacy-peer-deps && \
       npm list vite @vitejs/plugin-vue vue typescript --depth=0
   ```

2. **使用国内镜像源**
   ```dockerfile
   RUN npm config set registry https://registry.npmmirror.com
   ```

#### B. 构建工具缺失

确保安装了必要的构建工具：
```dockerfile
RUN apk add --no-cache python3 make g++ git
```

#### C. 环境验证

在构建前验证环境：
```dockerfile
RUN echo "Environment check:" && \
    node --version && \
    npm --version && \
    ls -la src/ && \
    test -f tsconfig.json && echo "✅ tsconfig.json exists" || echo "⚠️  tsconfig.json missing"
```

## 构建策略

### 主要构建流程

1. **依赖安装和验证**
   ```dockerfile
   COPY frontend/package*.json ./
   RUN npm install --legacy-peer-deps && \
       npm list vite @vitejs/plugin-vue vue typescript --depth=0
   ```

2. **源代码复制和验证**
   ```dockerfile
   COPY frontend/ ./
   RUN echo "Validating source code..." && \
       ls -la src/ && \
       test -f tsconfig.json && echo "✅ tsconfig.json exists" || echo "⚠️  tsconfig.json missing"
   ```

3. **构建执行**
   ```dockerfile
   RUN npm run build && \
       echo "✅ Build completed successfully" && \
       ls -la dist/
   ```

### 备用构建策略

如果主要构建失败，使用备用策略：

```dockerfile
RUN npm run build || \
    (echo "❌ Primary build failed, trying fallback..." && \
     npx vite build && \
     echo "✅ Fallback build completed" && \
     ls -la dist/) || \
    (echo "❌ Both builds failed, providing diagnostics..." && \
     echo "Node version: $(node --version)" && \
     echo "NPM version: $(npm --version)" && \
     echo "Available scripts: $(npm run | grep -E '^  (build|dev)')" && \
     exit 1)
```

## GitHub Actions 配置

### 构建重试机制

在GitHub Actions工作流中添加重试机制：

```yaml
- name: Build and push Docker image
  id: docker_build
  uses: docker/build-push-action@v5
  with:
    context: .
    file: ./Dockerfile
    platforms: linux/amd64
    push: true
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
    cache-from: type=gha
    cache-to: type=gha,mode=max
    build-args: |
      NODE_ENV=production
    provenance: false
    timeout: 20m
  continue-on-error: true

- name: Retry build with clean cache
  if: steps.docker_build.outcome == 'failure'
  uses: docker/build-push-action@v5
  with:
    context: .
    file: ./Dockerfile
    platforms: linux/amd64
    push: true
    tags: ${{ steps.meta.outputs.tags }}
    labels: ${{ steps.meta.outputs.labels }}
    no-cache: true  # 不使用缓存，完全重新构建
    build-args: |
      NODE_ENV=production
    provenance: false
    timeout: 25m
```

## 本地测试

### 使用测试脚本

我们提供了测试脚本来本地验证构建：

**Linux/Mac:**
```bash
chmod +x test-docker-build.sh
./test-docker-build.sh
```

**Windows (PowerShell):**
```powershell
.\test-docker-build.ps1
```

### 手动测试

1. **测试简化版Dockerfile:**
   ```bash
   docker build -f Dockerfile.test -t strm-helper-test:simplified .
   ```

2. **测试生产版（仅前端）:**
   ```bash
   docker build --target frontend-builder -t strm-helper-test:frontend .
   ```

3. **测试完整构建:**
   ```bash
   docker build -t strm-helper-test:full .
   ```

## 诊断工具

### 前端构建诊断脚本

使用提供的诊断脚本来检查前端环境：

```bash
node diagnose-frontend-build.js
```

这个脚本会检查：
- Node.js和npm版本
- package.json配置
- 依赖安装状态
- TypeScript配置
- Vite配置
- 构建过程测试

## 常见问题解决

### 1. 依赖冲突

如果遇到依赖冲突：
```bash
npm install --legacy-peer-deps
```

### 2. 网络问题

使用国内镜像源：
```bash
npm config set registry https://registry.npmmirror.com
```

### 3. 内存不足

在Docker构建时增加内存限制：
```bash
docker build --memory=4g --memory-swap=4g -t your-image .
```

### 4. 权限问题

确保文件权限正确：
```bash
chmod -R 755 frontend/
```

## 版本号规范

确保GitHub Release标签使用正确的版本号格式：

**有效格式：**
- `1.0.0`
- `1.2.3`
- `2.0.0-beta.1`

**无效格式：**
- `v1.0.0.14` (四段式版本号)
- `1.0` (缺少补丁版本)

**可接受格式：**
- `v1.0.0` (带v前缀)

参考文档：[版本号规范](versioning.md)

## 获取帮助

如果以上步骤都无法解决问题：

1. 检查GitHub Actions的详细日志
2. 使用诊断脚本收集环境信息
3. 在GitHub Issues中报告问题，包含：
   - 完整的错误日志
   - 使用的Dockerfile版本
   - 诊断脚本的输出结果
   - 相关的环境信息
