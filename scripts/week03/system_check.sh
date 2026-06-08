#!/bin/bash

echo "=== SYSTEM CHECK ==="
echo
echo "Datum: $(date)"
echo "Benutzer: $(whoami)"
echo "Hostname: $(hostname)"
echo "Freier Speicher: $(df -h)"
echo "Uptime: $(uptime)"
