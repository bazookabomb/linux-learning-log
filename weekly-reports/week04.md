# Woche 04 - Linux Services, Dateisysteme & Datensicherung Learning Log

## Lernziel

Linux-Systemadministration vertiefen, den Umgang mit Diensten und Prozessen verstehen, Dateirechte sicher anwenden, Backup-Strategien kennenlernen sowie Python-Projekte und persönliche Lernmethoden weiter verbessern.

---

## Inhalte

* Linux-Prozesse und Signale

  * Unterschied zwischen Prozessen und Diensten
  * Wichtige Signale verstanden:

    * `SIGTERM` – kontrollierte Beendigung
    * `SIGKILL` – sofortige Beendigung
    * `SIGINT` – Unterbrechung durch `Strg + C`
  * Prozesse überwachen und kontrollieren

* Systemd und Linux-Dienste

  * Eigene Services verwalten
  * Wichtige Befehle:

    * `sudo systemctl daemon-reload`
    * `sudo systemctl enable --now test-service`
    * `sudo systemctl status test-service`
    * `journalctl -u test-service -f`
  * Service-Logs analysieren

* Linux-Dateisystem und Berechtigungen

  * Anzeige und Interpretation von Rechten (`ls -l`, `stat`)
  * Berechtigungen mit `chmod`

    * Symbolische Schreibweise
    * Numerische Schreibweise
  * Eigentümer und Gruppen mit `chown`
  * Standardrechte mit `umask`
  * Spezialbits verstehen:

    * `setuid`
    * `setgid`
    * `sticky bit`
  * Symlinks und Hardlinks vergleichen und anwenden

* Python-Module und Werkzeuge

  * `pathlib` für moderne Pfadverwaltung
  * `shutil` zum Kopieren und Verschieben von Dateien
  * Fehlende Python-Komponenten identifiziert und behoben (`pip3`)

* Datensicherung und Wiederherstellung

  * Grundlagen von Backup- und Restore-Prozessen
  * Einsatz von `rsync`
  * Prüfsummen zur Integritätsprüfung
  * Wiederherstellung von Backups getestet

* Hardware-Grundlagen

  * Recherche zu wichtigen PC-Komponenten
  * Verständnis für Hardware-Zusammenspiel erweitert

* Lernmethodik

  * Eigene Lernstrategien analysiert
  * Lernprozess optimiert und strukturierter gestaltet

---

## Praxis

* Linux-Service erstellt, gestartet und überwacht
* Systemd-Konfigurationen getestet
* Service-Logs mit `journalctl` analysiert
* Rechte und Eigentümer auf Dateien und Verzeichnissen verändert
* Spezialbits in sicheren Testumgebungen ausprobiert
* Symlinks und Hardlinks erstellt und verglichen
* Ubuntu-VM-Probleme behoben

  * VirtualBox neu installiert
  * Entwicklungsumgebung wiederhergestellt
* Fehlendes `pip3` nachinstalliert und konfiguriert
* Erstes Backup-Skript mit `rsync` entwickelt
* Restore-Prozess praktisch getestet
* Prüfsummen zur Backup-Kontrolle eingesetzt
* Python-Datei-Organizer überarbeitet und verbessert
* GitHub Copilot-Probleme mit alten VS-Code-Sitzungen untersucht und behoben

---

## Erkenntnisse

* Linux-Dienste werden über Systemd zentral verwaltet und lassen sich zuverlässig automatisieren.
* Die verschiedenen Signale erfüllen unterschiedliche Aufgaben bei der Prozesssteuerung.
* Dateirechte und Besitzverhältnisse sind ein zentraler Bestandteil der Systemsicherheit.
* `umask` beeinflusst die Standardberechtigungen neuer Dateien und Verzeichnisse.
* Spezialbits ermöglichen spezielle Rechtekonzepte und sollten bewusst eingesetzt werden.
* Symlinks und Hardlinks verfolgen unterschiedliche Ansätze zur Verknüpfung von Dateien.
* Backups sind nur dann sinnvoll, wenn auch die Wiederherstellung regelmäßig getestet wird.
* `rsync` bietet eine effiziente und flexible Möglichkeit zur Datensicherung.
* Python-Projekte profitieren von modernen Bibliotheken wie `pathlib`.
* Technische Probleme in virtuellen Maschinen gehören zum Lernprozess und stärken die Fehlersuche.

---

## Probleme

* Die Ubuntu-VM zeigte Instabilitäten und erforderte eine Neuinstallation von VirtualBox.
* Das fehlende `pip3` verhinderte zunächst die Installation zusätzlicher Python-Pakete.
* Fehler durch alte VS-Code- und GitHub-Copilot-Sitzungen erschwerten zeitweise die Entwicklung.
* Die Unterschiede zwischen symbolischer und numerischer Rechtevergabe mussten bewusst geübt werden.
* Das Verständnis von Spezialbits erforderte zusätzliche praktische Tests.

---

## Nächste Schritte

* Linux-Prozessmanagement weiter vertiefen
* Systemd-Services selbstständig erstellen und erweitern
* Backup-Skripte automatisieren und dokumentieren
* Python-Dateiverwaltung weiter ausbauen
* Weitere Python-Module für Systemadministration kennenlernen
* Linux-Sicherheit und Benutzerverwaltung vertiefen
* Hardware-Wissen weiter ausbauen
* Optimierte Lernstrategien langfristig in den Lernalltag integrieren

