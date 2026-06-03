Jetzt beginnt eigentlich der interessante Teil 🙂  
Du hast die ersten Basics schon angerissen, eine Lernstruktur aufgebaut und ein realistisches Zielbild. Ab hier geht es darum, **Rhythmus + Praxis + kleine Erfolgserlebnisse** aufzubauen.

---

# 🧭 Dein nächster sinnvoller Weg (die nächsten Wochen)

## Phase 1 — Linux sicher werden (jetzt)

Dauer: ca. 3–6 Wochen bei deinem Tempo

Ziel:  
👉 Terminal soll sich „normal“ anfühlen.

---

# 🧱 Was du jetzt als Nächstes lernst

## 🟢 1. Prozesse & Systemkontrolle

Das ist der nächste große Aha-Moment.

Du lernst:

- laufende Programme sehen
    
- Prozesse stoppen
    
- Systemlast verstehen
    

Wichtige Befehle:

```bash
ps
top
htop
kill
```

👉 Hier beginnt „echtes Linux-Gefühl“.

---

## 🟢 2. Rechte & Benutzer

Sehr wichtig für Linux-Verständnis.

Du lernst:

- warum manche Befehle „Permission denied“ geben
    
- was `sudo` wirklich macht
    
- Dateirechte verstehen
    

Wichtige Befehle:

```bash
chmod
chown
sudo
```

---

## 🟢 3. Pakete installieren

Dann verstehst du:  
👉 wie Linux Software verwaltet.

```bash
sudo apt update
sudo apt install
```

---

# Was diese Ordner bedeuten (wichtig!)

## 🏠 `/home`

- deine Daten
- deine Projekte

## ⚙️ `/etc`

- Einstellungen (Konfiguration)

## 📦 `/usr`

- Programme

## 📊 `/var`

- Logs, Daten, dynamische Inhalte

## 🧰 `/bin`

- wichtige Systembefehle

# 🧠 Einfaches Bild im Kopf

Stell dir dein System vor wie eine Stadt:

- `ps` = Foto der Stadt
- `top` = Live-Kamera
- `systemctl` = Stadtverwaltung (entscheidet, was laufen darf)

# 💡 Praxis-Realität

Du nutzt später:

- `ps` → Fehler suchen
- `top` → Systemlast checken
- `systemctl` → Server reparieren / starten / stoppen

ip a
curl website
ssh ubuntu@192.168.1.10

## Kapitel 15: Schleifen + kleine Dateiautomatisierung

### Ziel

- Schleifen verstehen als „wiederhole für mehrere Elemente“
- 1 kleines Skript bauen, das mehrere Dateien verarbeitet

### Session A (20–30 min)

1. `for`-Schleife Grundidee
2. Beispiel:
    - Für jede `*.txt` Datei: Name ausgeben
3. Mini-Übung:
    - In einem Testordner 3 Dateien erstellen
    - Mit `for f in *.txt; do echo "$f"; done` testen

### Pause (5–10 min)

### Session B (20–30 min)

1. Kleine Automatisierung:
    - Für jede `*.txt` Datei Datum anhängen (z. B. in neue Datei oder Log)
2. Verständnisfokus:
    - Unterschied zwischen „Dateiname“ und „Dateiinhalt“
    - Warum Anführungszeichen bei Variablen wichtig sind: `"$f"`

- `while read` konzeptionell anschauen (noch nicht vertiefen)

---

## Minimales Lernziel für „erfolgreich abgeschlossen“

- Du kannst eine `for`-Schleife erklären
- Du kannst 1 Schleife schreiben, die über mehrere Dateien läuft
- Du kannst sagen, was `"$VAR"` schützt (Leerzeichen/Sonderfälle)
