# macOS Setup

[English](README.md) | **Русский**

Личный bootstrap-kit для быстрого и проверяемого сетапа нового Mac под разработку,
DevOps и повседневную инженерную работу.

## Что это

Проект устанавливает Homebrew, CLI-инструменты, Docker и Kubernetes tooling,
Terraform, языки разработки, Oh My Zsh, плагины, dotfiles и расширения VS Code.
Скрипты рассчитаны на Apple Silicon и Intel Mac и безопасны для повторного запуска.

Набор сформирован после сбора текущей рабочей системы через
`scripts/collect-current-system.sh`: в него вошли полезные инструменты, а зависимости
Homebrew, приватные настройки и секреты были исключены.

## Быстрый старт

Перед запуском удалённого скрипта всегда проверьте его содержимое:

```bash
curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.sh
```

Запуск:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/opsmon/setup/main/install.sh)"
```

Или локально:

```bash
git clone https://github.com/opsmon/setup.git
cd setup
./install.sh
```

## Сбор текущей системы

Сборщик фиксирует версии системы и CLI, Homebrew packages, безопасную часть zsh и
Git config, имена и fingerprints публичных SSH-ключей, наличие dotfiles и список
VS Code extensions:

```bash
./scripts/collect-current-system.sh
ls -la system-report/
```

`system-report/` исключён через `.gitignore`. Скрипт не читает приватные SSH-ключи,
shell history, environment целиком, `known_hosts`, `.npmrc`, `.pypirc` или Docker
credentials.

## Что устанавливается

- CLI: Git, GitHub CLI, curl, wget, jq, yq, fzf, ripgrep, bat, eza, tmux, zoxide.
- Containers: Docker CLI, Docker Compose и Docker Desktop.
- Kubernetes: kubectl, Helm, k9s, kind, Argo CD, stern, kubectx/kubens,
  kustomize.
- Infrastructure: Terraform и Ansible.
- Languages: Python, Go, Node.js и nvm.
- Apps: iTerm2, VS Code и Rectangle.
- Shell: Oh My Zsh, autosuggestions, syntax highlighting и powerlevel10k.

Полный декларативный список находится в `Brewfile`.

VS Code входит в автоматическую установку, поэтому скачивать его вручную не нужно.
После завершения потребуется один раз открыть Docker Desktop.

## Структура проекта

```text
.
├── install.sh
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

## Как запустить

```bash
./install.sh
./install.sh --dry-run
./install.sh --help
```

`--dry-run` показывает действия без установки пакетов и изменения конфигов.
Настройки macOS не применяются автоматически: интерактивный запуск отдельно
запрашивает согласие, по умолчанию выбран ответ `N`.

## Как обновить окружение

Обновите репозиторий и повторно запустите установку:

```bash
git pull
./install.sh
```

Homebrew обновит пакеты, уже установленные компоненты будут пропущены, а одинаковые
dotfiles не будут копироваться повторно.

## Как добавить новый brew-пакет

Добавьте `brew "package"` или `cask "application"` в `Brewfile`, проверьте:

```bash
brew bundle check --file Brewfile
./install.sh --dry-run
```

## Как добавить VS Code extension

Добавьте extension ID отдельной строкой в `vscode/extensions.txt`, затем запустите:

```bash
./scripts/install-vscode-extensions.sh
```

Получить ID установленных расширений можно командой `code --list-extensions`.

## Как откатить изменения

Перед изменением существующих dotfiles создаётся backup:

```text
~/.macos-setup-backup/YYYYMMDD-HHMMSS/
```

Скопируйте нужный файл из последней директории backup обратно в домашнюю
директорию. Существующая Git identity не заменяется: проект подключает отдельный
managed config через `include.path`.

## GitHub Pages

1. Откройте `Settings` репозитория.
2. Перейдите в `Pages`.
3. В разделе `Build and deployment` выберите source `GitHub Actions`.
4. Сделайте push изменений директории `docs/` в ветку `main`.
5. Следите за деплоем во вкладке `Actions`.

Workflow `.github/workflows/deploy-pages.yml` автоматически публикует содержимое
`docs/` при каждом изменении сайта в `main`. Его также можно запустить вручную:
`Actions` → `Deploy GitHub Pages` → `Run workflow`.

Лендинг поддерживает английский и русский языки, сохраняет выбранную локаль и
использует светлый liquid-glass стиль. Английский язык используется по умолчанию,
русскую версию можно открыть напрямую через `?lang=ru`.

Сайт будет доступен по адресу
[https://opsmon.github.io/setup/](https://opsmon.github.io/setup/).

## Безопасность

- Всегда просматривайте удалённый `install.sh` до запуска.
- Старые конфиги не удаляются без backup.
- SSH-ключи и SSH config не изменяются.
- Секреты и персональные Git-настройки не хранятся в репозитории.
- `system-report/`, `.env` и логи исключены из git.
- Скрипты не используют `sudo` напрямую и не применяют defaults macOS без согласия.

Проверка shell-синтаксиса:

```bash
bash -n install.sh
bash -n scripts/*.sh
```

Дополнительно:

```bash
brew install shellcheck
shellcheck install.sh scripts/*.sh
```
