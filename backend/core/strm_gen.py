from pathlib import Path
from typing import List
from backend.models.video import VideoFile

def gen_strm(videos: List[VideoFile], output_root: Path, overwrite: bool = False):
    output_root = Path(output_root)
    output_root.mkdir(parents=True, exist_ok=True)
    for v in videos:
        target = output_root / f"{v.name}.strm"
        if target.exists() and not overwrite:
            continue
        target.write_text(v.url or f"file://{v.path}", encoding="utf-8")
        print(f"[+] {target}")
