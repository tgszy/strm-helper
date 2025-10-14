#!/usr/bin/env python3
"""
STRM Helper CLI
统一入口：生成 或 整理
"""
import argparse
import json
from pathlib import Path
from backend.plugins.local import LocalDirPlugin
from backend.plugins.alist import AlistPlugin
from backend.plugins.115 import Cookie115Plugin
from backend.services.organize import organize

PLUGIN_MAP = {
    "local": LocalDirPlugin,
    "alist": AlistPlugin,
    "115": Cookie115Plugin,
}

def cmd_gen(args):
    config = json.loads(Path(args.source_config).read_text())
    plugin_cls = PLUGIN_MAP[args.source_type]
    plugin = plugin_cls(**config)
    videos = plugin.list_files(args.root_path)
    from backend.core.strm_gen import gen_strm
    gen_strm(videos, args.output, args.overwrite)

def cmd_organize(args):
    organize(
        source_strm_root=Path(args.strm_root),
        output_root=Path(args.output),
        rules_yaml=Path(args.rules),
    )

def main():
    parser = argparse.ArgumentParser(prog="strm")
    sub = parser.add_subparsers(dest="command", required=True)

    # 1. 生成 STRM
    p1 = sub.add_parser("gen", help="生成 STRM")
    p1.add_argument("--source-type", choices=PLUGIN_MAP.keys(), required=True)
    p1.add_argument("--source-config", required=True, help="json 配置文件")
    p1.add_argument("--root-path", default="", help="插件内起始路径")
    p1.add_argument("--output", required=True, help="STRM 输出根目录")
    p1.add_argument("--overwrite", action="store_true")
    p1.set_defaults(func=cmd_gen)

    # 2. 整理 STRM
    p2 = sub.add_parser("organize", help="整理 STRM")
    p2.add_argument("--strm-root", required=True, help="已有 STRM 目录")
    p2.add_argument("--output", required=True, help="整理后根目录")
    p2.add_argument("--rules", default="rules/classify.yaml", help="分类规则")
    p2.set_defaults(func=cmd_organize)

    args = parser.parse_args()
    args.func(args)

if __name__ == "__main__":
    main()
