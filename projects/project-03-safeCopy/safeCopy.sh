#!/usr/bin/env bash
# safeCopy – super einfache Backup-Hilfe
# Ziel: Einen Ordner als .tar.gz sichern und wiederherstellen.
# Für Einsteiger: wenige Funktionen, viel Erklärung, einfache Fehlercodes.

# ---- Grund-Setup ----
set -e                               # Wenn ein Befehl scheitert, brich ab.
LOG_FILE="logs/backup.log"           # Hier schreibt das Skript rein.

# .env einlesen (optional: Standardpfade wie DEFAULT_SOURCE)
[ -f .env ] && . ./.env || true
mkdir -p logs

# ---- kleine Hilfsfunktionen ----
usage() {
  echo "Nutzung:"
  echo "  backup : $0 --mode=backup  --source=<ordner> --target=<ordner> [--prune-days=N]"
  echo "  restore: $0 --mode=restore --source=<backup.tar.gz> --target=<ordner>"
  echo "Beispiel:"
  echo "  $0 --mode=backup --source=demo/source --target=demo/backups --prune-days=7"
}

log() {  # schreibt mit Zeitstempel ins Log
  echo "$(date '+%F %T') $*" >> "$LOG_FILE"
}

# sehr einfache Argument-Auswertung: nur Form "--name=wert"
MODE="${DEFAULT_MODE:-}"
SOURCE="${DEFAULT_SOURCE:-}"
TARGET="${DEFAULT_TARGET:-}"
PRUNE_DAYS="${RETENTION_DAYS:-}"

for arg in "$@"; do
  case "$arg" in
    --mode=*)        MODE="${arg#*=}";;
    --source=*)      SOURCE="${arg#*=}";;
    --target=*)      TARGET="${arg#*=}";;
    --prune-days=*)  PRUNE_DAYS="${arg#*=}";;
    -h|--help)       usage; exit 0;;
    *) echo "Unbekanntes Argument: $arg"; usage; exit 1;;
  esac
done

# Wenn etwas fehlt, freundlich nachfragen (sehr einsteigerfreundlich)
if [ -z "$MODE" ]; then
  read -rp "Modus (backup/restore): " MODE
fi
if [ -z "$SOURCE" ]; then
  read -rp "Quelle (Ordner bei backup, .tar.gz bei restore): " SOURCE
fi
if [ -z "$TARGET" ]; then
  read -rp "Ziel (Ordner für Backups oder Entpackziel): " TARGET
fi

# ---- einfache Prüfungen ----
[ -d "$TARGET" ] || mkdir -p "$TARGET"

check_space() {
  # Prüft: ist genug Platz für das Backup da?
  # Größe der Quelle (Bytes):
  local SRC_BYTES
  SRC_BYTES=$(du -sb --apparent-size "$SOURCE" | cut -f1)
  # Freier Platz am Ziel (Bytes):
  local AVAIL
  AVAIL=$(df -B1 --output=avail "$TARGET" | tail -1 | tr -d ' ')
  # kleiner Puffer von 10 MiB:
  local NEED=$((SRC_BYTES + 10*1024*1024))
  if [ "$AVAIL" -lt "$NEED" ]; then
    echo "Zu wenig Speicher (brauche ~$NEED, habe $AVAIL)."
    log "ERROR: Zu wenig Speicher - need=$NEED avail=$AVAIL"
    exit 2
  fi
}

backup() {
  if [ ! -d "$SOURCE" ]; then
    echo "Quellordner nicht gefunden: $SOURCE"; log "ERROR fehlende Quelle"; exit 3
  fi
  check_space
  local STAMP OUT
  STAMP=$(date '+%F_%H-%M-%S')
  OUT="$TARGET/backup_${STAMP}.tar.gz"
  echo "Sichere $SOURCE -> $OUT ..."
  log "INFO Backup start $SOURCE -> $OUT"
  tar -czf "$OUT" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"
  # Mini-Check: Archiv lesbar?
  tar -tzf "$OUT" > /dev/null
  echo "Fertig: $OUT"
  log "INFO Backup ok $OUT"

  # Alte Backups löschen? (optional)
  if [ -n "$PRUNE_DAYS" ]; then
    echo "Entferne Backups älter als $PRUNE_DAYS Tage in $TARGET ..."
    find "$TARGET" -maxdepth 1 -type f -name "backup_*.tar.gz" -mtime +"$PRUNE_DAYS" -print -delete || true
  fi
}

restore() {
  if [ ! -f "$SOURCE" ]; then
    echo "Archiv nicht gefunden: $SOURCE"; log "ERROR fehlendes Archiv"; exit 3
  fi
  echo "Stelle wieder her: $SOURCE -> $TARGET ..."
  log "INFO Restore start $SOURCE -> $TARGET"
  tar -tzf "$SOURCE" > /dev/null || { echo "Archiv ungültig."; log "ERROR Archiv ungültig"; exit 6; }
  tar -xzf "$SOURCE" -C "$TARGET"
  echo "Restore abgeschlossen in: $TARGET"
  log "INFO Restore ok $TARGET"
}

# ---- los geht's ----
case "$MODE" in
  backup)  backup ;;
  restore) restore ;;
  *) echo "Ungültiger Modus: $MODE"; usage; exit 5;;
esac
