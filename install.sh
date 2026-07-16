#!/usr/bin/env bash

set -Eeuo pipefail

REPOSITORY="opsmon/setup"
BRANCH="main"
DRY_RUN=0
current_step=""
current_command=""

started_at="$(date '+%Y-%m-%d %H:%M:%S %z')"
started_epoch="$(date '+%s')"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh              Run full setup
  ./install.sh --dry-run    Show planned actions
  ./install.sh --help       Show help
EOF
}

for argument in "$@"; do
  case "${argument}" in
    --dry-run) DRY_RUN=1 ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf '[ERROR] Unknown option: %s\n\n' "${argument}" >&2
      usage >&2
      exit 1
      ;;
  esac
done

log() {
  printf '[INFO] %s\n' "$1"
}

warn() {
  printf '[WARN] %s\n' "$1"
}

success() {
  printf '[SUCCESS] %s\n' "$1"
}

error() {
  printf '[ERROR] %s\n' "$1" >&2
}

log_detail() {
  printf '[INFO]   %s: %s\n' "$1" "$2"
}

run_step() {
  local step_name="$1"
  local step_command
  local step_started_epoch
  local step_finished_epoch
  shift
  step_command="$*"

  log "Starting: ${step_name}"
  log_detail "Command" "${step_command}"
  current_step="${step_name}"
  current_command="${step_command}"
  step_started_epoch="$(date '+%s')"
  "$@"
  step_finished_epoch="$(date '+%s')"
  current_step=""
  current_command=""
  success "Finished: ${step_name} ($((step_finished_epoch - step_started_epoch))s)"
}

on_error() {
  local status="$1"
  local line="$2"

  if [[ -n "${current_step}" ]]; then
    error "Setup failed during: ${current_step}"
    error "Failed command: ${current_command}"
  else
    error "Setup failed at line ${line}"
  fi
  error "Exit status: ${status}"
  error "Check the log above for the command output before this error."
}

trap 'on_error $? ${LINENO}' ERR

log "macOS setup started"
log_detail "Started at" "${started_at}"
log_detail "Bash version" "${BASH_VERSION}"
log_detail "Dry run" "${DRY_RUN}"
log_detail "Arguments" "$*"

script_source="${BASH_SOURCE[0]:-}"
if [[ -n "${script_source}" && -f "${script_source}" ]]; then
  PROJECT_DIR="$(cd "$(dirname "${script_source}")" && pwd)"
else
  PROJECT_DIR=""
fi

log_detail "Script source" "${script_source:-remote stdin}"
log_detail "Project directory" "${PROJECT_DIR:-not available yet}"

if [[ -z "${PROJECT_DIR}" || ! -f "${PROJECT_DIR}/Brewfile" ]]; then
  log "Remote mode detected; downloading ${REPOSITORY}"
  temporary_dir="$(mktemp -d)"
  log_detail "Temporary directory" "${temporary_dir}"
  trap 'rm -rf "${temporary_dir}"' EXIT
  archive_url="https://github.com/${REPOSITORY}/archive/refs/heads/${BRANCH}.tar.gz"
  log_detail "Archive URL" "${archive_url}"
  log "Downloading and extracting setup archive"
  curl -fsSL "${archive_url}" | tar -xz -C "${temporary_dir}"
  downloaded_dir="${temporary_dir}/setup-${BRANCH}"
  log_detail "Downloaded directory" "${downloaded_dir}"
  log "Re-running installer from downloaded archive"
  set +e
  if ((DRY_RUN)); then
    /bin/bash "${downloaded_dir}/install.sh" --dry-run
  else
    /bin/bash "${downloaded_dir}/install.sh"
  fi
  remote_status="$?"
  set -e
  if ((remote_status != 0)); then
    error "Downloaded installer failed with exit status ${remote_status}"
  fi
  trap - ERR
  exit "${remote_status}"
fi

export PROJECT_DIR
export DRY_RUN
export BACKUP_DIR="${HOME}/.macos-setup-backup/$(date +%Y%m%d-%H%M%S)"

log_detail "Backup directory" "${BACKUP_DIR}"
log_detail "Current directory" "$(pwd)"
log_detail "PATH" "${PATH}"
if command -v sw_vers >/dev/null 2>&1; then
  log_detail "macOS version" "$(sw_vers -productVersion)"
fi
log_detail "Machine architecture" "$(uname -m)"

run_step "Checking macOS and developer tools" "${PROJECT_DIR}/scripts/check-system.sh"

run_step "Checking Homebrew" "${PROJECT_DIR}/scripts/install-brew.sh"

if command -v brew >/dev/null 2>&1; then
  log_detail "Homebrew command" "$(command -v brew)"
  log "Loading Homebrew shell environment from PATH"
  eval "$(brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  log_detail "Homebrew command" "/opt/homebrew/bin/brew"
  log "Loading Homebrew shell environment from /opt/homebrew"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  log_detail "Homebrew command" "/usr/local/bin/brew"
  log "Loading Homebrew shell environment from /usr/local"
  eval "$(/usr/local/bin/brew shellenv)"
elif ((DRY_RUN)); then
  log "Homebrew would be added to PATH after installation"
else
  warn "Homebrew command was not found after install-brew.sh"
fi

run_step "Installing packages from Brewfile" "${PROJECT_DIR}/scripts/install-packages.sh"

run_step "Installing Oh My Zsh and plugins" "${PROJECT_DIR}/scripts/install-oh-my-zsh.sh"

run_step "Installing managed dotfiles" "${PROJECT_DIR}/scripts/link-dotfiles.sh"

run_step "Installing VS Code extensions" "${PROJECT_DIR}/scripts/install-vscode-extensions.sh"

if ((DRY_RUN)); then
  log "macOS defaults would be offered as an optional step"
elif [[ -t 0 ]]; then
  answer=""
  log "Prompting for optional macOS defaults"
  read -r -p "Do you want to apply macOS defaults? [y/N] " answer || true
  if [[ "${answer}" =~ ^[Yy]$ ]]; then
    run_step "Applying macOS defaults" "${PROJECT_DIR}/scripts/macos-defaults.sh"
  else
    log "Skipping macOS defaults"
  fi
else
  log "Non-interactive session: skipping optional macOS defaults"
fi

success "macOS setup completed"
log_detail "Finished at" "$(date '+%Y-%m-%d %H:%M:%S %z')"
log_detail "Total duration" "$(($(date '+%s') - started_epoch))s"
log "Open a new terminal session to load the new shell configuration"
