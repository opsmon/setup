#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
EXTENSIONS_FILE="${PROJECT_DIR}/vscode/extensions.txt"

code_cli=""
if command -v code >/dev/null 2>&1; then
  code_cli="$(command -v code)"
elif [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
  code_cli="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi

if [[ -z "${code_cli}" ]]; then
  printf '[WARN] VS Code CLI not found, skipping extensions installation\n'
  exit 0
fi

run_code_quietly() {
  "${code_cli}" "$@" 2>&1 |
    sed \
      -e '/\[DEP0169\] DeprecationWarning: url\.parse()/d' \
      -e '/Use Code --trace-deprecation .* to show where the warning was created/d'
  return "${PIPESTATUS[0]}"
}

installed_extensions="$("${code_cli}" --list-extensions 2>/dev/null || true)"
while IFS= read -r extension || [[ -n "${extension}" ]]; do
  [[ -z "${extension}" || "${extension}" == \#* ]] && continue

  if printf '%s\n' "${installed_extensions}" | grep -Fxiq "${extension}"; then
    printf '[INFO] VS Code extension already installed: %s\n' "${extension}"
  elif ((DRY_RUN)); then
    printf '[DRY-RUN] Would install VS Code extension: %s\n' "${extension}"
  else
    printf '[INFO] Installing VS Code extension: %s\n' "${extension}"
    if ! run_code_quietly --install-extension "${extension}"; then
      printf '[WARN] VS Code extension installation failed: %s\n' "${extension}" >&2
    fi
  fi
done <"${EXTENSIONS_FILE}"

printf '[SUCCESS] VS Code extensions are ready\n'
