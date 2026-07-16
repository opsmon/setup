#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${ROOT_DIR}/system-report"

mkdir -p "${REPORT_DIR}"

log() {
  printf '[INFO] %s\n' "$1"
}

write_command() {
  local command_name="$1"
  shift

  printf '\n$ %s\n' "${command_name}" >>"${REPORT_DIR}/system.txt"
  "$@" >>"${REPORT_DIR}/system.txt" 2>&1 || true
}

safe_filter() {
  grep -Eiv '(secret|token|password|passwd|credential|authorization|signingkey|private.?key|api.?key|access.?key|client.?secret|cookie)' || true
}

tool_version() {
  local tool="$1"

  case "${tool}" in
    kubectl) kubectl version --client 2>/dev/null | head -n 1 ;;
    helm) helm version --short 2>/dev/null | head -n 1 ;;
    go) go version 2>/dev/null | head -n 1 ;;
    *) "${tool}" --version 2>/dev/null | head -n 1 ;;
  esac
}

log "Collecting system information"
: >"${REPORT_DIR}/system.txt"
write_command "sw_vers" sw_vers
write_command "uname -a" uname -a
write_command "arch" arch
write_command "hostname" hostname
write_command "whoami" whoami

{
  printf '\nSystem profile\n'
  case "$(uname -m)" in
    arm64) printf 'Architecture: Apple Silicon\n' ;;
    x86_64) printf 'Architecture: Intel\n' ;;
    *) printf 'Architecture: Unknown (%s)\n' "$(uname -m)" ;;
  esac
  printf 'Current shell: %s\n' "${SHELL:-unknown}"
  printf 'zsh version: %s\n' "$(zsh --version 2>/dev/null || printf 'not installed')"
  printf 'git version: %s\n' "$(git --version 2>/dev/null || printf 'not installed')"
  if command -v brew >/dev/null 2>&1; then
    printf 'Homebrew executable: %s\n' "$(command -v brew)"
    printf 'Homebrew prefix: %s\n' "$(brew --prefix 2>/dev/null || printf 'unknown')"
  else
    printf 'Homebrew: not installed\n'
  fi
} >>"${REPORT_DIR}/system.txt"

log "Collecting Homebrew package lists"
if command -v brew >/dev/null 2>&1; then
  : >"${REPORT_DIR}/brew-bundle.log"
  HOMEBREW_NO_AUTO_UPDATE=1 brew leaves >"${REPORT_DIR}/brew-leaves.txt" \
    2>>"${REPORT_DIR}/brew-bundle.log" || true
  HOMEBREW_NO_AUTO_UPDATE=1 brew list --cask >"${REPORT_DIR}/brew-casks.txt" \
    2>>"${REPORT_DIR}/brew-bundle.log" || true
  HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --file="${REPORT_DIR}/Brewfile.current" --force \
    >>"${REPORT_DIR}/brew-bundle.log" 2>&1 || true

  if [[ ! -f "${REPORT_DIR}/Brewfile.current" ]]; then
    {
      printf '# Fallback generated from local package lists.\n'
      while IFS= read -r formula; do
        [[ -n "${formula}" ]] && printf 'brew "%s"\n' "${formula}"
      done <"${REPORT_DIR}/brew-leaves.txt"
      while IFS= read -r cask; do
        [[ -n "${cask}" ]] && printf 'cask "%s"\n' "${cask}"
      done <"${REPORT_DIR}/brew-casks.txt"
    } >"${REPORT_DIR}/Brewfile.current"
  fi
else
  printf 'Homebrew is not installed.\n' >"${REPORT_DIR}/brew-leaves.txt"
  printf 'Homebrew is not installed.\n' >"${REPORT_DIR}/brew-casks.txt"
  printf '# Homebrew is not installed.\n' >"${REPORT_DIR}/Brewfile.current"
fi

log "Collecting safe zsh metadata"
{
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    printf 'Oh My Zsh: installed\n'
  else
    printf 'Oh My Zsh: not installed\n'
  fi

  for file in .zshrc .zprofile .zshenv; do
    if [[ -f "${HOME}/${file}" ]]; then
      printf '%s: present (%s bytes)\n' "${file}" "$(wc -c <"${HOME}/${file}" | tr -d ' ')"
    else
      printf '%s: absent\n' "${file}"
    fi
  done
} >"${REPORT_DIR}/zsh.txt"

