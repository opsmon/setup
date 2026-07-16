#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

if command -v brew >/dev/null 2>&1; then
  printf '[INFO] Homebrew found at %s\n' "$(command -v brew)"
  exit 0
fi

if [[ -x /opt/homebrew/bin/brew || -x /usr/local/bin/brew ]]; then
  printf '[INFO] Homebrew is installed and will be added to PATH\n'
  exit 0
fi

if ((DRY_RUN)); then
  printf '[DRY-RUN] Would install Homebrew in non-interactive mode\n'
  exit 0
fi

printf '[INFO] Installing Homebrew\n'
NONINTERACTIVE=1 /bin/bash -c \
  "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
printf '[SUCCESS] Homebrew installed\n'

