import subprocess
from datetime import datetime
import os

def run_command(command):
    result = subprocess.run(
        command,
        capture_output=True,
        text=True
    )
    return result.stdout.strip()

user = run_command(["whoami"])
hostname = run_command(["hostname"])
uptime = run_command(["uptime"])
memory = run_command(["free", "-h"])
disk = run_command(["df", "-h"])
datum = datetime.now().strftime("%Y-%m-%d")
report_file = f"reports/system_report_{datum}.txt"
report = f"""
=== SYSTEM MONITOR ===

Benutzer: {user}
Hostname: {hostname}
Erstellt: {datum}
Uptime:
{uptime}

Speicher:
{memory}

Festplatte:
{disk}
"""

print(report)

os.makedirs("reports", exist_ok=True)
with open(report_file, "w") as f:
    f.write(report)

print(f"Report gespeichert: {report_file}")
