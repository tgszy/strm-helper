# STRM Helper

一个现代化的媒体库管理工具，支持多源STRM文件生成、智能分类整理和Web界面管理。

## 📖 项目介绍

STRM Helper 是一个专为媒体库设计的自动化管理工具，主要解决以下问题：

- **多源媒体文件整合**：支持本地文件、Alist网盘、115网盘等多种数据源
- **智能STRM文件生成**：自动生成可供Emby、Jellyfin等媒体服务器使用的STRM文件
- **自动化分类整理**：基于TMDB元数据智能识别电影、电视剧，自动分类归档
- **Web可视化操作**：提供现代化的Web界面，支持批量操作和任务监控
- **插件化架构**：支持自定义数据源插件，易于扩展新的媒体源

### 🎯 适用场景

- 拥有大量分散在不同位置的媒体文件需要统一管理
- 希望通过STRM文件方式让媒体服务器访问远程资源
- 需要自动化整理和分类媒体库
- 希望通过Web界面管理整个媒体库整理流程
- 开发者希望集成媒体库管理功能到自己的系统中

## 🌟 功能特性

### 核心功能
- **多源STRM生成**：支持本地目录、Alist、115网盘等多种数据源
- **智能分类整理**：基于TMDB元数据自动识别、重命名和分类
- **离线处理**：无需访问实体文件，仅处理文件路径和元数据
- **插件化架构**：可扩展的插件系统，支持自定义数据源

### Web管理界面
- **Vue3 + Element Plus**：现代化的响应式Web界面
- **实时任务监控**：WebSocket实时推送任务进度
- **批量操作**：支持批量生成、整理和分类操作
- **配置管理**：可视化配置数据源和分类规则

### API接口
- **RESTful API**：完整的HTTP API接口支持
- **WebSocket**：实时通信支持
- **CORS跨域**：支持前后端分离部署
- **健康检查**：服务状态监控接口

## 🚀 快速开始

### Docker Compose 安装（推荐）

```bash
# 克隆项目
git clone https://github.com/your-username/strm-helper.git
cd strm-helper

# 创建必要的目录
mkdir -p data media strm

# 启动服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 访问服务
# API文档: http://localhost:35455/docs
# 任务监控: http://localhost:5555 (Flower)

# 查看日志
docker-compose logs -f strm-api
docker-compose logs -f worker
```

### 前端开发环境（可选）

如果你想在开发环境中使用前端界面：

```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 访问前端界面
# Web界面: http://localhost:5173
```

### Docker 单独安装

```bash
# 拉取镜像
docker pull tgszy/strm-helper:latest

# 运行容器
docker run -d \
  --name strm-helper \
  -p 35455:35455 \
  -v /path/to/your/data:/data \
  -v /path/to/your/media:/media \
  -v /path/to/your/strm:/strm \
  tgszy/strm-helper:latest
```

### Docker 镜像构建

如果你想自己构建Docker镜像：

```bash
# 构建amd64架构的镜像（推荐）
docker build -t strm-helper .

# 或者使用buildx构建多平台镜像
docker buildx build --platform linux/amd64 -t strm-helper .
```

**注意**：由于前端构建依赖，建议使用amd64架构构建。如果你遇到npm相关错误，请确保：
1. 前端目录包含完整的package.json文件
2. 网络连接正常，能够访问npm镜像源
3. 使用推荐的Node.js 18版本进行构建

### 本地开发安装

```bash
# 1. 安装后端依赖
pip install -e .

# 2. 安装前端依赖
cd frontend && npm install

# 3. 启动后端服务
python -m backend.main

# 4. 启动前端开发服务器
npm run dev
```

## 📋 使用说明

### 1. 生成本地STRM文件
```bash
# 使用CLI命令
strm gen --source-type local --source-config configs/local.json --output /tmp/strm

# 或使用Web界面
# 访问 http://localhost:5173 -> 选择"整理" -> 配置数据源 -> 开始生成
```

### 2. 智能分类整理
```bash
# 使用CLI命令
strm organize --strm-root /tmp/strm --output ~/StrmOrg --rules rules/classify.yaml

# 或使用Web界面批量操作
```

### 3. 配置数据源
编辑 `configs/` 目录下的JSON配置文件：
- `local.json` - 本地目录配置
- `alist.json` - Alist网盘配置
- `115.json` - 115网盘配置

## 🔌 API接口文档

