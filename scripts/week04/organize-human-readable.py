#!/usr/bin/env python3

from pathlib import Path
import argparse
import shutil


def finde_freien_dateinamen(zielpfad: Path):
    """
    Verhindert das Überschreiben von Dateien.

    Beispiel:
        bild.jpg existiert bereits

    Dann wird daraus:
        bild_1.jpg

    Falls auch bild_1.jpg existiert:
        bild_2.jpg
    """

    if not zielpfad.exists():
        return zielpfad

    dateiname_ohne_endung = zielpfad.stem
    dateiendung = zielpfad.suffix

    nummer = 1

    while True:
        neuer_name = (
            f"{dateiname_ohne_endung}_{nummer}{dateiendung}"
        )

        kandidat = zielpfad.with_name(neuer_name)

        if not kandidat.exists():
            return kandidat

        nummer += 1


def sortiere_dateien(
    ordner: Path,
    rekursiv=False,
    nur_vorschau=True
):
    """
    Sortiert Dateien nach Dateiendung.

    Beispiel:

        foto.jpg
            -> jpg/foto.jpg

        dokument.pdf
            -> pdf/dokument.pdf
    """

    # Welche Dateien sollen betrachtet werden?

    if rekursiv:
        dateien = ordner.rglob("*")
    else:
        dateien = ordner.iterdir()

    for datei in dateien:

        # Ordner überspringen
        if not datei.is_file():
            continue

        # Dateiendung bestimmen

        dateiendung = datei.suffix.lower()
        dateiendung = dateiendung.lstrip(".")

        if dateiendung == "":
            dateiendung = "ohne_endung"

        # Zielordner bestimmen

        zielordner = ordner / dateiendung

        # Sonderfall:
        # Falls bereits eine Datei namens "jpg" existiert

        if zielordner.exists() and zielordner.is_file():
            zielordner = ordner / f"{dateiendung}_ordner"

        # Zielpfad zusammensetzen

        zielpfad = zielordner / datei.name

        # Überschreiben verhindern

        zielpfad = finde_freien_dateinamen(zielpfad)

        # Nur anzeigen?

        if nur_vorschau:
            print(f"VORSCHAU: {datei} -> {zielpfad}")
            continue

        # Zielordner anlegen

        zielordner.mkdir(
            parents=True,
            exist_ok=True
        )

        # Nicht in sich selbst verschieben

        if datei.resolve() == zielpfad.resolve():
            continue

        # Datei verschieben

        shutil.move(
            str(datei),
            str(zielpfad)
        )

        print(f"Verschoben: {datei.name}")


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Dateien nach Endungen sortieren"
    )

    parser.add_argument(
        "ordner",
        nargs="?",
        default=".",
        help="Welcher Ordner soll sortiert werden?"
    )

    parser.add_argument(
        "--execute",
        action="store_true",
        help="Dateien wirklich verschieben"
    )

    parser.add_argument(
        "--rekursiv",
        action="store_true",
        help="Auch Unterordner durchsuchen"
    )

    args = parser.parse_args()

    sortiere_dateien(
        ordner=Path(args.ordner),
        rekursiv=args.rekursiv,
        nur_vorschau=not args.execute
    )
