#!/usr/bin/env python3
"""Linux Log Analyzer (Python)

Erfasst System- und Journal-Logs analog zu log-analyzer.sh
Options: -o out_dir, -s SINCE, -n LINES, -c (compress)
"""

from __future__ import annotations

import argparse
import datetime
import os
import shlex
import shutil
import socket
import subprocess
import tarfile
from pathlib import Path


def run_cmd(cmd: list[str]) -> str:
    try:
        return subprocess.check_output(cmd, stderr=subprocess.STDOUT, text=True)
    except Exception as e:
        return f"ERROR running {' '.join(cmd)}:\n{e}\n"


def write_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def append_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(content)


def dogtail(file: Path, lines: int) -> str:
    if not file.exists():
        return ""
    try:
        return subprocess.check_output(["tail", "-n", str(lines), str(file)], text=True)
    except Exception:
        try:
            return file.read_text(encoding="utf-8")
        except Exception:
            return ""


def main() -> int:
    parser = argparse.ArgumentParser(description="Linux Log Analyzer (Python)")
    parser.add_argument("-o", "--out", default=None, help="Zielordner (default: logs_<timestamp>)")
    parser.add_argument("-s", "--since", default="-1 hour", help="Zeitfilter für journalctl (z.B. '1 hour ago' oder '2026-07-06')")
    parser.add_argument("-n", "--lines", type=int, default=1000, help="Anzahl Zeilen für klassische Logfiles")
    parser.add_argument("-c", "--compress", action="store_true", help="Ergebnis als tar.gz packen")
    args = parser.parse_args()

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    out_dir = Path(args.out) if args.out else Path(f"logs_{timestamp}")
    out_dir.mkdir(parents=True, exist_ok=True)

    summary = out_dir / "summary.txt"
    write_file(summary, f"Linux Log Analyzer\nDatum: {datetime.datetime.now()}\nHostname: {socket.gethostname()}\nSince: {args.since}\nLines: {args.lines}\n")

    # systemctl --failed
    sys_failed = out_dir / "systemctl_failed.txt"
    if shutil.which("systemctl"):
        append_file(sys_failed, run_cmd(["systemctl", "--failed", "--no-pager"]))
    else:
        append_file(sys_failed, "systemctl nicht vorhanden\n")

    # journal errors
    journal_errors = out_dir / "journal_errors.txt"
    if shutil.which("journalctl"):
        append_file(journal_errors, run_cmd(["journalctl", "--since", args.since, "-p", "err", "--no-pager"]))
    else:
        append_file(journal_errors, "journalctl nicht vorhanden\n")

    # journal warnings
    journal_warnings = out_dir / "journal_warnings.txt"
    if shutil.which("journalctl"):
        append_file(journal_warnings, run_cmd(["journalctl", "--since", args.since, "-p", "warning", "--no-pager"]))

    # kernel logs
    kernel_warnings = out_dir / "kernel_warnings.txt"
    if shutil.which("journalctl"):
        append_file(kernel_warnings, run_cmd(["journalctl", "-k", "--since", args.since, "-p", "warning", "--no-pager"]))
    # dmesg tail
    try:
        append_file(kernel_warnings, run_cmd(["dmesg"])[:])
    except Exception:
        pass

    # OOM
    oom = out_dir / "oom.txt"
    if shutil.which("journalctl"):
        try:
            out = run_cmd(["journalctl", "--since", args.since, "--no-pager"]) or ""
            lines = "\n".join([l for l in out.splitlines() if "out of memory" in l.lower()])
            append_file(oom, lines + ("\n" if lines else ""))
        except Exception:
            pass

    # classic logfiles
    syslog = Path("/var/log/syslog")
    messages = Path("/var/log/messages")
    authlog = Path("/var/log/auth.log")

    if syslog.exists():
        write_file(out_dir / "syslog.txt", f"Kopiere /var/log/syslog (letzte {args.lines} Zeilen)\n")
        append_file(out_dir / "syslog.txt", dogtail(syslog, args.lines))
    elif messages.exists():
        write_file(out_dir / "messages.txt", f"Kopiere /var/log/messages (letzte {args.lines} Zeilen)\n")
        append_file(out_dir / "messages.txt", dogtail(messages, args.lines))

    if authlog.exists():
        write_file(out_dir / "auth.log.txt", f"Kopiere /var/log/auth.log (letzte {args.lines} Zeilen)\n")
        append_file(out_dir / "auth.log.txt", dogtail(authlog, args.lines))

    # active services
    active_services = out_dir / "active_services.txt"
    if shutil.which("systemctl"):
        append_file(active_services, run_cmd(["systemctl", "list-units", "--type=service", "--state=running", "--no-pager"]))

    # host overview
    host_overview = out_dir / "host_overview.txt"
    append_file(host_overview, run_cmd(["uname", "-a"]))
    append_file(host_overview, run_cmd(["uptime"]))
    if shutil.which("free"):
        append_file(host_overview, run_cmd(["free", "-h"]))
    if shutil.which("df"):
        append_file(host_overview, run_cmd(["df", "-h"]))

    # unit errors (best-effort)
    unit_errors = out_dir / "unit_errors.txt"
    if shutil.which("journalctl"):
        append_file(unit_errors, run_cmd(["journalctl", "--since", args.since, "-p", "err", "--no-pager"]))

    print(f"Fertig. Ergebnisse in: {out_dir}")

    if args.compress:
        tar_path = out_dir.with_suffix(".tar.gz")
        with tarfile.open(tar_path, "w:gz") as tar:
            tar.add(out_dir, arcname=out_dir.name)
        print(f"Archiv erstellt: {tar_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

