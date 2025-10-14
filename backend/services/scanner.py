from pathlib import Path
from typing import List

STRM_EXT = ".strm"

def scan_strm(root: Path) -> List[Path]:
    return [p for p in root.rglob(f"*{STRM_EXT}") if p.is_file()]
