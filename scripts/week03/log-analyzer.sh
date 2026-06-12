#!/bin/bash

datei_existiert() {
    [ -f "$1" ]
}

echo "=== LOG ANALYZER ==="
echo

if datei_existiert "$1"; then
    echo "Datei: $1"
    echo

    infos=$(grep -c "INFO" "$1")
    errors=$(grep -c "ERROR" "$1")
    total=$(wc -l < "$1")

    echo "INFO-Meldungen: $infos"
    echo "ERROR-Meldungen: $errors"
    echo "Gesamtzeilen: $total"
else
    echo "Datei nicht gefunden"
fi

