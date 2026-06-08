#!/bin/bash

echo "=== TAGESREPORT ==="
echo "Datum: $(date)"
echo "\nTXT-Dateien: $(ls *.txt | wc -l)"
echo "\nFehler im Log: $(grep -c "ERROR" logfile.txt)"

for file in *.txt; do
	echo "$file"
done
