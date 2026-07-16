#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
ZSH_DIR="${ZSH:-${HOME}/.oh-my-zsh}"
CUSTOM_DIR="${ZSH_CUSTOM:-${ZSH_DIR}/custom}"

clone_if_missing() {
  local repository="$1"
  local destination="$2"
  local label="$3"

  if [[ -d "${destination}/.git" || -d "${destination}" ]]; then
    printf '[INFO] %s already installed\n' "${label}"
  elif ((DRY_RUN)); then
    printf '[DRY-RUN] Would install %s into %s\n' "${label}" "${destination}"
  else
    git clone --depth=1 "${repository}" "${destination}"
  fi
}

if [[ -d "${ZSH_DIR}" ]]; then
  printf '[INFO] Oh My Zsh already installed\n'
elif ((DRY_RUN)); then
  printf '[DRY-RUN] Would install Oh My Zsh into %s\n' "${ZSH_DIR}"
else
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clone_if_missing \
  "https://github.com/zsh-users/zsh-autosuggestions.git" \
  "${CUSTOM_DIR}/plugins/zsh-autosuggestions" \
  "zsh-autosuggestions"
clone_if_missing \
  "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
  "${CUSTOM_DIR}/plugins/zsh-syntax-highlighting" \
  "zsh-syntax-highlighting"
clone_if_missing \
  "https://github.com/romkatv/powerlevel10k.git" \
  "${CUSTOM_DIR}/themes/powerlevel10k" \
  "powerlevel10k"

printf '[SUCCESS] Zsh components are ready\n'

