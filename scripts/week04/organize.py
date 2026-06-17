#!/usr/bin/env python3
from pathlib import Path
import argparse, shutil

def unique_dest(path: Path):
    if not path.exists():
        return path
    stem, suf = path.stem, path.suffix
    i = 1
    while True:
        candidate = path.with_name(f"{stem}_{i}{suf}")
        if not candidate.exists():
            return candidate
        i += 1

def organize(root: Path, recursive=False, dry_run=True):
    it = root.rglob('*') if recursive else root.iterdir()
    for f in list(it):
        if f.is_file():
            rel = f.relative_to(root)
            ext = f.suffix.lower().lstrip('.') or 'noext'
            target_dir = root / ext
            if target_dir.exists() and target_dir.is_file():
                target_dir = root / (ext + "_dir")
            dest = target_dir / f.name
            dest = unique_dest(dest)
            if dry_run:
                print(f"DRY: {f} -> {dest}")
            else:
                target_dir.mkdir(parents=True, exist_ok=True)
                # vermeide Verschieben in sich selbst
                if f.resolve() == dest.resolve():
                    continue
                shutil.move(str(f), str(dest))

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("dir", nargs='?', default=".", help="Zielordner")
    p.add_argument("--apply", action="store_true", help="Änderungen tatsächlich ausführen")
    p.add_argument("--recursive", action="store_true", help="Rekursiv arbeiten")
    args = p.parse_args()
    organize(Path(args.dir), recursive=args.recursive, dry_run=not args.apply)
