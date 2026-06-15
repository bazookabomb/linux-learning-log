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
