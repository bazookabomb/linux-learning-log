#!/usr/bin/env python3
from pathlib import Path
import argparse, shutil

def organize(dirpath: Path, dry_run=True):
    for f in dirpath.iterdir():
        if f.is_file():
            ext = f.suffix.lower().lstrip('.') or 'noext'
            target = dirpath / ext
            # Falls ein gleichnamiges File existiert, benutze einen Alternativ-Ordner
            if target.exists() and target.is_file():
                target = dirpath / (ext + "_dir")
            target.mkdir(exist_ok=True)
            dest = target / f.name
            if dry_run:
                print(f"DRY: {f} -> {dest}")
            else:
                shutil.move(str(f), str(dest))

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("dir", nargs='?', default=".", help="Zielordner")
    p.add_argument("--apply", action="store_true", help="Änderungen tatsächlich ausführen")
    args = p.parse_args()
    organize(Path(args.dir), dry_run=not args.apply)