服务启动后，可以访问以下接口：

### 基础接口
- `GET /` - 服务根路径，返回欢迎信息
- `GET /health` - 健康检查接口
- `GET /api/info` - API信息接口
- `GET /docs` - Swagger API文档
- `GET /redoc` - ReDoc API文档

### 媒体管理接口
- `GET /api/media` - 获取媒体列表
- `POST /api/organize` - 执行整理任务
- `GET /api/settings` - 获取配置信息
- `PUT /api/settings` - 更新配置信息

### 🎯 可以访问的端点
现在你的应用提供以下接口：

1.API 文档 ： http://localhost:35455/docs

2.替代文档 ： http://localhost:35455/redoc

3.健康检查 ： http://localhost:35455/health

4.API 信息 ： http://localhost:35455/api/info

5.根路径 ： http://localhost:35455/

### WebSocket接口
- `ws://localhost:35455/api/ws` - 实时任务进度推送

## 📁 目录结构

```
strm-helper/
├── backend/          # FastAPI后端代码
│   ├── api/         # API路由
│   ├── celery_app/  # 异步任务队列
│   ├── core/        # 核心功能
│   ├── models/      # 数据模型
│   ├── plugins/     # 插件系统
│   └── services/    # 业务逻辑
├── frontend/        # Vue3前端代码
│   ├── src/         # 源代码
│   └── package.json # 前端依赖
├── configs/         # 数据源配置文件
├── docker-compose.yml
├── dockerfile
└── requirements.txt
```

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                    Web 前端 (Vue3 + Element Plus)            │
│                    http://localhost:5173                    │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  API 网关 (FastAPI)                         │
│                  http://localhost:35455                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐         │
│  │   REST API  │ │  WebSocket  │ │   健康检查  │         │
│  └─────────────┘ └─────────────┘ └─────────────┘         │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  业务逻辑层                                │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐         │
│  │   扫描器    │ │   整理器    │ │   重命名器  │         │
│  └─────────────┘ └─────────────┘ └─────────────┘         │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  插件系统                                    │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐         │
│  │   本地插件  │ │  Alist插件  │ │  115网盘插件 │         │
│  └─────────────┘ └─────────────┘ └─────────────┘         │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                  异步任务队列 (Celery + Redis)              │
│                  任务监控 (Flower)                        │
└─────────────────────────────────────────────────────────────┘
```

## ⚙️ 环境变量

### 后端环境变量
- `REDIS_URL` - Redis连接地址 (默认: redis://localhost:6379)
- `CELERY_BROKER_URL` - Celery消息队列地址

### 前端环境变量
- `VITE_API_BASE` - API基础地址 (默认: http://localhost:35455/api)

## 🔧 开发指南

### 添加新的数据源插件
1. 在 `backend/plugins/` 目录创建新的插件文件
2. 继承 `SourcePlugin` 基类
3. 实现 `list_files` 方法
4. 在配置文件中添加插件配置

### 前端开发
```bash
cd frontend
npm run dev      # 启动开发服务器
npm run build    # 构建生产版本
npm run preview  # 预览构建结果
```

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 🆘 支持

如有问题，请在 GitHub Issues 中提问或联系维护者。

## ✅ 快速验证

安装完成后，可以通过以下方式验证服务是否正常运行：

### 1. 检查容器状态
```bash
docker-compose ps
# 应该看到所有服务都是 Up 状态
```

### 2. 测试API接口
```bash
# 测试健康检查
curl http://localhost:35455/health
# 应该返回: {"status":"ok"}

# 测试API信息
curl http://localhost:35455/api/info
# 应该返回API版本和功能信息
```

### 3. 访问Web界面
- 打开浏览器访问 http://localhost:5173
- 应该能看到STRM Helper的Web管理界面

### 4. 查看日志
```bash
# 查看后端日志
docker-compose logs strm-api

# 查看前端日志
docker-compose logs frontend

# 查看工作进程日志
docker-compose logs worker
```

如果以上检查都正常，说明STRM Helper已经成功安装并可以正常使用了！

## 🔗 相关链接

- [FastAPI 文档](https://fastapi.tiangolo.com/)
- [Vue3 文档](https://v3.vuejs.org/)
- [Element Plus 文档](https://element-plus.org/)
- [Celery 文档](https://docs.celeryproject.org/)
- [Docker 文档](https://docs.docker.com/)
