```python
#!/usr/bin/env python3

import subprocess
import logging
from pathlib import Path
from datetime import datetime


# Log-Verzeichnis anlegen
log_dir = Path("logs")
log_dir.mkdir(exist_ok=True)

log_file = log_dir / "group_management.log"

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)


def user_exists(username):
    result = subprocess.run(
        ["id", username],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    return result.returncode == 0


def group_exists(groupname):
    result = subprocess.run(
        ["getent", "group", groupname],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    return result.returncode == 0


def add_user_to_group(username, groupname):
    try:
        subprocess.run(
            ["sudo", "usermod", "-aG", groupname, username],
            check=True
        )

        message = (
            f"Benutzer '{username}' wurde "
            f"zur Gruppe '{groupname}' hinzugefügt."
        )

        print(message)
        logging.info(message)

    except subprocess.CalledProcessError as error:
        message = (
            f"Fehler beim Hinzufügen von "
            f"'{username}' zu '{groupname}': {error}"
        )

        print(message)
        logging.error(message)


def main():
    print("\n=== Gruppenverwaltung ===\n")

    username = input("Benutzername: ").strip()
    groupname = input("Gruppenname: ").strip()

    if not user_exists(username):
        print(f"Benutzer '{username}' existiert nicht.")
        logging.warning(
            f"Nicht vorhandener Benutzer abgefragt: {username}"
        )
        return

    if not group_exists(groupname):
        print(f"Gruppe '{groupname}' existiert nicht.")
        logging.warning(
            f"Nicht vorhandene Gruppe abgefragt: {groupname}"
        )
        return

    add_user_to_group(username, groupname)


if __name__ == "__main__":
    main()
```

