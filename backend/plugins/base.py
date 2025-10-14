from abc import ABC, abstractmethod
from typing import List
from backend.models.video import VideoFile

class SourcePlugin(ABC):
    @abstractmethod
    def list_files(self, root_path: str = "") -> List[VideoFile]:
        """返回统一格式的视频文件列表"""
        raise NotImplementedError
