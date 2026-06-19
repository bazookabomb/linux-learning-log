#!/bin/bash

set -e

# =========================
# Konfiguration
# =========================

SOURCE="$HOME"
BACKUP_ROOT="$HOME/backups"
DATE=$(date +%F_%H-%M-%S)

RSYNC_BACKUP="$BACKUP_ROOT/rsync"
TAR_BACKUP="$BACKUP_ROOT/tar"

LATEST_LINK="$RSYNC_BACKUP/latest"
SNAPSHOT_DIR="$RSYNC_BACKUP/$DATE"

LOG_FILE="$BACKUP_ROOT/backup.log"

# =========================
# Vorbereitung
# =========================

mkdir -p "$SNAPSHOT_DIR"
mkdir -p "$TAR_BACKUP"
touch "$LOG_FILE"

echo "[$DATE] Backup gestartet" >> "$LOG_FILE"

# =========================
# 1. RSYNC SNAPSHOT BACKUP
# =========================

echo "[$DATE] rsync snapshot..." >> "$LOG_FILE"

rsync -a --delete \
  --link-dest="$LATEST_LINK" \
  "$SOURCE/" \
  "$SNAPSHOT_DIR/" >> "$LOG_FILE" 2>&1

# Update latest symlink
rm -f "$LATEST_LINK"
ln -s "$SNAPSHOT_DIR" "$LATEST_LINK"

echo "[$DATE] rsync fertig" >> "$LOG_FILE"

# =========================
# 2. TAR ARCHIV (monatlich/optional)
# =========================

echo "[$DATE] tar archiv..." >> "$LOG_FILE"

tar -czf "$TAR_BACKUP/home-$DATE.tar.gz" \
  -C "$HOME" . >> "$LOG_FILE" 2>&1

# =========================
# 3. CHECKSUMME
# =========================

echo "[$DATE] checksum..." >> "$LOG_FILE"

sha256sum "$TAR_BACKUP/home-$DATE.tar.gz" \
  > "$TAR_BACKUP/home-$DATE.sha256"

# =========================
# 4. AUFRÄUMEN (Rotation)
# =========================

# behalte nur 7 rsync snapshots
cd "$RSYNC_BACKUP"
ls -1dt */ 2>/dev/null | tail -n +8 | xargs -r rm -rf

# behalte nur 5 tar archives
cd "$TAR_BACKUP"
ls -1t *.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f
ls -1t *.sha256 2>/dev/null | tail -n +6 | xargs -r rm -f

# =========================
# Ende
# =========================

echo "[$DATE] Backup fertig" >> "$LOG_FILE"

echo "Backup abgeschlossen: $DATE"
