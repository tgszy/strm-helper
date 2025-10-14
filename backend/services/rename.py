from pathlib import Path
from typing import Dict
import yaml
from .guesser import guess_meta

def load_rules(yaml_path: Path) -> Dict:
    return yaml.safe_load(yaml_path.read_text())

def gen_target_path(strm_file: Path, rules: Dict, output_root: Path) -> Path:
    meta = guess_meta(strm_file.name)
    tpl = rules["template"][meta["type"]]
    new_name = tpl.format(**meta) + ".strm"
    folder = meta["type"]  # movie / tv
    target_dir = output_root / folder
    target_dir.mkdir(parents=True, exist_ok=True)
    return target_dir / new_name
