#!/usr/bin/env python3

import argparse
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.request
from pathlib import Path


REPOSITORY = "opsmon/setup"
BRANCH = "main"


def log(message):
    print(f"[INFO] {message}", flush=True)


def error(message):
    print(f"[ERROR] {message}", file=sys.stderr, flush=True)


def usage():
    print(
        """Usage:
  python3 install.py              Run full setup
  python3 install.py --dry-run    Show planned actions
  python3 install.py --help       Show help

Remote:
  curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.py | python3 -
  curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.py | python3 - --dry-run"""
    )


def parse_args(argv):
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--help", "-h", action="store_true")
    args, unknown = parser.parse_known_args(argv)
    if unknown:
        error(f"Unknown option: {unknown[0]}")
        usage()
        return None, 1
    if args.help:
        usage()
        return None, 0
    return args, None


def local_project_dir():
    script_path = globals().get("__file__", "")
    if not script_path or script_path.startswith("<"):
        return None

    project_dir = Path(script_path).resolve().parent
    if (project_dir / "Brewfile").is_file() and (project_dir / "install.sh").is_file():
        return project_dir
    return None


def safe_extract(archive, destination):
    destination = destination.resolve()
    for member in archive.getmembers():
        member_path = (destination / member.name).resolve()
        if destination != member_path and destination not in member_path.parents:
            raise RuntimeError(f"Archive member escapes destination: {member.name}")
    archive.extractall(destination)


def download_project(target_dir):
    archive_url = f"https://github.com/{REPOSITORY}/archive/refs/heads/{BRANCH}.tar.gz"
    archive_path = target_dir / "setup.tar.gz"

    log(f"Downloading {archive_url}")
    with urllib.request.urlopen(archive_url, timeout=120) as response:
        with archive_path.open("wb") as archive_file:
            shutil.copyfileobj(response, archive_file)

    log("Extracting setup archive")
    with tarfile.open(archive_path, "r:gz") as archive:
        safe_extract(archive, target_dir)

    downloaded_dir = target_dir / f"setup-{BRANCH}"
    if not downloaded_dir.is_dir():
        raise RuntimeError(f"Downloaded directory was not found: {downloaded_dir}")
    return downloaded_dir


def run_installer(project_dir, dry_run):
    installer = project_dir / "install.sh"
    command = ["/bin/bash", str(installer)]
    if dry_run:
        command.append("--dry-run")

    log(f"Running {' '.join(command)}")
    return subprocess.run(command, check=False).returncode


def main(argv):
    args, early_status = parse_args(argv)
    if early_status is not None:
        return early_status

    project_dir = local_project_dir()
    if project_dir is not None:
        log(f"Local mode detected: {project_dir}")
        return run_installer(project_dir, args.dry_run)

    log(f"Remote mode detected; downloading {REPOSITORY}")
    with tempfile.TemporaryDirectory(prefix="macos-setup-") as temp_dir_name:
        project_dir = download_project(Path(temp_dir_name))
        return run_installer(project_dir, args.dry_run)


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        error("Interrupted")
        sys.exit(130)
    except Exception as exc:
        error(str(exc))
        sys.exit(1)
