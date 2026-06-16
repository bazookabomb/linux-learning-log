import os
import time

print("Service gestartet")
print(f"Benutzer: {os.getenv('USER')}")
print(f"Arbeitsverzeichnis: {os.getcwd()}")

counter = 0

while True:
    counter += 1
    print(f"Durchlauf {counter}")

    if counter == 5:
        raise Exception("Boom!")

    time.sleep(2)