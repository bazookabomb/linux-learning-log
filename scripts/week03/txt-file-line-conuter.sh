#!/bin/bash

for file in *.txt; do
	echo "Datei: $file"
	echo "Zeilen: $(wc -l < "$file")"
	echo
done
