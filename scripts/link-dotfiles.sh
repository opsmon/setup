#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
BACKUP_DIR="${BACKUP_DIR:-${HOME}/.macos-setup-backup/$(date +%Y%m%d-%H%M%S)}"

install_file() {
  local source="$1"
  local destination="$2"

  if [[ -f "${destination}" && ! -L "${destination}" ]] &&
    cmp -s "${source}" "${destination}"; then
    printf '[INFO] %s is already current\n' "${destination}"
    return
  fi

  if ((DRY_RUN)); then
    [[ -e "${destination}" || -L "${destination}" ]] &&
      printf '[DRY-RUN] Would back up %s to %s\n' "${destination}" "${BACKUP_DIR}"
    printf '[DRY-RUN] Would install %s\n' "${destination}"
    return
  fi

  if [[ -e "${destination}" || -L "${destination}" ]]; then
    mkdir -p "${BACKUP_DIR}"
    cp -pP "${destination}" "${BACKUP_DIR}/$(basename "${destination}")"
    printf '[INFO] Backed up %s\n' "${destination}"
  fi

  mkdir -p "$(dirname "${destination}")"
  [[ -L "${destination}" ]] && rm "${destination}"
  cp "${source}" "${destination}"
  printf '[INFO] Installed %s\n' "${destination}"
}

for filename in .zshrc .aliases .exports .functions; do
  install_file "${PROJECT_DIR}/dotfiles/${filename}" "${HOME}/${filename}"
done

managed_gitconfig="${HOME}/.config/macos-setup/gitconfig"
install_file "${PROJECT_DIR}/dotfiles/.gitconfig" "${managed_gitconfig}"

if git config --global --get-all include.path 2>/dev/null |
  grep -Fxq "${managed_gitconfig}"; then
  printf '[INFO] Managed Git config is already included\n'
elif ((DRY_RUN)); then
  printf '[DRY-RUN] Would include %s from ~/.gitconfig\n' "${managed_gitconfig}"
else
  if [[ -f "${HOME}/.gitconfig" ]]; then
    mkdir -p "${BACKUP_DIR}"
    cp -p "${HOME}/.gitconfig" "${BACKUP_DIR}/.gitconfig"
  fi
  git config --global --add include.path "${managed_gitconfig}"
  printf '[INFO] Included managed Git config without replacing user identity\n'
fi

printf '[SUCCESS] Dotfiles are ready\n'
