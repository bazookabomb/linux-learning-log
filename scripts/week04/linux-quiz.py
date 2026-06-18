#!/usr/bin/env python3
import random
import time
import json
import os

# 🎨 Farben
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
RESET = "\033[0m"

HIGHSCORE_FILE = "highscore.json"

# 🧠 Fallback-Fragen (wenn keine Datei existiert)
fragen = [
    {"frage": "Was macht 'ls'?", "optionen": ["A: listet Dateien", "B: löscht Dateien", "C: kopiert Dateien", "D: zeigt Prozesse"], "antwort": "A", "kategorie": "Bash"},
    {"frage": "Was ist ein Symlink?", "optionen": ["A: Kopie", "B: Verknüpfung", "C: Prozess", "D: Kernel Modul"], "antwort": "B", "kategorie": "Dateisystem"},
    {"frage": "Was macht 'df'?", "optionen": ["A: Prozesse", "B: Speicherplatz", "C: Netzwerk", "D: RAM"], "antwort": "B", "kategorie": "System"},
    {"frage": "Was bedeutet '||' in Bash?", "optionen": ["A: UND", "B: ODER bei Fehler", "C: Pipe", "D: Loop"], "antwort": "B", "kategorie": "Bash"},
]

# 📂 Highscore laden
def load_highscore():
    if not os.path.exists(HIGHSCORE_FILE):
        return 0
    with open(HIGHSCORE_FILE, "r") as f:
        return json.load(f).get("score", 0)

# 💾 Highscore speichern
def save_highscore(score):
    with open(HIGHSCORE_FILE, "w") as f:
        json.dump({"score": score}, f)

# ⏱️ Timer-Funktion
def timed_input(prompt, timeout=10):
    print(prompt)
    start = time.time()
    answer = input("> ").strip().upper()
    duration = time.time() - start

    if duration > timeout:
        return None, duration
    return answer, duration


def main():
    random.shuffle(fragen)

    punkte = 0
    leben = 3
    highscore = load_highscore()

    print(f"{BLUE}🎮 Linux Quiz Level 4 – PRO MODE{RESET}")
    print(f"🏆 Highscore: {highscore}")
    print("❤️ Du hast 3 Leben | ⏱️ 10 Sekunden pro Frage\n")

    for i, f in enumerate(fragen, 1):

        if leben <= 0:
            print(f"{RED}💀 Game Over! Keine Leben mehr.{RESET}")
            break

        print(f"{YELLOW}Frage {i} [{f['kategorie']}]{RESET}")
        print(f["frage"])
        for opt in f["optionen"]:
            print(opt)

        answer, duration = timed_input("Deine Antwort (A/B/C/D):", timeout=10)

        if answer is None:
            leben -= 1
            print(f"{RED}⏱️ Zeit abgelaufen! -1 Leben ({leben} übrig){RESET}\n")
            continue

        if answer == f["antwort"]:
            punkte += 1
            print(f"{GREEN}✅ Richtig! ({duration:.1f}s){RESET}\n")
        else:
            leben -= 1
            print(f"{RED}❌ Falsch! -1 Leben ({leben} übrig){RESET}\n")

    print(f"{BLUE}🏁 Spiel beendet!{RESET}")
    print(f"📊 Punkte: {punkte}")

    if punkte > highscore:
        print(f"{GREEN}🏆 Neuer Highscore!{RESET}")
        save_highscore(punkte)
    else:
        print(f"🏆 Highscore bleibt: {highscore}")


if __name__ == "__main__":
    main()
