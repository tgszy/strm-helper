# STRM Helper

一个现代化的媒体库管理工具，支持多源STRM文件生成、智能分类整理和Web界面管理。

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

# 启动服务
docker-compose up -d

# 访问服务
# Web界面: http://localhost:5173
# API文档: http://localhost:35455/docs
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

### WebSocket接口
- `ws://localhost:35455/api/ws` - 实时任务进度推送

### 🎯 可以访问的端点
现在你的应用提供以下接口：

1.API 文档 ： http://localhost:35455/docs

2.替代文档 ： http://localhost:35455/redoc

3.健康检查 ： http://localhost:35455/health

4.API 信息 ： http://localhost:35455/api/info

5.根路径 ： http://localhost:35455/


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
