#!/bin/bash
for f in *.txt; do
	[ ! -e "$f" ] && break
	echo "Angehängt am: $(date '+%F %T')" >> "$f"
done
echo "Fertig."
