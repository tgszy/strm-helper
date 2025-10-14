## M2 功能
- 多源生成 STRM：本地 / Alist / 115
- 统一 CLI：`strm gen` / `strm organize`
- 离线识别 + 重命名 + 分类（不访问实体文件）

## 快速体验
```bash
# 1. 安装
pip install -e .

# 2. 生成本地 STRM
strm gen --source-type local --source-config configs/local.json --output /tmp/strm

# 3. 整理 + 分类
strm organize --strm-root /tmp/strm --output ~/StrmOrg --rules rules/classify.yaml
