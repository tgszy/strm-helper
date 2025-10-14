import requests
from typing import List
from .base import SourcePlugin
from ..models.video import VideoFile

class115CookiePlugin(SourcePlugin):
    def __init__(self, cookie: str):
        self.s = requests.Session()
        self.s.headers.update({"Cookie": cookie, "User-Agent": "Mozilla/5.0"})

    def list_files(self, root_path: str = "0") -> List[VideoFile]:
        # 115 目录接口 /web/api/file/list
        url = "https://webapi.115.com/files"
        params = {"aid": 1, "cid": root_path, "o": "user_utime", "asc": 0,
                  "offset": 0, "limit": 1000, "format": "json"}
        resp = self.s.get(url, params=params)
        resp.raise_for_status()
        data = resp.json()
        if data["errno"] != 0:
            raise RuntimeError(data["error"])
        videos = []
        for item in data["data"]:
            if item.get("ico") == "video":
                # 取直链
                down_url = self._pick_url(item["pc"])
                videos.append(VideoFile(name=item["n"], path=item["fid"],
                                        size=int(item["s"]), url=down_url))
        return videos

    def _pick_url(self, pickcode: str) -> str:
        # 简单版：/files/download 接口
        r = self.s.get("https://proapi.115.com/app/chrome/downurl",
                       params={"pickcode": pickcode})
        return list(r.json()["data"].values())[0]["url"]["url"]
