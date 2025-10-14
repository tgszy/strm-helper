import shutil
from pathlib import Path
from typing import Dict
from .scanner import scan_strm
from .rename import gen_target_path, load_rules

def organize(source_strm_root: Path, output_root: Path, rules_yaml: Path):
    rules: Dict = load_rules(rules_yaml)
    for strm in scan_strm(source_strm_root):
        target = gen_target_path(strm, rules, output_root)
        shutil.move(strm, target)
        print(f"📦 {strm} → {target}")
