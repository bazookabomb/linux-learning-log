#!/bin/bash

# Netzwerkdiagnose mit Optionen: -o|--output <file>, --json, --full, -h|--help

set -o errexit
set -o pipefail

LOGFILE=""
JSON=false
FULL=false

show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -o, --output FILE   Schreibe Ausgabe zusätzlich in FILE
      --json          Gebe Zusammenfassung als JSON aus
      --full          Erweiterte Tests (traceroute, mehr Checks)
  -h, --help          Diese Hilfe
EOF
}

log() {
    local ts
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$ts] $*"
    if [ -n "$LOGFILE" ]; then
        echo "[$ts] $*" >>"$LOGFILE"
    fi
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        -o|--output)
            LOGFILE="$2"
            shift 2
            ;;
        --json)
            JSON=true
            shift
            ;;
        --full)
            FULL=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unbekannte Option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

log "========================================="
log "        Netzwerkdiagnose"
log "========================================="

# collect summary variables
GATEWAY=""
GATEWAY_OK="unknown"
INTERNET_OK="unknown"
DNS_OK="unknown"
HTTP_OK="unknown"

# Hostname
log "Hostname: $(hostname)"

# Netzwerkinterfaces
log "=== Netzwerkinterfaces ==="
if command -v ip >/dev/null 2>&1; then
    ip -br addr | while read -r l; do log "$l"; done
else
    if command -v ifconfig >/dev/null 2>&1; then
        ifconfig | while read -r l; do log "$l"; done
    else
        log "Kein Tool für Interfaces gefunden (ip/ifconfig)."
    fi
fi

# Routing
log "=== Routing-Tabelle ==="
if command -v ip >/dev/null 2>&1; then
    ip route | while read -r l; do log "$l"; done
else
    route -n | while read -r l; do log "$l"; done
fi

# Standardgateway ermitteln
log "=== Standardgateway ==="
if command -v ip >/dev/null 2>&1; then
    GATEWAY=$(ip route | awk '/default/ {print $3; exit}')
else
    GATEWAY=$(route -n | awk '/UG/ {print $2; exit}')
fi

if [ -n "$GATEWAY" ]; then
    log "Gateway: $GATEWAY"
    if ping -c 2 "$GATEWAY" >/dev/null 2>&1; then
        log "✔ Gateway erreichbar"
        GATEWAY_OK="true"
    else
        log "✘ Gateway NICHT erreichbar"
        GATEWAY_OK="false"
    fi
else
    log "✘ Keine Standardroute vorhanden"
    GATEWAY_OK="false"
fi

# Internetverbindung
log "=== Internetverbindung ==="
if ping -c 2 8.8.8.8 >/dev/null 2>&1; then
    log "✔ Internet per IP erreichbar"
    INTERNET_OK="true"
else
    log "✘ Keine Internetverbindung"
    INTERNET_OK="false"
fi

# DNS-Test
log "=== DNS-Test ==="
if command -v dig >/dev/null 2>&1; then
    DNS_RES=$(dig +short google.com | tr '\n' ' ')
    log "dig google.com: $DNS_RES"
    DNS_OK="true"
elif command -v nslookup >/dev/null 2>&1; then
    DNS_RES=$(nslookup google.com 2>/dev/null | awk -F': ' '/Address: /{print $2}' | tr '\n' ' ')
    log "nslookup google.com: $DNS_RES"
    DNS_OK="true"
else
    log "Kein DNS-Tool (dig/nslookup) installiert."
    DNS_OK="false"
fi

# HTTP(S) Check
log "=== HTTP(S)-Check ==="
if command -v curl >/dev/null 2>&1; then
    if curl -sS --max-time 10 -I https://www.google.com >/dev/null 2>&1; then
        log "✔ HTTPS erreichbar (curl)"
        HTTP_OK="true"
    else
        log "✘ HTTPS NICHT erreichbar (curl)"
        HTTP_OK="false"
    fi
else
    log "curl nicht installiert; HTTP-Check übersprungen."
    HTTP_OK="unknown"
fi

# Optional: traceroute und erweiterte Checks
if [ "$FULL" = true ]; then
    log "=== Erweiterte Tests (traceroute) ==="
    if command -v traceroute >/dev/null 2>&1; then
        log "Traceroute zum Gateway ($GATEWAY):"
        if [ -n "$GATEWAY" ]; then
            traceroute -m 30 "$GATEWAY" | while read -r l; do log "$l"; done
        else
            log "Kein Gateway zum Traceroute vorhanden."
        fi
        if command -v traceroute >/dev/null 2>&1 && [ -n "$GATEWAY" ]; then
            :
        fi
    else
        log "traceroute nicht installiert; übersprungen."
    fi
fi

# Listening Ports
log "=== Listening Ports ==="
if command -v ss >/dev/null 2>&1; then
    ss -tuln | while read -r l; do log "$l"; done
else
    if command -v netstat >/dev/null 2>&1; then
        netstat -tuln | while read -r l; do log "$l"; done
    else
        log "Kein Tool für Listening-Ports gefunden (ss/netstat)."
    fi
fi

# Aktive Verbindungen
log "=== Aktive TCP-Verbindungen ==="
if command -v ss >/dev/null 2>&1; then
    ss -tan | head -20 | while read -r l; do log "$l"; done
else
    netstat -tan | head -20 | while read -r l; do log "$l"; done
fi

# DNS-Server
log "=== DNS-Server ==="
if [ -f /etc/resolv.conf ]; then
    grep nameserver /etc/resolv.conf | while read -r l; do log "$l"; done
else
    log "/etc/resolv.conf nicht gefunden."
fi

# Firewall (optional)
log "=== Firewall ==="
if command -v ufw >/dev/null 2>&1; then
    ufw status | while read -r l; do log "$l"; done
elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --state | while read -r l; do log "$l"; done
else
    log "Keine unterstützte Firewall erkannt."
fi

log ""
log "========================================="
log " Diagnose abgeschlossen."
log "========================================="

# JSON-Ausgabe falls gewünscht
if [ "$JSON" = true ]; then
    # einfache JSON-Zusammenfassung
    JSON_OUT="{\n"
    JSON_OUT+="  \"hostname\": \"$(hostname)\",\n"
    JSON_OUT+="  \"gateway\": \"${GATEWAY}\",\n"
    JSON_OUT+="  \"gateway_ok\": \"${GATEWAY_OK}\",\n"
    JSON_OUT+="  \"internet_ok\": \"${INTERNET_OK}\",\n"
    JSON_OUT+="  \"dns_ok\": \"${DNS_OK}\",\n"
    JSON_OUT+="  \"http_ok\": \"${HTTP_OK}\"\n"
    JSON_OUT+="}"
    echo -e "$JSON_OUT"
    if [ -n "$LOGFILE" ]; then
        echo -e "$JSON_OUT" >>"$LOGFILE"
    fi
fi

exit 0

