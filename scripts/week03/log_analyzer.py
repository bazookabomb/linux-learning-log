import sys

def datei_existiert(pfad):
    try:
        with open(pfad, "r"):
            return True
    except FileNotFoundError:
        return False


print("=== LOG ANALYZER ===")
print()

# Prüfen ob Datei angegeben wurde
if len(sys.argv) < 2:
    print("Bitte Dateiname angeben.")
    sys.exit(1)

datei = sys.argv[1]

if datei_existiert(datei):
    print(f"Datei: {datei}")
    print()

    with open(datei, "r") as f:
        zeilen = f.readlines()

    infos = 0
    errors = 0

    for zeile in zeilen:
        if "INFO" in zeile:
            infos += 1
        if "ERROR" in zeile:
            errors += 1

    total = len(zeilen)

    print(f"INFO-Meldungen: {infos}")
    print(f"ERROR-Meldungen: {errors}")
    print(f"Gesamtzeilen: {total}")

else:
    print("Datei nicht gefunden")
