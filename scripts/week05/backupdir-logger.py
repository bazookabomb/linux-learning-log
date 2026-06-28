import os
import subprocess
import logging
from pathlib import Path

# Logging konfigurieren
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

logging.info("Programm gestartet.")

# Aktuelles Arbeitsverzeichnis mit os
current_dir = os.getcwd()
logging.info(f"Aktuelles Verzeichnis: {current_dir}")

# Verzeichnis mit pathlib erstellen
backup_dir = Path(current_dir) / "backup"

if not backup_dir.exists():
    backup_dir.mkdir()
    logging.info(f"Ordner erstellt: {backup_dir}")
else:
    logging.info(f"Ordner existiert bereits: {backup_dir}")

# Betriebssystembefehl mit subprocess ausführen
try:
    result = subprocess.run(
        ["ls", "-l"],
        capture_output=True,
        text=True,
        check=True
    )

    logging.info("Verzeichnisinhalt:")
    print(result.stdout)

except subprocess.CalledProcessError as e:
    logging.error(f"Fehler beim Ausführen des Befehls: {e}")

logging.info("Programm beendet.")
