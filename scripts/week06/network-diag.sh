#!/bin/bash

echo "========================================="
echo "        Netzwerkdiagnose"
echo "========================================="
echo

# Hostname
echo "Hostname:"
hostname
echo

# Netzwerkinterfaces
echo "=== Netzwerkinterfaces ==="
ip -br addr
echo

# Routing
echo "=== Routing-Tabelle ==="
ip route
echo

# Standardgateway ermitteln
echo "=== Standardgateway ==="
gateway=$(ip route | awk '/default/ {print $3}')

if [ -n "$gateway" ]; then
    echo "Gateway: $gateway"

    if ping -c 2 "$gateway" >/dev/null 2>&1; then
        echo "✔ Gateway erreichbar"
    else
        echo "✘ Gateway NICHT erreichbar"
    fi
else
    echo "✘ Keine Standardroute vorhanden"
fi
echo

# Internetverbindung
echo "=== Internetverbindung ==="

if ping -c 2 8.8.8.8 >/dev/null 2>&1; then
    echo "✔ Internet per IP erreichbar"
else
    echo "✘ Keine Internetverbindung"
fi
echo

# DNS-Test
echo "=== DNS-Test ==="

if command -v dig >/dev/null; then
    dig +short google.com
elif command -v nslookup >/dev/null; then
    nslookup google.com
else
    echo "Kein DNS-Tool (dig/nslookup) installiert."
fi
echo

# Offene Ports
echo "=== Listening Ports ==="
ss -tuln
echo

# Aktive Verbindungen
echo "=== Aktive TCP-Verbindungen ==="
ss -tan | head -20
echo

# DNS-Server
echo "=== DNS-Server ==="
grep nameserver /etc/resolv.conf
echo

# Firewall (optional)
echo "=== Firewall ==="

if command -v ufw >/dev/null; then
    ufw status
elif command -v firewall-cmd >/dev/null; then
    firewall-cmd --state
else
    echo "Keine unterstützte Firewall erkannt."
fi

echo
echo "========================================="
echo " Diagnose abgeschlossen."
echo "========================================="
