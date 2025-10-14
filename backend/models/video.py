from pydantic import BaseModel

class VideoFile(BaseModel):
    name: str
    path: str
    size: int = 0
    url: str = ""
