#!/usr/bin/env python3
import argparse, time, datetime, subprocess, logging, sys
try:
    import psutil
except Exception as e:
    print("psutil fehlt. Installiere mit 'pip3 install psutil' oder Paketmanager.", file=sys.stderr)
    raise

def now():
    return datetime.datetime.now().isoformat(sep=' ', timespec='seconds')

def restart_service(service, dry_run=False):
    cmd = ["sudo", "systemctl", "restart", service]
    if dry_run:
        return (None, f"DRY-RUN: {' '.join(cmd)}")
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        return (r.returncode, r.stdout.strip() + ("\n" + r.stderr.strip() if r.stderr else ""))
    except Exception as e:
        return (-1, f"exception: {e}")

def monitor(args):
    logging.basicConfig(filename=args.log, level=logging.INFO,
                        format="%(asctime)s %(levelname)s %(message)s",
                        datefmt="%Y-%m-%d %H:%M:%S")
    logging.info("Monitoring gestartet (cpu=%s%% mem=%s%% interval=%ss) service=%s restart=%s",
                 args.cpu_threshold, args.mem_threshold, args.interval, args.service or "-", args.restart)

    try:
        while True:
            cpu = psutil.cpu_percent(interval=1)
            mem = psutil.virtual_memory().percent
            if cpu >= args.cpu_threshold or mem >= args.mem_threshold:
                msg = f"ALARM: cpu={cpu:.1f}% mem={mem:.1f}% (thr cpu={args.cpu_threshold} mem={args.mem_threshold})"
                logging.warning(msg)
                if args.service and args.restart:
                    rc, out = restart_service(args.service, dry_run=args.dry_run)
                    logging.info("Restart attempt service=%s rc=%s output=%s", args.service, rc, out)
            else:
                logging.debug("OK: cpu=%s mem=%s", cpu, mem)
            to_sleep = max(0, args.interval - 1)
            if to_sleep:
                time.sleep(to_sleep)
    except KeyboardInterrupt:
        logging.info("Monitoring manuell beendet (KeyboardInterrupt)")
    except Exception as e:
        logging.exception("Fehler im Monitoring: %s", e)

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Kleines Monitor-Skript: CPU/Memory prüfen und Service neu starten")
    p.add_argument("--service", "-s", help="Service-Name (z.B. test-service) zum Neustarten", default=None)
    p.add_argument("--cpu-threshold", type=float, default=80.0, help="CPU-Schwelle in %% (default 80)")
    p.add_argument("--mem-threshold", type=float, default=80.0, help="Memory-Schwelle in %% (default 80)")
    p.add_argument("--interval", "-i", type=int, default=10, help="Prüfintervall in Sekunden (default 10)")
    p.add_argument("--log", default="/var/log/test-monitor.log", help="Log-Datei (default /var/log/test-monitor.log)")
    p.add_argument("--restart", action="store_true", help="Service neu starten, falls Schwelle überschritten")
    p.add_argument("--dry-run", action="store_true", help="Keinen echten Restart ausführen (nur Protokoll)")
    args = p.parse_args()
    monitor(args)
