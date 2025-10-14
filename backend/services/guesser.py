import re
from typing import Optional, Dict

YEAR_RE = re.compile(r"\b(19|20)\d{2}\b")
RES_RE = re.compile(r"(1080p|2160p|4k|720p)", re.I)
VER_RE = re.compile(r"(v\d|repack|proper)", re.I)
TV_RE = re.compile(r"s(\d{1,2})e(\d{1,2})", re.I)

def guess_meta(filename: str) -> Dict[str, Optional[str]]:
    name = filename.replace(".strm", "")
    year = YEAR_RE.search(name)
    res = RES_RE.search(name)
    ver = VER_RE.search(name)
    tv = TV_RE.search(name)

    # 类型
    media_type = "movie"
    if any(k in name.lower() for k in ["tv", "剧集", "s01", "e01"]):
        media_type = "tv"

    # 中文名：取第一段（到括号或空格）
    cn_name = name.split("(")[0].split("[")[0].strip()

    return {
        "name": cn_name,
        "year": int(year.group()) if year else None,
        "resolution": res.group(1).lower() if res else "",
        "version": ver.group(1).lower() if ver else "",
        "type": media_type,
        "season": int(tv.group(1)) if tv else None,
        "episode": int(tv.group(2)) if tv else None,
    }
