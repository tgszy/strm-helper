import argparse
import json
from backend.plugins.local import LocalDirPlugin
from backend.plugins.alist import AlistPlugin
from backend.plugins.115 import115CookiePlugin
from backend.core.strm_gen import gen_strm

PLUGINS = {
    "local": LocalDirPlugin,
    "alist": AlistPlugin,
    "115":115CookiePlugin,
}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-type", choices=PLUGINS.keys(), required=True)
    parser.add_argument("--source-config", help="json 文件路径", required=True)
    parser.add_argument("--output", required=True, help="本地保存 STRM 根目录")
    args = parser.parse_args()

    config = json.load(open(args.source_config))
    plugin_cls = PLUGINS[args.source_type]
    plugin = plugin_cls(**config)          # 实例化插件

    videos = plugin.list_files()           # 拿文件列表
    gen_strm(videos, output_root=args.output)  # 统一生成 STRM
    print(f"✅ 完成，共生成 {len(videos)} 个 STRM")

if __name__ == "__main__":
    main()
