Wichtige Erkenntnis

Du hast jetzt gesehen:

Prozesse (ps)

→ einzelne Programme

Jobs (bash)

→ Shell-gesteuerte Prozesse

Services (systemd)

→ systemweite dauerhaft verwaltete Prozesse

Unterschied – das ist der Kern von Tag 2
Ebene	Beispiel	Wer kontrolliert es
Prozess	sleep, firefox	Kernel
Job	sleep 1000 &	Bash
Service	cron, NetworkManager	systemd
Mini-Check (wichtig)

Beantworte kurz:

1. Warum ist cron ein Service, aber sleep 1000 kein Service?

2. Was macht systemd mit Services, was Bash mit Jobs nicht macht?

1. Cron vs. sleep

Deine Antwort:

cron wird von systemd verwaltet. sleep ist ein job, gestartet von bash

✔️ korrekt gedacht

Etwas präziser:

cron ist ein Daemon (Hintergrunddienst)
wird beim Booten von systemd gestartet
läuft dauerhaft
arbeitet unabhängig von deiner Shell
sleep 1000 ist ein einzelner Prozess
wird von deiner Bash gestartet
gehört nur zu deiner aktuellen Session (Job-Control)
existiert nur solange du ihn laufen lässt

👉 Wichtig:
Nicht „cron wird von systemd verwaltet“ als Hauptpunkt merken, sondern:

cron ist ein dauerhaft laufender Systemdienst, der von systemd gestartet und überwacht wird.

2. systemd vs Bash

Deine Antwort:

systemweit dauerhaft verwalten

✔️ richtig, aber noch etwas unscharf.

Besser formuliert:

systemd verwaltet Dienste unabhängig von Benutzer-Sessions und sorgt für Start, Neustart, Logging und Abhängigkeiten.

Der entscheidende Unterschied:

Bash (Jobs)
nur für deine aktuelle Shell
keine Systemkontrolle
kein Autostart nach Reboot
kein Dependency-Management
systemd (Services)
systemweit
startet beim Boot
überwacht Prozesse (Restart bei Crash möglich)
verwaltet Abhängigkeiten (z. B. Netzwerk vor Webserver)
integriert Logging (journalctl)
Der eigentliche Kernunterschied

Das ist die Prüfungs-relevante Version:

Bash steuert Prozesse temporär für einen Benutzer.
systemd steuert Dienste dauerhaft für das gesamte System.