if [[ -f "${HOME}/.zshrc" ]]; then
  grep -E '^(ZSH_THEME=|plugins=|source[[:space:]]|alias[[:space:]]|export PATH=)' \
    "${HOME}/.zshrc" 2>/dev/null |
    safe_filter |
    sed "s#${HOME}#~#g" >"${REPORT_DIR}/zshrc.safe.txt"
else
  printf '~/.zshrc is absent.\n' >"${REPORT_DIR}/zshrc.safe.txt"
fi

log "Collecting safe Git configuration"
if git config --global --list >/dev/null 2>&1; then
  git config --global --list 2>/dev/null |
    grep -Eiv '(^user\.(name|email)=|credential|signingkey|secret|token|password|passwd|authorization|private.?key|api.?key|access.?key|client.?secret|cookie|^url\..*insteadof=)' \
      >"${REPORT_DIR}/gitconfig.safe.txt" || true
else
  printf 'Global Git config is absent.\n' >"${REPORT_DIR}/gitconfig.safe.txt"
fi

log "Checking CLI tools"
tools=(
  git brew zsh curl wget jq yq fzf rg bat eza tree docker docker-compose
  kubectl helm k9s kind terraform ansible argocd stern kubectx kubens
  go python3 node npm nvm code
)
: >"${REPORT_DIR}/tools.txt"
for tool in "${tools[@]}"; do
  {
    printf '%s\n' "${tool}"
    if command -v "${tool}" >/dev/null 2>&1; then
      printf '  status: installed\n'
      printf '  path: %s\n' "$(command -v "${tool}")"
      version="$(tool_version "${tool}" || true)"
      [[ -n "${version}" ]] && printf '  version: %s\n' "${version}"
    else
      printf '  status: not installed\n'
    fi
  } >>"${REPORT_DIR}/tools.txt"
done

log "Collecting VS Code extensions"
vscode_cli=""
if command -v code >/dev/null 2>&1; then
  vscode_cli="$(command -v code)"
elif [[ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
  vscode_cli="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
elif [[ -x "${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]]; then
  vscode_cli="${HOME}/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi

if [[ -n "${vscode_cli}" ]]; then
  "${vscode_cli}" --list-extensions >"${REPORT_DIR}/vscode-extensions.txt" \
    2>"${REPORT_DIR}/vscode-extensions.log" || true
else
  printf 'VS Code CLI is not installed.\n' >"${REPORT_DIR}/vscode-extensions.txt"
fi

log "Collecting safe SSH metadata"
{
  if [[ -d "${HOME}/.ssh" ]]; then
    printf '~/.ssh: present\n'
    if [[ -f "${HOME}/.ssh/config" ]]; then
      printf 'config: present (contents omitted)\n'
    else
      printf 'config: absent\n'
    fi

    shopt -s nullglob
    public_keys=("${HOME}"/.ssh/*.pub)
    if ((${#public_keys[@]} == 0)); then
      printf 'Public keys: none\n'
    else
      printf 'Public keys and fingerprints:\n'
      for public_key in "${public_keys[@]}"; do
        printf '  %s\n' "$(basename "${public_key}")"
        ssh-keygen -lf "${public_key}" 2>/dev/null | sed 's/^/    /' || true
      done
    fi
    shopt -u nullglob
  else
    printf '~/.ssh: absent\n'
  fi
} >"${REPORT_DIR}/ssh.safe.txt"

log "Collecting dotfile presence and sizes"
: >"${REPORT_DIR}/dotfiles.txt"
for file in .zshrc .zprofile .zshenv .gitconfig .aliases .exports .functions .tmux.conf; do
  if [[ -f "${HOME}/${file}" ]]; then
    printf '%s: present (%s bytes)\n' "${file}" "$(wc -c <"${HOME}/${file}" | tr -d ' ')" \
      >>"${REPORT_DIR}/dotfiles.txt"
  else
    printf '%s: absent\n' "${file}" >>"${REPORT_DIR}/dotfiles.txt"
  fi
done

rm -f "${REPORT_DIR}/brew-bundle.log"
rm -f "${REPORT_DIR}/vscode-extensions.log"
log "Report saved to ${REPORT_DIR}"
