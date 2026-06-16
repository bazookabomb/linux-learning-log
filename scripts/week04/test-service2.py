import time
import os
import signal
import sys

running = True

def handle_sigterm(signum, frame):
    global running
    print("SIGTERM erhalten → beende sauber...")
    running = False

signal.signal(signal.SIGTERM, handle_sigterm)
signal.signal(signal.SIGINT, handle_sigterm)

print("Service gestartet")
print("PID:", os.getpid())

counter = 0

while running:
    counter += 1
    print(f"Durchlauf {counter}")
    time.sleep(2)

print("Cleanup läuft...")
time.sleep(1)
print("Service sauber beendet")
sys.exit(0)