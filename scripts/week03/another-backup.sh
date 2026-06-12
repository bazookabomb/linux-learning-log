#!/bin/bash

if [ -z "$1" ]; then
    echo "Bitte Verzeichnis angeben."
    exit 1
fi

BACKUP_NAME="backup_$(date +%Y-%m-%d).tar.gz"

tar -czf "$BACKUP_NAME" "$1"

echo "Backup erstellt: $BACKUP_NAME"
