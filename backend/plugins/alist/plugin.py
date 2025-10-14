import requests
from typing import List
from .base import SourcePlugin
from ..models.video import VideoFile

class AlistPlugin(SourcePlugin):
    def __init__(self, host: str, username: str, password: str):
        self.host = host.rstrip("/")
        self.token = self._login(username, password)

    def _login(self, u, p):
        resp = requests.post(f"{self.host}/api/auth/login", json={"username": u, "password": p})
        resp.raise_for_status()
        return resp.json()["data"]["token"]

    def list_files(self, root_path: str = "/") -> List[VideoFile]:
        url = f"{self.host}/api/fs/list"
        headers = {"Authorization": self.token}
        payload = {"path": root_path, "password": "", "page": 1, "per_page": 0}
        resp = requests.post(url, headers=headers, json=payload)
        resp.raise_for_status()
        items = resp.json()["data"]["content"]
        videos = []
        for item in items:
            if item["is_dir"]:
                continue
            if Path(item["name"]).suffix.lower() in {".mp4", ".mkv"}:
                # 获取直链
                link_resp = requests.post(f"{self.host}/api/fs/get", headers=headers,
                                          json={"path": item["path"]})
                link = link_resp.json()["data"]["raw_url"]
                videos.append(VideoFile(name=item["name"], path=item["path"],
                                        size=item["size"], url=link))
        return videos
