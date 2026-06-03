#!/bin/bash

echo "1) Datum"
echo "2) Uptime"
echo "3) Benutzer"

read auswahl

case $auswahl in
	1) date ;;
	2) uptime ;;
	3) whoami ;;
	*) echo "Ungültig" ;;
esac
