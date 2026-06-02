#!/usr/bin/env bash
# error_report.sh
#
# Zweck:
#   Durchsucht Logdateien in einem Verzeichnis nach Zeilen, die "ERROR" enthalten,
#   erstellt eine bereinigte, aggregierte Fehlerübersicht (`error_summary.txt`)
#   und sammelt die kompletten Fundstellen in `error_full.log`.
#
# Hinweise:
#   - Standardmäßig sucht das Script im aktuellen Verzeichnis nach Dateien mit der Endung .log.
#   - Es ist sicher gegenüber dem Fehlen von .log-Dateien (durch Verwendung von nullglob).
#   - Temporäre Dateien werden in einem sicheren temporären Verzeichnis erstellt und beim Beenden bereinigt.
#   - Exit‑Status: 0 bei Erfolg, >0 bei Fehlern (z. B. fehlende Schreibrechte).
#
# Beispiel:
#   chmod +x error_report.sh
#   ./error_report.sh /var/log/myapp
#
# Sehr ausführliche Kommentare folgen zu jeder relevanten Zeile/Gruppe.

set -euo pipefail
# Erläuterung:
#   - set -e : Beendet das Script, falls ein Befehl mit einem Nicht‑Null Exitcode endet.
#   - set -u : Fehlermeldung und Abbruch, wenn eine verwendete Variable nicht gesetzt ist.
#   - set -o pipefail : Gibt den Exitcode des ersten fehlgeschlagenen Befehls in einer Pipe zurück.
# Warum: schützt gegen stillschweigende Fehler und unerwartete Zustände.

# -------------------------
# Konfigurierbare Variablen
# -------------------------
LOG_DIR="${1:-.}"
# Erläuterung:
#   - $1 : optionales erstes Argument beim Aufruf des Scripts (z. B. Pfad zu Logs).
#   - Default ist aktuelles Verzeichnis (.). So funktioniert `./error_report.sh` ohne Parameter.

PATTERN="*.log"
# Erläuterung:
#   - Dateinamensmuster für Logdateien. Kann zu "*.txt" o.ä. geändert werden.

SUMMARY_FILE="error_summary.txt"
# Erläuterung:
#   - Diese Datei wird am Ende eine Übersicht mit Fehlerhäufigkeiten pro Fehlertext enthalten.

FULL_FILE="error_full.log"
# Erläuterung:
#   - Diese Datei enthält die kompletten Zeilen (mit Datei und Zeilennummer), die "ERROR" enthielten.

# -------------------------
# Temporäre Dateien & Cleanup
# -------------------------
TMPDIR="$(mktemp -d)"
# mktemp -d : erzeugt ein sicheres temporäres Verzeichnis und gibt dessen Pfad zurück.
# Warum temporär:
#   - Möglichst atomare Arbeit: Zwischenergebnisse getrennt speichern, bevor finale Ausgabedateien überschrieben werden.

cleanup() {
  # Funktion zum Bereinigen temporärer Dateien bei Beendigung
  rm -rf -- "${TMPDIR}"
}
trap cleanup EXIT
# trap ... EXIT : sorgt dafür, dass cleanup auch bei Abbruch, Fehler oder normalem Ende ausgeführt wird.

# -------------------------
# Vorbedingungen prüfen
# -------------------------
# Stelle sicher, dass das Logverzeichnis existiert und begehbar ist.
if [[ ! -d "$LOG_DIR" ]]; then
  echo "Fehler: Log‑Verzeichnis existiert nicht: $LOG_DIR" >&2
  exit 2
fi

# Stelle sicher, dass wir in das Logverzeichnis wechseln können (erleichtert relative Pfade und Ausgabe).
cd "$LOG_DIR"

# Erlaube leere Globs (nullglob): ein nicht gefundenes Muster expandiert zu nichts statt zu literalem "*.log".
shopt -s nullglob
# Hinweis: nullglob ist shell‑spezifisch (bash). Dadurch vermeiden wir, dass das Muster "*.log" als String gehandhabt wird.

# -------------------------
# Sammeln: vollständige Fehlerzeilen
# -------------------------
# Ziel: vollständige Zeilen mit Kontext (Dateiname:Zeilennummer:Zeile) in FULL_FILE sammeln.
# Wir nutzen grep -Hn, wobei:
#   -H : immer Dateiname ausgeben
#   -n : Zeilennummer ausgeben
# grep verwendet Standard‑Regex; hier suchen wir nach dem Wort "ERROR" (Großschreibung).
# Wenn Logs unterschiedliche Wortfälle enthalten, könnte man -i hinzufügen (case‑insensitive).

