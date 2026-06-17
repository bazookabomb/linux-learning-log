sudo mkdir -p /opt/test-service
# Datei erstellen (Editor oder tee)
sudo tee /opt/test-service/service.py > /dev/null <<'PY'
...inhalt wie oben...
PY
sudo chmod +x /opt/test-service/service.py

# Unit anlegen (Editor oder tee)
sudo tee /etc/systemd/system/test-service.service > /dev/null <<'INI'
...inhalt wie oben...
INI

sudo systemctl daemon-reload
sudo systemctl enable --now test-service
sudo systemctl status test-service
sudo journalctl -u test-service -f
# oder die Logdatei prüfen
sudo tail -n 50 /var/log/test-service.log

# Signale testen
# 1) systemd stop (soll SIGTERM senden)
sudo systemctl stop test-service

# 2) Manuell an PID senden
pid=$(pidof python3)
sudo kill -TERM $pid
sudo kill -9 $pid   # SIGKILL (nicht abfangbar) — nur wenn nötig

# PID finden
ps aux | grep /opt/test-service/service.py
