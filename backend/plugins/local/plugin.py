from pathlib import Path
from typing import List
from backend.plugins.base import SourcePlugin
from backend.models.video import VideoFile

VIDEO_EXTS = {".mp4", ".mkv", ".avi", ".ts", ".mov"}

class LocalDirPlugin(SourcePlugin):
    def __init__(self, base_path: str):
        self.base = Path(base_path).expanduser().resolve()

    def list_files(self, root_path: str = "") -> List[VideoFile]:
        scan = self.base / root_path if root_path else self.base
        return [
            VideoFile(name=f.name, path=str(f.relative_to(self.base)),
                      size=f.stat().st_size, url=f"file://{f.resolve()}")
            for f in scan.rglob("*") if f.suffix.lower() in VIDEO_EXTS
        ]
