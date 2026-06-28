#!/bin/bash

SOURCE="/home/vboxuser/"
DEST="/home/vboxuser/backups/home_backup"
LOG="/home/vboxuser/backups/backup.log"

mkdir -p "$DEST"

echo "===== $(date) =====" >> "$LOG"

rsync -avh --delete \
    --exclude=".cache/" \
    --exclude="Downloads/" \
    --exclude="backups/" \
    --exclude=".local/share/Trash/" \
    --exclude="VirtualBox VMs/" \
    "$SOURCE" "$DEST" >> "$LOG" 2>&1

echo "Backup beendet." >> "$LOG"
