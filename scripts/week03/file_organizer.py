import os
import shutil

ordner = os.path.expanduser("~/test-downloads")

# Zielordner anlegen
os.makedirs(f"{ordner}/Bilder", exist_ok=True)
os.makedirs(f"{ordner}/PDFs", exist_ok=True)
os.makedirs(f"{ordner}/ZIP", exist_ok=True)
os.makedirs(f"{ordner}/TXT", exist_ok=True)

for datei in os.listdir(ordner):

    quelle = f"{ordner}/{datei}"

    if os.path.isdir(quelle):
        continue

    if datei.endswith(".jpg") or datei.endswith(".png"):
        ziel = f"{ordner}/Bilder/{datei}"

    elif datei.endswith(".pdf"):
        ziel = f"{ordner}/PDFs/{datei}"

    elif datei.endswith(".zip"):
        ziel = f"{ordner}/ZIP/{datei}"

    elif datei.endswith(".txt"):
        ziel = f"{ordner}/TXT/{datei}"

    else:
        continue

    shutil.move(quelle, ziel)

print("Dateien wurden sortiert.")
