import sys
from datetime import datetime


def datei_existiert(pfad):
    try:
        with open(pfad, "r"):
            return True
    except FileNotFoundError:
        return False


print("=== LOG ANALYZER V3 ===")
print()

if len(sys.argv) < 2:
    print("Verwendung:")
    print("python3 log_analyzer_v3.py <logdatei> [reportdatei]")
    sys.exit(1)

logdatei = sys.argv[1]

if not datei_existiert(logdatei):
    print("Datei nicht gefunden.")
    sys.exit(1)

# Report-Datei bestimmen
if len(sys.argv) >= 3:
    report_datei = sys.argv[2]
else:
    datum = datetime.now().strftime("%Y-%m-%d")
    report_datei = f"log_report_{datum}.txt"

# Datei lesen
with open(logdatei, "r") as f:
    zeilen = f.readlines()

infos = 0
errors = 0
warnings = 0

for zeile in zeilen:
    if "INFO" in zeile:
        infos += 1
    elif "ERROR" in zeile:
        errors += 1
    elif "WARNING" in zeile:
        warnings += 1

gesamt = len(zeilen)

if gesamt > 0:
    info_pct = infos / gesamt * 100
    error_pct = errors / gesamt * 100
    warn_pct = warnings / gesamt * 100
else:
    info_pct = error_pct = warn_pct = 0

report_zeit = datetime.now().strftime("%d.%m.%Y %H:%M:%S")

# Ausgabe
print(f"Datei: {logdatei}")
print(f"INFO:    {infos} ({info_pct:.1f}%)")
print(f"ERROR:   {errors} ({error_pct:.1f}%)")
print(f"WARN:    {warnings} ({warn_pct:.1f}%)")
print(f"TOTAL:   {gesamt}")

# Report schreiben
with open(report_datei, "w") as f:
    f.write("=== LOG REPORT ===\n\n")
    f.write(f"Erstellt: {report_zeit}\n")
    f.write(f"Datei: {logdatei}\n\n")
    f.write(f"INFO:    {infos} ({info_pct:.1f}%)\n")
    f.write(f"ERROR:   {errors} ({error_pct:.1f}%)\n")
    f.write(f"WARN:    {warnings} ({warn_pct:.1f}%)\n")
    f.write(f"TOTAL:   {gesamt}\n")

print()
print(f"Report gespeichert in: {report_datei}")
