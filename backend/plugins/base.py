from abc import ABC, abstractmethod
from typing import List
from backend.models.video import VideoFile

class SourcePlugin(ABC):
    @abstractmethod
    def list_files(self, root_path: str = "") -> List[VideoFile]:
        raise NotImplementedError
