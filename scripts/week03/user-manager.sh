#!/bin/bash

USER_FILE="users.txt"

while true; do
    echo
    echo "=== BENUTZERVERWALTUNG ==="
    echo "1) Benutzer anzeigen"
    echo "2) Benutzer hinzufügen"
    echo "3) Beenden"
    echo

    read -r auswahl

    case "$auswahl" in
        1)
            echo
            echo "Benutzerliste:"
            cat "$USER_FILE"
            ;;

        2)
            echo
            echo "Neuen Benutzer eingeben:"
            read -r neuer_user

            echo "$neuer_user" >> "$USER_FILE"

            echo "Benutzer hinzugefügt."
            ;;

        3)
            echo "Programm wird beendet."
            break
            ;;

        *)
            echo "Ungültige Eingabe."
            ;;
    esac
done
