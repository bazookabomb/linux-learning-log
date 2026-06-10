#!/usr/bin/env bash
set -e
echo "== Test: Backup =="
rm -rf testspace logs && mkdir -p testspace/src testspace/dst
echo "data" > testspace/src/a.txt
./safeCopy.sh --mode=backup --source=testspace/src --target=testspace/dst
ls testspace/dst/backup_*.tar.gz >/dev/null

echo "== Test: Restore =="
ARCH=$(ls testspace/dst/backup_*.tar.gz | tail -1)
mkdir -p testspace/restore
./safeCopy.sh --mode=restore --source="$ARCH" --target=testspace/restore
# Prüfe grob: irgendeine Datei liegt im Restore-Ziel
test -n "$(find testspace/restore -type f | head -1)"

echo "== Test: Log =="
test -s logs/backup.log
echo "Alle einfachen Tests OK ✅"


