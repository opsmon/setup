# macOS Setup

**English** | [Русский](README.ru.md)

A personal bootstrap kit for setting up a fresh Mac for development, DevOps, and
everyday engineering work.

## What It Is

The project installs Homebrew, command-line tools, Docker and Kubernetes tooling,
Terraform, development runtimes, Oh My Zsh, plugins, dotfiles, and VS Code
extensions. The scripts support Apple Silicon and Intel Macs and are safe to run
more than once.

The package list was curated after collecting the current workstation state with
`scripts/collect-current-system.sh`. Useful tools were retained while Homebrew
dependencies, private settings, and secrets were excluded.

## Quick Start

Always review a remote script before running it:

```bash
curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.sh
curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.py
```

Run the setup with Bash:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.sh)"
```

Or run it with Python:

```bash
curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.py | python3 -
```

Or clone it locally:

```bash
git clone https://github.com/opsmon/setup.git
cd setup
./install.sh
```

## Collecting the Current System

The collector records system and CLI versions, Homebrew packages, safe zsh and
Git metadata, public SSH key names and fingerprints, dotfile presence, and VS Code
extensions:

```bash
./scripts/collect-current-system.sh
ls -la system-report/
```

`system-report/` is excluded through `.gitignore`. The collector does not read
private SSH keys, shell history, the complete environment, `known_hosts`,
`.npmrc`, `.pypirc`, or Docker credentials.

## What Gets Installed

- CLI: Git, GitHub CLI, curl, wget, jq, yq, fzf, ripgrep, bat, eza, tmux, zoxide.
- Containers: Docker CLI, Docker Compose, and Docker Desktop.
- Kubernetes: kubectl, Helm, k9s, kind, Argo CD, stern, kubectx/kubens, kustomize.
- Infrastructure: Terraform and Ansible.
- Languages: Python, Go, Node.js, and nvm.
- Applications: iTerm2, VS Code, and Rectangle.
- Shell: Oh My Zsh, autosuggestions, syntax highlighting, and powerlevel10k.

The complete declarative package list is stored in `Brewfile`.

VS Code is installed automatically, so no manual download is required. Docker
Desktop must be opened once after installation.

## Project Structure

```text
.
├── install.sh
├── install.py
├── Brewfile
├── README.md
├── README.ru.md
├── task.md
├── .gitignore
├── dotfiles/
├── scripts/
├── vscode/
└── docs/
```

## Running the Setup

```bash
./install.sh
./install.sh --dry-run
./install.sh --help
python3 install.py
python3 install.py --dry-run
```

`--dry-run` displays planned actions without installing packages or changing
configuration. macOS defaults are never applied automatically: an interactive run
asks for explicit confirmation and defaults to `N`.

## Updating the Environment

Update the repository and run the setup again:

```bash
git pull
./install.sh
```

Homebrew updates packages, installed components are skipped, and identical
dotfiles are not copied again.

## Adding a Homebrew Package

Add `brew "package"` or `cask "application"` to `Brewfile`, then verify:

```bash
brew bundle check --file Brewfile
./install.sh --dry-run
```

## Adding a VS Code Extension

Add the extension ID to `vscode/extensions.txt`, then run:

```bash
./scripts/install-vscode-extensions.sh
```

Use `code --list-extensions` to list installed extension IDs.

## Rolling Back Changes

Existing dotfiles are backed up before modification:

```text
~/.macos-setup-backup/YYYYMMDD-HHMMSS/
```

Copy the required file from the latest backup directory to your home directory.
The existing Git identity is not replaced: the project adds a separate managed
configuration through `include.path`.

## GitHub Pages

1. Open the repository `Settings`.
2. Go to `Pages`.
3. Under `Build and deployment`, select `GitHub Actions` as the source.
4. Push changes from `docs/` to the `main` branch.
5. Follow the deployment under the `Actions` tab.

The `.github/workflows/deploy-pages.yml` workflow publishes `docs/` whenever the
site changes on `main`. It can also be started manually through
`Actions` → `Deploy GitHub Pages` → `Run workflow`.

The landing page uses English by default, supports Russian through the language
switcher, remembers the selected locale, and uses a light liquid-glass style.
Open the Russian version directly with `?lang=ru`.

The site is available at
[https://opsmon.github.io/setup/](https://opsmon.github.io/setup/).

## Security

- Always review the remote `install.sh` before running it.
- Existing configuration is backed up before replacement.
- SSH keys and SSH configuration are not modified.
- Secrets and personal Git settings are not stored in the repository.
- `system-report/`, `.env`, and log files are ignored by Git.
- The scripts do not invoke `sudo` directly or apply macOS defaults without consent.

Check shell syntax:

```bash
bash -n install.sh
bash -n scripts/*.sh
```

Optional static analysis:

```bash
brew install shellcheck
shellcheck install.sh scripts/*.sh
```
