#!/bin/bash

echo "Linux Log Analyzer V1.0"
echo "Datum: $(date)"
echo "Hostname: $(hostname)"
echo "Fehlgeschlagene Systemdienste"
systemctl --failed --no-pager
echo "Fehler seit dem letzten Boot"
journalctl -b -p err --no-pager
echo "Warnungen seit dem letzten Boot"
journalctl -b -p warning --no-pager
