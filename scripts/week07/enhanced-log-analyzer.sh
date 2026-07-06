#!/bin/bash

set -euo pipefail

PROG_NAME="Linux Log Analyzer"
PROG_VERSION="1.2"

OUT_DIR="logs_$(date +%Y%m%d_%H%M%S)"
SINCE="-1 hour"
LINES=1000
COMPRESS=0

usage() {
	cat <<EOF
$PROG_NAME V$PROG_VERSION
Usage: $0 [-o out_dir] [-s "SINCE"] [-n LINES] [-c]
	-o out_dir   Zielordner (default: $OUT_DIR)
	-s SINCE     Zeitfilter für journalctl (z.B. '1 hour ago' oder '2026-07-06')
	-n LINES     Anzahl der Zeilen aus klassischen Logfiles (default: $LINES)
	-c           Ergebnis als tar.gz packen
EOF
	exit 1
}

while getopts ":o:s:n:ch" opt; do
	case $opt in
		o) OUT_DIR="$OPTARG" ;;
		s) SINCE="$OPTARG" ;;
		n) LINES="$OPTARG" ;;
		c) COMPRESS=1 ;;
		h) usage ;;
		:) echo "Option -$OPTARG requires an argument."; usage ;;
		\?) echo "Invalid option: -$OPTARG"; usage ;;
	esac
done

mkdir -p "$OUT_DIR"

echo "$PROG_NAME V$PROG_VERSION" > "$OUT_DIR/summary.txt"
echo "Datum: $(date)" >> "$OUT_DIR/summary.txt"
echo "Hostname: $(hostname)" >> "$OUT_DIR/summary.txt"
echo "Since: $SINCE" >> "$OUT_DIR/summary.txt"
echo "Lines: $LINES" >> "$OUT_DIR/summary.txt"

echo
echo "Erfasse Logs -> $OUT_DIR"

echo "Fehlgeschlagene Systemdienste" > "$OUT_DIR/systemctl_failed.txt"
if command -v systemctl >/dev/null 2>&1; then
	systemctl --failed --no-pager >> "$OUT_DIR/systemctl_failed.txt" || true
else
	echo "systemctl nicht vorhanden" >> "$OUT_DIR/systemctl_failed.txt"
fi

echo "Fehler (journal)" > "$OUT_DIR/journal_errors.txt"
journalctl --since "$SINCE" -p err --no-pager >> "$OUT_DIR/journal_errors.txt" || true

echo "Warnungen (journal)" > "$OUT_DIR/journal_warnings.txt"
journalctl --since "$SINCE" -p warning --no-pager >> "$OUT_DIR/journal_warnings.txt" || true

echo "Kernel-Logs (dmesg/journal)" > "$OUT_DIR/kernel_warnings.txt"
journalctl -k --since "$SINCE" --no-pager -p warning >> "$OUT_DIR/kernel_warnings.txt" || true
dmesg | tail -n $LINES >> "$OUT_DIR/kernel_warnings.txt" || true

echo "Out of Memory Hinweise" > "$OUT_DIR/oom.txt"
journalctl --since "$SINCE" --no-pager | grep -i "out of memory" >> "$OUT_DIR/oom.txt" || true

# Classic log files (SysV systems or non-journald)
if [ -f /var/log/syslog ]; then
	echo "Kopiere /var/log/syslog" > "$OUT_DIR/syslog.txt"
	tail -n $LINES /var/log/syslog >> "$OUT_DIR/syslog.txt" || true
elif [ -f /var/log/messages ]; then
	echo "Kopiere /var/log/messages" > "$OUT_DIR/messages.txt"
	tail -n $LINES /var/log/messages >> "$OUT_DIR/messages.txt" || true
fi

if [ -f /var/log/auth.log ]; then
	echo "Kopiere /var/log/auth.log" > "$OUT_DIR/auth.log.txt"
	tail -n $LINES /var/log/auth.log >> "$OUT_DIR/auth.log.txt" || true
fi

echo "Erfasse journalctl für alle Unit-Fehler (letzte $SINCE)" > "$OUT_DIR/unit_errors.txt"
journalctl --since "$SINCE" --no-pager -p err --unit --no-hostname >> "$OUT_DIR/unit_errors.txt" || true

echo "Aktive Dienste" > "$OUT_DIR/active_services.txt"
systemctl list-units --type=service --state=running --no-pager >> "$OUT_DIR/active_services.txt" || true

echo "Kurze Systemübersicht" > "$OUT_DIR/host_overview.txt"
uname -a >> "$OUT_DIR/host_overview.txt"
uptime >> "$OUT_DIR/host_overview.txt"
free -h >> "$OUT_DIR/host_overview.txt" || true
df -h >> "$OUT_DIR/host_overview.txt" || true

echo "Fertig. Ergebnisse in: $OUT_DIR"

if [ "$COMPRESS" -eq 1 ]; then
	tar -czf "$OUT_DIR.tar.gz" -C "$(dirname "$OUT_DIR")" "$(basename "$OUT_DIR")"
	echo "Archiv erstellt: $OUT_DIR.tar.gz"
fi

exit 0

