#!/bin/bash

datei_existiert() {
    [ -f "$1" ]
}

if datei_existiert "logfile.txt"; then
	fehler=$(grep -c "ERROR" logfile.txt)
	info_meldungen=$(grep -c "INFO" logfile.txt)
	echo "=== LOG REPORT ==="
	echo
	echo "Fehler: $fehler"
	echo "Infos: $info_meldungen"
else
    echo "Datei nicht gefunden"
fi
