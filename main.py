#!/usr/bin/env python3
"""
STRM Helper M1
最简 STRM 生成器
python main.py --scan /media --output /strm
"""
import argparse
import os
from pathlib import Path

VIDEO_EXTS = {".mp4", ".mkv", ".avi", ".mov", ".ts"}

def ensure_output(output: Path) -> None:
    output.mkdir(parents=True, exist_ok=True)

def make_strm(video: Path, output_root: Path, overwrite: bool) -> Path:
    """生成 .strm 文件，内容为本地绝对路径"""
    rel_dir = video.parent.relative_to("/")      # 保留原目录结构
    target_dir = output_root / rel_dir
    target_dir.mkdir(parents=True, exist_ok=True)

    strm_path = target_dir / f"{video.stem}.strm"
    if strm_path.exists() and not overwrite:
        return strm_path          # 跳过已存在

    strm_path.write_text(f"file://{video.resolve()}", encoding="utf-8")
    return strm_path

def scan_and_create(scan_root: Path, output_root: Path, overwrite: bool):
    for ext in VIDEO_EXTS:
        for video in scan_root.rglob(f"*{ext}"):
            strm = make_strm(video, output_root, overwrite)
            print(f"[+]{strm}")

def main():
    parser = argparse.ArgumentParser(description="STRM Helper M1")
    parser.add_argument("--scan", required=True, help="媒体根目录")
    parser.add_argument("--output", required=True, help="STRM 输出根目录")
    parser.add_argument("--overwrite", action="store_true", help="覆盖已存在")
    args = parser.parse_args()

    scan_root = Path(args.scan).expanduser().resolve()
    output_root = Path(args.output).expanduser().resolve()

    if not scan_root.is_dir():
        print(f"❌ 扫描目录不存在: {scan_root}")
        return

    ensure_output(output_root)
    scan_and_create(scan_root, output_root, args.overwrite)
    print("✅ 全部完成！")

if __name__ == "__main__":
    main()
