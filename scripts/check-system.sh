#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf '[ERROR] This setup supports macOS only.\n' >&2
  exit 1
fi

printf '[INFO] macOS detected (%s)\n' "$(uname -m)"

if xcode-select -p >/dev/null 2>&1; then
  printf '[INFO] Command Line Tools found\n'
elif ((DRY_RUN)); then
  printf '[DRY-RUN] Would start Command Line Tools installation\n'
else
  printf '[INFO] Starting Command Line Tools installation\n'
  xcode-select --install
  printf '[WARN] Complete the installer, then run install.sh again.\n'
  exit 1
fi