# Falls keine .log-Dateien vorhanden sind, ist die Folge ein leerer Durchlauf (kein Fehler).
log_files=( $PATTERN )
if [[ ${#log_files[@]} -eq 0 ]]; then
  # Keine Logdateien gefunden — leere Ausgabedateien erzeugen und ordentlich beenden.
  : > "$FULL_FILE"
  : > "$SUMMARY_FILE"
  echo "Keine Logdateien mit Muster $PATTERN im Verzeichnis $LOG_DIR gefunden."
  exit 0
fi

# Erzeuge temporäre Dateien für Zwischenergebnisse
TMP_FULL="${TMPDIR}/full_hits.tmp"
TMP_MESSAGES="${TMPDIR}/messages_only.tmp"

# Suche nach "ERROR" (Großschreibung). Die Ausgabe ist: filename:linenumber:matched_line
# Wir leiten in TMP_FULL, falls grep scheitert (z. B. ungültige Codierung), beendet set -e das Script.
# Um robuster zu sein, fangen wir grep-Fehler manuell ab (hier aber bewusst nicht, um Fehler sichtbar zu machen).
grep -Hn "ERROR" -- "${log_files[@]}" > "$TMP_FULL" || true
# Hinweis zu "|| true":
#   - grep liefert Exitcode 1, wenn keine Treffer gefunden wurden; mit set -e würde das Script abbrechen.
#   - durch "|| true" verhindern wir den Abbruch und können später sauber mit leeren Ergebnissen arbeiten.

# Schreibe die kompletten Treffer in die endgültige FULL_FILE (überschreibe vorhandene Datei).
# Wir fügen zusätzlich einen Zeitstempel und eine Kopfzeile hinzu, damit FULL_FILE selbstdokumentierend ist.
{
  echo "# error_full.log - generiert am $(date --iso-8601=seconds)"
  echo "# Suchmuster: ERROR"
  echo "# Suchverzeichnis: $LOG_DIR"
  echo ""
  cat "$TMP_FULL"
} > "$FULL_FILE"

# -------------------------
# Aggregieren: bereinigte Fehlertexte
# -------------------------
# Ziel: aus den Trefferzeilen einen "Fehler‑Text" extrahieren (z. B. die eigentliche Fehlermeldung ohne Zeitstempel/Loglevel),
# und dann nach Häufigkeit sortieren.
#
# Vorgehen:
# 1) Aus der kompletten Trefferzeile den Teil nach 'ERROR' extrahieren (oder ab dem ersten Vorkommen von ERROR bis Zeilenende).
# 2) Whitespace normalisieren (mehrfache Leerzeichen zusammenfassen).
# 3) Sortieren und zusammenzählen (uniq -c).
# 4) Ergebnis in SUMMARY_FILE schreiben.

# Extraktion: wir nehmen alles ab 'ERROR' inklusive folgendem Text.
# Erklärung des awk-Ausdrucks:
#   - match($0, /ERROR.*/): findet das erste Vorkommen von 'ERROR' bis Ende der Zeile
#   - substr($0, RSTART): holt den gefundenen Substring
#   - gsub(/^[[:space:]]+|[[:space:]]+$/, "", s): trimmt führende/trailing Whitespace
awk 'match($0, /ERROR.*/) { s = substr($0, RSTART); gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); print s }' "$TMP_FULL" > "$TMP_MESSAGES" || true

# Falls TMP_MESSAGES leer ist (z. B. nur Treffer in nicht-parsebaren Dateien), erzeugen wir eine leere SUMMARY_FILE.
if [[ ! -s "$TMP_MESSAGES" ]]; then
  : > "$SUMMARY_FILE"
  echo "Keine 'ERROR'‑Meldungen extrahiert; $SUMMARY_FILE bleibt leer."
  exit 0
fi

# Normalisiere Whitespace: mehrere Leerzeichen werden zu einem, Tabs werden zu Leerzeichen etc.
# Danach sortieren und zählen wir gleiche Nachrichten und sortieren absteigend nach Häufigkeit.
# Erklärung Befehlsfolge:
#   - sed -E 's/[[:space:]]+/ /g' : ersetzt beliebige Whitespace‑Sequenzen durch ein einzelnes Leerzeichen
#   - sed -E 's/^[[:space:]]+|[[:space:]]+$//g' : trimmt führende und folgende Leerzeichen
#   - sort : lexikographisch sortieren (Vorbereitung für uniq)
#   - uniq -c : zählt identische aufeinanderfolgende Zeilen
#   - sort -rn : sortiert numerisch (rückwärts), d.h. häufigste Fehler zuerst
#   - awk '{printf "%6d  %s\n", $1, substr($0, index($0,$2))}' : formatiert die Ausgabe: count + message
sed -E 's/[[:space:]]+/ /g; s/^[[:space:]]+|[[:space:]]+$//g' "$TMP_MESSAGES" \
  | sort \
  | uniq -c \
  | sort -rn \
  > "${TMPDIR}/summary_sorted.tmp"

# Ergänze Kopfzeile mit Metadaten und schreibe in SUMMARY_FILE
{
  echo "# error_summary.txt - generiert am $(date --iso-8601=seconds)"
  echo "# Enthält: Häufigkeitsliste der bereinigten Fehlernachrichten (am häufigsten zuerst)"
  echo "# Suchverzeichnis: $LOG_DIR"
  echo ""
  cat "${TMPDIR}/summary_sorted.tmp"
} > "$SUMMARY_FILE"

# -------------------------
# Abschlussinfo / Exit
# -------------------------
# Gebe eine kurze Erfolgsmeldung mit Pfaden zu den generierten Dateien aus.
echo "Erledigt: $FULL_FILE und $SUMMARY_FILE wurden erstellt."
echo "Detail: vollständige Treffer: $(wc -l < "$FULL_FILE" || echo 0 | tr -d ' ' ) Zeilen (inkl. Kopf)."
echo "Detail: unterschiedliche Fehler/Zeilen in Übersicht: $(wc -l < "${TMPDIR}/summary_sorted.tmp" || echo 0 | tr -d ' ' )"

exit 0
