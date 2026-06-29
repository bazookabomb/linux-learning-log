# Woche 05 - Benutzerverwaltung, Docker & Netzwerkgrundlagen Learning Log

## Lernziel

Die Linux-Benutzerverwaltung für Mehr-User-System kennenlernen, Benutzer und Gruppen sicher verwalten, den Umgang mit administrativen Rechten verstehen, Erfahrungen mit Docker unter Linux sammeln sowie grundlegende Netzwerkdiagnose-Befehle anwenden.

---

## Inhalte

* Benutzer- und Gruppenverwaltung

  * Benutzer anlegen und verwalten
  * Gruppen erstellen und bearbeiten
  * Benutzer Gruppen zuordnen
  * Unterschiede zwischen normalen Benutzern und Root verstanden

* Sudo und Privilegien

  * Bedeutung von Root-Rechten
  * Verwendung von `sudo`
  * Sicherheitsaspekte bei administrativen Berechtigungen
  * Prinzip der geringsten Rechte kennengelernt

* Docker-Grundlagen

  * Docker unter Linux installiert
  * Container-Konzept kennengelernt
  * Erste Container gestartet und getestet
  * Unterschied zwischen Images und Containern verstanden

* Linux-Netzwerkgrundlagen

  * Routingtabelle anzeigen mit `ip route`
  * DNS-Abfragen mit `nslookup`
  * DNS-Informationen detailliert mit `dig`
  * Offene Ports und Netzwerkdienste mit `ss -tuln` analysiert

* Linux-Allgemeinwissen

  * Linux-Quiz bearbeitet
  * Vorhandenes Wissen überprüft und gefestigt

---

## Praxis

* Mehrere Benutzerkonten erstellt und verwaltet
* Neue Gruppen angelegt und Benutzer den Gruppen zugewiesen
* Benutzerrechte mit `sudo` getestet
* Docker erfolgreich installiert
* Erste Container gestartet und deren Funktionsweise ausprobiert
* Routinginformationen des Systems untersucht
* DNS-Auflösungen mit `nslookup` und `dig` verglichen
* Netzwerkverbindungen und offene Ports mit `ss -tuln` analysiert
* Linux-Allgemeinwissensquiz zur Wissenskontrolle durchgeführt

---

## Erkenntnisse

* Benutzer und Gruppen bilden die Grundlage der Rechteverwaltung unter Linux.
* `sudo` ermöglicht eine sichere Vergabe administrativer Rechte, ohne dauerhaft als Root arbeiten zu müssen.
* Docker isoliert Anwendungen in Containern und erleichtert eine reproduzierbare Ausführung.
* Images dienen als Vorlage für Container.
* Netzwerkbefehle wie `ip route`, `nslookup`, `dig` und `ss` helfen bei der Fehlersuche und Analyse von Netzwerkproblemen.
* Regelmäßige Wissensüberprüfung unterstützt den nachhaltigen Lernerfolg.

---

## Probleme

* Die Unterschiede zwischen Benutzern, Gruppen und administrativen Berechtigungen mussten zunächst verinnerlicht werden.
* Die Ausgabe der Netzwerkbefehle erforderte etwas Übung, um sie richtig zu interpretieren.

---

## Nächste Schritte

* Netzwerkdiagnose mit weiteren Werkzeugen wie `ping`, `traceroute` und `curl` erweitern
* Netzwerkmonitor mit Python oder bash
* Firewall ufw 
* Systemprotokolle analysieren und Fehler mithilfe von Logdateien finden
* kleine Linux- Server mit Docker simulieren
* kleine Netzwerkprojekte z. B. einen HTTP-Server mit Python starten und per curl testen
