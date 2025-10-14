from pathlib import Path
import shutil
from .scanner import scan_strm
from .rename import gen_target_path

def organize(source_strm_root: Path, output_root: Path, rules_yaml: Path):
    rules = load_rules(rules_yaml)
    for strm in scan_strm(source_strm_root):
        target = gen_target_path(strm, rules, output_root)
        shutil.move(strm, target)
        print(f"📦 {strm} → {target}")
