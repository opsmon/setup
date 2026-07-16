#!/usr/bin/env bash

set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TERRAFORM_TAP="hashicorp/tap"
TERRAFORM_FORMULA="hashicorp/tap/terraform"
TERRAFORM_ATTEMPTS=3
BREW_ATTEMPTS=3

run_brew_with_retries() {
  local attempt=1
  local output_file
  output_file="$(mktemp)"

  while ((attempt <= BREW_ATTEMPTS)); do
    if ((attempt > 1)); then
      printf '[INFO] Retrying brew command (attempt %s/%s): brew %s\n' \
        "${attempt}" "${BREW_ATTEMPTS}" "$*"
    fi

    if brew "$@" 2>&1 | tee "${output_file}"; then
      rm -f "${output_file}"
      return 0
    fi

    if ! grep -Eiq 'already locked|process has already locked|please wait for it to finish' "${output_file}"; then
      rm -f "${output_file}"
      return 1
    fi

    if ((attempt == BREW_ATTEMPTS)); then
      printf '[ERROR] Homebrew is still locked after %s attempts.\n' "${BREW_ATTEMPTS}" >&2
      printf '[ERROR] Close other brew processes or wait, then rerun install.sh.\n' >&2
      rm -f "${output_file}"
      return 1
    fi

    printf '[WARN] Homebrew lock detected; waiting 20 seconds before retry.\n' >&2
    sleep 20
    attempt=$((attempt + 1))
  done

  rm -f "${output_file}"
  return 1
}

if ((DRY_RUN)); then
  printf '[DRY-RUN] Would run: brew update\n'
  printf '[DRY-RUN] Would run: brew bundle --file=%s/Brewfile\n' "${PROJECT_DIR}"
  printf '[DRY-RUN] Would tap optional repository if needed: %s\n' "${TERRAFORM_TAP}"
  printf '[DRY-RUN] Would trust optional formula if needed: %s\n' "${TERRAFORM_FORMULA}"
  printf '[DRY-RUN] Would install optional package: %s\n' "${TERRAFORM_FORMULA}"
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  printf '[ERROR] Homebrew is not available in PATH.\n' >&2
  exit 1
fi

run_brew_with_retries update
run_brew_with_retries bundle --file="${PROJECT_DIR}/Brewfile"

if command -v terraform >/dev/null 2>&1; then
  printf '[INFO] Terraform already installed at %s\n' "$(command -v terraform)"
else
  if ! brew tap | grep -Fxq "${TERRAFORM_TAP}"; then
    printf '[INFO] Tapping optional repository: %s\n' "${TERRAFORM_TAP}"
    run_brew_with_retries tap "${TERRAFORM_TAP}" || true
  fi

  if brew help trust >/dev/null 2>&1; then
    printf '[INFO] Trusting optional Homebrew formula: %s\n' "${TERRAFORM_FORMULA}"
    brew trust --formula "${TERRAFORM_FORMULA}" || true
  fi

  terraform_attempt=1
  while ((terraform_attempt <= TERRAFORM_ATTEMPTS)); do
    terraform_output="$(mktemp)"
    printf '[INFO] Installing optional package %s (attempt %s/%s)\n' \
      "${TERRAFORM_FORMULA}" "${terraform_attempt}" "${TERRAFORM_ATTEMPTS}"
    if brew install "${TERRAFORM_FORMULA}" 2>&1 | tee "${terraform_output}"; then
      rm -f "${terraform_output}"
      printf '[SUCCESS] Terraform is ready\n'
      break
    fi

    if grep -Eiq 'Failed to download resource|requested URL returned error: 404|Download failed: .*terraform' \
      "${terraform_output}"; then
      printf '[WARN] Terraform download is unavailable right now; continuing setup.\n' >&2
      printf '[WARN] Try later: brew install %s\n' "${TERRAFORM_FORMULA}" >&2
      rm -f "${terraform_output}"
      break
    fi

    if ((terraform_attempt == TERRAFORM_ATTEMPTS)); then
      printf '[WARN] Terraform installation failed after %s attempts; continuing setup.\n' \
        "${TERRAFORM_ATTEMPTS}" >&2
      printf '[WARN] Try later: brew install %s\n' "${TERRAFORM_FORMULA}" >&2
      rm -f "${terraform_output}"
      break
    fi

    terraform_attempt=$((terraform_attempt + 1))
    if grep -Eiq 'already locked|process has already locked|please wait for it to finish' \
      "${terraform_output}"; then
      printf '[WARN] Homebrew lock detected during Terraform install; retrying in 20 seconds.\n' >&2
      sleep 20
    else
      printf '[WARN] Terraform installation failed; retrying in 5 seconds.\n' >&2
      sleep 5
    fi
    rm -f "${terraform_output}"
  done
fi

printf '[SUCCESS] Homebrew packages are ready\n'
