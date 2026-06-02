#!/bin/bash
process() {
  local file="$1"
  [ ! -e "$file" ] && return 1
  echo "Bearbeite $file" >> processed.log
  return 0
}

for f in "$@"; do
  process "$f" || echo "Fehler bei $f"
done

echo "Fertig."
