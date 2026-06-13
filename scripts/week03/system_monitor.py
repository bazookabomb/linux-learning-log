import subprocess

result = subprocess.run(
    ["whoami"],
    capture_output=True,
    text=True
)
whoami = result.stdout.strip()

result = subprocess.run(
    ["hostname"],
    capture_output=True,
    text=True
)
hostname = result.stdout.strip()

result = subprocess.run(
    ["uptime"],
    capture_output=True,
    text=True
)
uptime = result.stdout.strip()

result = subprocess.run(
    ["free", "-h"],
    capture_output=True,
    text=True
)
memory = result.stdout

result = subprocess.run(
    ["df", "-h"],
    capture_output=True,
    text=True
)
disk = result.stdout

print(f"""
=== SYSTEM MONITOR ===

Benutzer: {whoami}
Hostname: {hostname}

Uptime:
{uptime}

Speicher:
{memory}

Festplatte:
{disk}
""")
