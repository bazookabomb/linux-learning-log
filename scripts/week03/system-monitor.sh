#!/bin/bash

echo "=== SYSTEM STATUS ==="
echo

echo "Benutzer:"
whoami

echo
echo "Hostname:"
hostname

echo
echo "Uptime:"
uptime

echo
echo "RAM:"
free -h

echo
echo "Festplatte:"
df -h
