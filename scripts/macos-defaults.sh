#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf '[ERROR] macOS defaults can only be applied on macOS.\n' >&2
  exit 1
fi

if ((DRY_RUN)); then
  printf '[DRY-RUN] Would show hidden files and filename extensions in Finder\n'
  printf '[DRY-RUN] Would configure faster keyboard repeat\n'
  exit 0
fi

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
killall Finder >/dev/null 2>&1 || true

printf '[SUCCESS] macOS defaults applied\n'

