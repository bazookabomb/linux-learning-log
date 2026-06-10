#!/bin/bash

willkommen() {
    # hier Ausgabe
    echo "Willkommen $1"
}

while read -r user; do
    willkommen "$user"
done < users.txt
