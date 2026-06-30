#!/bin/bash

echo "Linux Log Analyzer V1.1"
echo
echo "Datum: $(date)"
echo "Hostname: $(hostname)"
echo
echo "Fehlgeschlagene Systemdienste"
systemctl --failed --no-pager
echo
echo "Fehler seit dem letzten Boot"
journalctl -b -p err --no-pager
echo
echo "Warnungen seit dem letzten Boot"
journalctl -b -p warning --no-pager
echo
echo "Kernel-Fehler"
journalctl -k -p warning --no-pager
echo
echo "Out of Memory Fehler"
journalctl --no-pager | grep -i "out of memory"

