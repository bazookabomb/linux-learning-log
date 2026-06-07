#!/bin/bash

echo "=== Analyse des aktuellen Verzeichnisses ==="

echo "Dateien:"
find . -type f | wc -l

echo "Verzeichnisse:"
find . -type d | wc -l

echo "Shell-Skripte:"
find . -name "*.sh"

echo "Größte Dateien:"
find . -type f -exec du -h {} + | sort -hr | head -10
