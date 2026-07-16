# task.md

## Задача

В этом репозитории нужно сделать проект для быстрого сетапа нового Mac с macOS под рабочее окружение инженера.

Идея: пользователь открывает новый Mac, запускает одну команду удаленно через `curl`, и получает базово настроенную систему:

* Homebrew;
* CLI-инструменты;
* Oh My Zsh;
* zsh-плагины;
* тему терминала;
* dotfiles;
* настройки macOS;
* VS Code extensions;
* DevOps-инструменты;
* Kubernetes tooling;
* Terraform;
* Docker;
* полезные утилиты для повседневной инженерной работы.

Проект должен быть похож по удобству на установку `oh-my-zsh`, но с нашим набором инструментов и настройками.

Также нужно сделать простой сайт-документацию для GitHub Pages. Сайт должен быть оформлен как чистый продуктовый лендинг в стилистике apple.com: белый фон, черный крупный текст, много воздуха, аккуратное меню, hero-блок, красивые кнопки и минималистичная подача.

Перед написанием финального установочного скрипта нужно сначала собрать данные с текущей системы, где находится репозиторий. Это нужно, чтобы понять, какие инструменты, brew-пакеты, dotfiles, zsh-настройки и VS Code extensions реально используются на этой машине.

---

# Основная цель

Сделать репозиторий, который решает задачу:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh)"
```

После запуска скрипта новый Mac должен получить готовое окружение для разработки, DevOps-задач и повседневной инженерной работы.

---

# Важный порядок работы

Агент не должен писать установку вслепую.

Сначала нужно:

1. Создать скрипт сбора текущей системы.
2. Добавить `system-report/` в `.gitignore`.
3. Запустить сбор данных на текущем Mac.
4. Проанализировать собранный отчет.
5. На основе отчета собрать:

   * `Brewfile`;
   * `install.sh`;
   * `dotfiles`;
   * скрипты установки;
   * README;
   * сайт для GitHub Pages.
6. Убедиться, что приватные данные не попали в публичные файлы.

---

# 1. Сбор текущего состояния системы

Перед тем как писать финальный установочный скрипт, агент должен сначала собрать информацию с текущего Mac, на котором находится репозиторий.

Цель: понять, что уже установлено на рабочей машине, какие настройки реально используются, какие brew-пакеты нужны, какие dotfiles есть, какие CLI-инструменты стоят, и на основе этого собрать нормальный setup-kit для нового Mac.

Нужно добавить отдельный скрипт:

```bash
scripts/collect-current-system.sh
```

Скрипт должен собрать данные и сохранить их в директорию:

```bash
system-report/
```

Директория `system-report/` должна быть добавлена в `.gitignore`, чтобы случайно не закоммитить приватные данные.

---

## 1.1. Что должен собрать скрипт

### Информация о системе

Сохранить в файл:

```bash
system-report/system.txt
```

Команды:

```bash
sw_vers
uname -a
arch
hostname
whoami
```

Также определить:

* Apple Silicon или Intel;
* путь до Homebrew;
* текущий shell;
* версия zsh;
* версия git.

---

### Homebrew

Сохранить список установленных brew-пакетов:

```bash
system-report/brew-leaves.txt
```

Команда:

```bash
brew leaves
```

Сохранить полный Brewfile с текущей системы:

```bash
system-report/Brewfile.current
```

Команда:

```bash
brew bundle dump --file=system-report/Brewfile.current --force
```

Также сохранить список cask-приложений:

```bash
system-report/brew-casks.txt
```

Команда:

```bash
brew list --cask
```

Если Homebrew не установлен, скрипт должен написать это в отчет и не падать.

---

### Oh My Zsh и zsh-настройки

Сохранить информацию в:

```bash
system-report/zsh.txt
```

Проверить:

* установлен ли Oh My Zsh;
* какая тема используется;
* какие плагины включены;
* есть ли `.zshrc`;
* есть ли `.zprofile`;
* есть ли `.zshenv`.

Не нужно копировать приватные конфиги целиком без фильтрации.

Можно собрать только безопасные строки:

```bash
grep -E "^(ZSH_THEME=|plugins=|source |alias |export PATH=)" ~/.zshrc
```

Результат сохранить в:

```bash
system-report/zshrc.safe.txt
```

Если файла `~/.zshrc` нет, скрипт должен написать это в отчет и продолжить работу.

---

### Git config

Сохранить безопасную часть git config:

```bash
system-report/gitconfig.safe.txt
```

Команда:

```bash
git config --global --list
```

Но нужно отфильтровать приватные и потенциально чувствительные значения.

Не сохранять:

* токены;
* credentials;
* signingkey;
* email, если он не нужен;
* url rewrite с токенами;
* любые значения, похожие на secret/token/password/key.

---

### CLI-инструменты

Проверить наличие основных инструментов и сохранить в:

```bash
system-report/tools.txt
```

Проверить команды:

```bash
git
brew
zsh
curl
wget
jq
yq
fzf
rg
bat
eza
tree
docker
docker-compose
kubectl
helm
k9s
kind
minikube
terraform
ansible
argocd
stern
kubectx
kubens
go
python3
node
npm
nvm
code
```

Для каждой команды вывести:

* установлена или нет;
* путь через `command -v`;
* версию, если команда поддерживает `--version`.

Если версия не получается, не считать это ошибкой.

---

### VS Code

Если установлен VS Code CLI `code`, сохранить список расширений:

```bash
system-report/vscode-extensions.txt
```

Команда:

```bash
code --list-extensions
```

Потом на основе этого списка можно будет сделать установочный файл:

```bash
vscode/extensions.txt
```

И отдельный скрипт:

```bash
scripts/install-vscode-extensions.sh
```

---

### SSH

Собрать только безопасную информацию:

```bash
system-report/ssh.safe.txt
```

Можно проверить:

* существует ли `~/.ssh`;
* какие публичные ключи есть `*.pub`;
* есть ли `config`.

Нельзя сохранять:

* приватные ключи;
* содержимое приватных ключей;
* `known_hosts` целиком;
* токены;
* пароли;
* приватные host-настройки, если они содержат чувствительные данные.

Разрешено сохранить только имена публичных ключей и fingerprint публичных ключей:

```bash
find ~/.ssh -maxdepth 1 -name "*.pub" -print
ssh-keygen -lf ~/.ssh/*.pub
```

---

### Dotfiles

Проверить наличие файлов:

```bash
~/.zshrc
~/.zprofile
~/.zshenv
~/.gitconfig
~/.aliases
~/.exports
~/.functions
~/.tmux.conf
```

Сохранить только факт наличия и размер файла:

```bash
system-report/dotfiles.txt
```

Не копировать файлы целиком без фильтрации.

---

## 1.2. Безопасность сбора

Очень важно:

* `system-report/` должен быть в `.gitignore`;
* не коммитить приватные данные;
* не сохранять приватные SSH-ключи;
* не сохранять токены;
* не сохранять пароли;
* не сохранять cookies;
* не сохранять содержимое `known_hosts`;
* не сохранять содержимое `.npmrc`;
* не сохранять содержимое `.pypirc`;
* не сохранять содержимое `.docker/config.json`;
* не сохранять переменные окружения целиком через `env`;
* не сохранять shell history;
* не сохранять рабочие директории с кодом;
* не сохранять содержимое файлов с именами `secret`, `token`, `credentials`, `password`, `key`.

Если нужно сохранить что-то потенциально чувствительное — сохранить только факт наличия, но не содержимое.

---

## 1.3. После сбора данных

Агент должен изучить файлы из `system-report/` и на их основе:

1. Обновить `Brewfile`.
2. Обновить `dotfiles/`.
3. Добавить список VS Code extensions, если они есть.
4. Добавить недостающие CLI-инструменты.
5. Убрать лишнее и приватное.
6. Обновить README.
7. Обновить сайт GitHub Pages.

---

## 1.4. Команда для запуска сбора

Добавить в README:

```bash
./scripts/collect-current-system.sh
```

После выполнения пользователь может посмотреть отчет:

```bash
ls -la system-report/
```

---

# 2. Установочный скрипт

Создать основной файл:

```bash
install.sh
```

Скрипт должен:

1. Проверять, что система — macOS.
2. Проверять наличие `xcode-select`.
3. Устанавливать Command Line Tools, если они отсутствуют.
4. Устанавливать Homebrew, если он отсутствует.
5. Корректно добавлять Homebrew в shell path:

   * для Apple Silicon: `/opt/homebrew/bin`;
   * для Intel Mac: `/usr/local/bin`.
6. Обновлять brew.
7. Устанавливать пакеты из `Brewfile`.
8. Устанавливать Oh My Zsh, если он отсутствует.
9. Настраивать `.zshrc`.
10. Устанавливать полезные zsh-плагины.
11. Создавать резервную копию старых конфигов перед заменой.
12. Быть безопасным для повторного запуска.
13. Логировать шаги установки.
14. Не ломать существующую систему.

---

## 2.1. Режимы запуска

Нужно добавить поддержку:

```bash
./install.sh
./install.sh --dry-run
./install.sh --help
```

Пример help:

```bash
Usage:
  ./install.sh              Run full setup
  ./install.sh --dry-run    Show planned actions
  ./install.sh --help       Show help
```

Режим `--dry-run` должен показывать, что скрипт собирается сделать, но ничего не устанавливать и не менять.

---

# 3. Brewfile

Создать файл:

```bash
Brewfile
```

В него добавить базовый набор инструментов.

Минимальный набор:

```ruby
tap "homebrew/bundle"

brew "git"
brew "wget"
brew "curl"
brew "tree"
brew "jq"
brew "yq"
brew "fzf"
brew "ripgrep"
brew "bat"
brew "eza"
brew "htop"
brew "tmux"
brew "zoxide"

brew "docker"
brew "docker-compose"
brew "kubectl"
brew "helm"
brew "k9s"
brew "kind"
brew "minikube"
brew "terraform"
brew "ansible"
brew "argocd"
brew "stern"
brew "kubectx"
brew "kustomize"

brew "python"
brew "go"
brew "node"
brew "nvm"

brew "mas"

cask "iterm2"
cask "visual-studio-code"
cask "docker"
cask "telegram"
cask "google-chrome"
cask "rectangle"
```

После анализа `system-report/Brewfile.current` можно добавить реальные пакеты с текущей машины, но только если они полезны для нового Mac.

Не нужно бездумно переносить весь мусор из текущей системы.

---

# 4. Dotfiles

Создать директорию:

```bash
dotfiles/
```

Внутри:

```bash
dotfiles/.zshrc
dotfiles/.gitconfig
dotfiles/.aliases
dotfiles/.exports
dotfiles/.functions
```

`.zshrc` должен подключать:

```bash
source ~/.aliases
source ~/.exports
source ~/.functions
```

Добавить удобные алиасы:

```bash
alias ll='eza -la'
alias la='eza -la'
alias cat='bat'
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kctx='kubectx'
alias kns='kubens'
alias tf='terraform'
alias dc='docker compose'
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
```

Добавить базовые настройки:

```bash
export EDITOR="code"
export PATH="/opt/homebrew/bin:$PATH"
```

Для Intel Mac предусмотреть:

```bash
export PATH="/usr/local/bin:$PATH"
```

Логику выбора пути лучше делать в `.zshrc` через проверку существования директории.

---

# 5. Oh My Zsh

Скрипт должен установить Oh My Zsh без интерактивного режима.

Также нужно установить плагины:

```bash
zsh-autosuggestions
zsh-syntax-highlighting
```

Желательно добавить тему:

```bash
powerlevel10k
```

Если тема слишком сложная для автосетапа, сделать базовую настройку и описать ручной шаг в README.

---

# 6. VS Code extensions

Если при сборе текущей системы найден список расширений VS Code, нужно создать:

```bash
vscode/extensions.txt
```

И добавить туда список расширений.

Также создать скрипт:

```bash
scripts/install-vscode-extensions.sh
```

Скрипт должен:

1. Проверить, установлен ли `code`.
2. Прочитать `vscode/extensions.txt`.
3. Установить расширения командой:

```bash
code --install-extension <extension-name>
```

4. Не падать, если расширение уже установлено.
5. Писать понятные логи.

---

# 7. Структура проекта

Сделать такую структуру:

```bash
.
├── install.sh
├── Brewfile
├── README.md
├── task.md
├── .gitignore
├── dotfiles
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .aliases
│   ├── .exports
│   └── .functions
├── scripts
│   ├── check-system.sh
│   ├── collect-current-system.sh
│   ├── install-brew.sh
│   ├── install-oh-my-zsh.sh
│   ├── install-packages.sh
│   ├── install-vscode-extensions.sh
│   ├── link-dotfiles.sh
│   └── macos-defaults.sh
├── vscode
│   └── extensions.txt
└── docs
    ├── index.html
    ├── styles.css
    └── script.js
```

Можно вынести логику из `install.sh` в `scripts/`, чтобы основной скрипт был чистым и понятным.

---

# 8. .gitignore

Создать `.gitignore`.

Минимально добавить:

```gitignore
system-report/
.DS_Store
*.log
.env
.env.*
npm-debug.log*
```

Важно: `system-report/` не должен попадать в git.

---

# 9. README.md

Сделать подробный `README.md`.

В нем должны быть разделы:

```markdown
# macOS Setup

## Что это

## Быстрый старт

## Сбор текущей системы

## Что устанавливается

## Структура проекта

## Как запустить

## Как обновить окружение

## Как добавить новый brew-пакет

## Как добавить VS Code extension

## Как откатить изменения

## GitHub Pages

## Безопасность
```

Команда установки должна быть в отдельном блоке:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh)"
```

В README нужно явно написать, что перед запуском пользователь должен посмотреть содержимое `install.sh`.

Пример:

````markdown
Перед запуском удаленного скрипта всегда проверьте его содержимое:

```bash
curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh
````

````

---

# 10. GitHub Pages сайт

Сделать простой красивый сайт в директории:

```bash
docs/
````

Сайт будет использоваться через GitHub Pages.

Нужно сделать:

```bash
docs/index.html
docs/styles.css
docs/script.js
```

---

## 10.1. Общая идея сайта

Сайт должен выглядеть как чистый продуктовый лендинг в духе apple.com.

Ориентир по визуальному стилю:

* белый фон;
* черный крупный текст;
* тонкое верхнее меню;
* центральный hero-блок;
* короткий подзаголовок;
* две аккуратные кнопки;
* большая визуальная зона под hero-блоком;
* много воздуха;
* минимализм;
* спокойная премиальная подача;
* аккуратная адаптивность.

Важно: не нужно делать “сайт про Apple”. Это сайт про `macOS Setup`, но визуально он должен ощущаться как аккуратная продуктовая страница.

Не использовать:

* логотип Apple;
* изображения Apple;
* товарные знаки Apple;
* копии реальных страниц Apple;
* реальные product assets Apple;
* чужие изображения;
* упоминания, будто проект связан с Apple.

Можно вдохновляться только подходом:

* чистота;
* крупная типографика;
* белое пространство;
* презентационность;
* простые CTA-кнопки;
* аккуратная сетка.

---

## 10.2. Верхнее меню

Сделать верхнее горизонтальное меню как на продуктовых лендингах.

Структура:

```text
macOS Setup    Install    Tools    Dotfiles    Security    GitHub
```

Требования:

* высота примерно 44px;
* белый или полупрозрачный белый фон;
* легкий blur можно добавить через `backdrop-filter`;
* тонкая нижняя граница `rgba(0, 0, 0, 0.08)`;
* меню должно быть фиксированным сверху или sticky;
* шрифт мелкий, аккуратный;
* пункты меню по центру или в одну линию;
* на мобильных можно превратить в компактное меню или оставить только важные пункты.

Цвета:

```css
background: rgba(255, 255, 255, 0.8);
color: #1d1d1f;
border-bottom: 1px solid rgba(0, 0, 0, 0.08);
```

---

## 10.3. Первый экран hero

Первый экран должен быть похож по композиции на продуктовый блок:

```text
macOS Setup
One command. Fresh Mac. Ready workspace.

[Install now] [View GitHub]

<большая визуальная зона>
```

Заголовок:

```text
macOS Setup
```

Подзаголовок:

```text
One command. Fresh Mac. Ready workspace.
```

Можно использовать русский вариант, если весь сайт на русском:

```text
Одна команда. Новый Mac. Готовое рабочее окружение.
```

Кнопки:

```text
Install now
View GitHub
```

или:

```text
Установить
GitHub
```

Первая кнопка:

* синяя;
* заливка `#0071e3`;
* белый текст;
* border-radius 999px.

Вторая кнопка:

* белая;
* синяя обводка;
* синий текст;
* border-radius 999px.

Пример стиля:

```css
.btn-primary {
  background: #0071e3;
  color: #ffffff;
  border-radius: 999px;
  padding: 12px 24px;
}

.btn-secondary {
  background: transparent;
  color: #0071e3;
  border: 1px solid #0071e3;
  border-radius: 999px;
  padding: 12px 24px;
}
```

---

## 10.4. Визуальная зона в hero

Под кнопками сделать большую визуальную зону.

Так как нельзя использовать изображения Apple, нужно сделать собственную визуализацию.

Идеи:

1. Большой mockup терминала с командой установки.
2. Абстрактный блок в форме ноутбука без логотипов.
3. Светлая карточка с CLI-командой.
4. Большой code-блок на белом/светло-сером фоне.
5. Несколько “окон” с шагами установки:

   * Homebrew;
   * Oh My Zsh;
   * Docker;
   * Kubernetes;
   * VS Code.

Пример содержимого визуального блока:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh)"
```

Визуальный блок должен быть крупным, аккуратным и центральным.

Не делать темный терминал на весь экран. Code-блок может быть светлым.

---

## 10.5. Секции сайта

На сайте должны быть блоки:

### 1. Hero

Содержит:

* название проекта;
* короткое описание;
* две кнопки;
* команду установки;
* крупную визуальную зону.

---

### 2. Что устанавливается

Сделать секцию с карточками:

* Homebrew;
* Oh My Zsh;
* DevOps CLI;
* Kubernetes tooling;
* Docker;
* Terraform;
* VS Code;
* Terminal tools.

Карточки должны быть светлыми:

```css
background: #f5f5f7;
border-radius: 28px;
```

Внутри карточки:

* короткий заголовок;
* 1–2 строки описания;
* можно добавить маленький текстовый бейдж.

---

### 3. Как использовать

Сделать секцию с шагами:

1. Открыть Terminal.
2. Проверить скрипт.
3. Запустить команду установки.
4. Дождаться завершения.
5. Перезапустить терминал.

Команду проверки вывести отдельно:

```bash
curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh
```

Команду установки вывести отдельно:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh)"
```

---

### 4. Сбор текущей системы

Секция должна объяснять:

* зачем нужен сбор;
* какая команда запускает сбор;
* где лежит отчет;
* почему отчет не коммитится;
* что приватные данные фильтруются.

Команда:

```bash
./scripts/collect-current-system.sh
```

Отчет:

```bash
system-report/
```

---

### 5. Безопасность

Секция должна объяснять:

* перед запуском удаленного скрипта нужно проверить содержимое;
* скрипт делает backup старых конфигов;
* скрипт можно запускать повторно;
* приватные данные не должны попадать в репозиторий;
* `system-report/` добавлен в `.gitignore`.

---

### 6. Структура проекта

Показать структуру:

```bash
.
├── install.sh
├── Brewfile
├── README.md
├── task.md
├── .gitignore
├── dotfiles
├── scripts
├── vscode
└── docs
```

---

### 7. Footer

Footer должен быть простой:

```text
macOS Setup — personal bootstrap-kit for a fresh macOS workspace.
```

Также добавить ссылки:

```text
GitHub
README
Install
Security
```

---

## 10.6. Цветовая схема сайта

Основная цветовая схема:

```css
--color-bg: #ffffff;
--color-bg-soft: #f5f5f7;
--color-text: #1d1d1f;
--color-muted: #6e6e73;
--color-blue: #0071e3;
--color-border: rgba(0, 0, 0, 0.08);
```

Правила:

* основной фон сайта — белый;
* основной текст — черный или почти черный;
* заголовки — черные;
* вторичный текст — серый;
* акцент — синий только для ссылок, кнопок и важных действий;
* карточки — белые или светло-серые;
* code-блоки — светлые;
* темные секции не использовать как основной стиль;
* не делать кислотные градиенты;
* не делать неон;
* не делать cyberpunk/devops-dark-mode;
* не делать тяжелую админскую панель.

Главное визуальное правило:

```text
Белый фон. Черный крупный текст. Много воздуха. Минимум шума.
```

---

## 10.7. Типографика

Использовать системные шрифты:

```css
font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro Text", "Helvetica Neue", Arial, sans-serif;
```

Заголовки:

* крупные;
* жирные;
* центрированные в hero;
* с хорошим line-height.

Пример:

```css
.hero-title {
  font-size: clamp(56px, 8vw, 96px);
  line-height: 1.04;
  font-weight: 700;
  letter-spacing: -0.055em;
}
```

Подзаголовок:

```css
.hero-subtitle {
  font-size: clamp(24px, 3vw, 36px);
  line-height: 1.15;
  font-weight: 400;
  color: #1d1d1f;
}
```

Обычный текст:

```css
body {
  font-size: 17px;
  line-height: 1.47059;
}
```

---

## 10.8. Layout

Общий layout:

```css
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}
```

Hero:

```css
.hero {
  min-height: 720px;
  padding: 96px 24px 64px;
  text-align: center;
  background: #f5f5f7;
}
```

Секции:

```css
.section {
  padding: 96px 24px;
}
```

Карточки:

```css
.card {
  background: #f5f5f7;
  border-radius: 28px;
  padding: 32px;
}
```

---

## 10.9. Анимации

Добавить аккуратные анимации появления:

* fade-in;
* translateY на 12–24px;
* duration 500–700ms;
* без агрессивных эффектов.

Пример:

```css
.reveal {
  opacity: 0;
  transform: translateY(18px);
  transition: opacity 0.7s ease, transform 0.7s ease;
}

.reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
```

В `docs/script.js` можно добавить IntersectionObserver.

---

## 10.10. Адаптивность

Сайт должен нормально выглядеть:

* на desktop;
* на планшете;
* на мобильном.

На мобильных:

* hero-заголовок должен уменьшаться;
* меню не должно ломаться;
* карточки должны идти в одну колонку;
* code-блоки должны скроллиться горизонтально;
* кнопки должны быть удобны для нажатия.

---

# 11. Безопасность установки

Важно:

1. Не удалять старые конфиги без backup.
2. Перед заменой файлов делать копии в директорию:

```bash
~/.macos-setup-backup/<date>/
```

3. Не хранить секреты в репозитории.
4. Не прописывать токены, пароли, SSH-ключи.
5. Не трогать существующие SSH-ключи.
6. Не перезаписывать `.gitconfig`, если он уже существует, без backup.
7. Все опасные действия должны быть явно видны в коде.
8. Не сохранять приватные данные из `system-report/` в публичные файлы.
9. Не использовать `sudo` без необходимости.
10. Не менять системные настройки macOS без согласия пользователя.

---

# 12. Повторный запуск

Скрипт должен быть idempotent.

То есть если пользователь запускает его второй раз:

```bash
./install.sh
```

Он не должен ломаться.

Он должен:

* пропускать уже установленные компоненты;
* обновлять brew-пакеты;
* аккуратно обновлять dotfiles;
* не плодить дубликаты в `.zshrc`;
* не переустанавливать Oh My Zsh без необходимости;
* не создавать бесконечно новые одинаковые блоки в конфигах.

---

# 13. Логи

Добавить красивые логи в терминале:

```bash
[INFO] Checking macOS...
[INFO] Homebrew found
[INFO] Installing packages from Brewfile...
[INFO] Linking dotfiles...
[SUCCESS] macOS setup completed
```

Ошибки выводить понятно:

```bash
[ERROR] Homebrew installation failed
```

Для предупреждений использовать:

```bash
[WARN] VS Code CLI not found, skipping extensions installation
```

---

# 14. Дополнительные настройки macOS

Добавить отдельный файл:

```bash
scripts/macos-defaults.sh
```

В нем можно подготовить настройки macOS, но не запускать их автоматически без явного согласия.

Примеры настроек:

```bash
# Показывать скрытые файлы в Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Показывать расширения файлов
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Ускорить повтор нажатия клавиш
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

В `install.sh` можно добавить вопрос:

```bash
Do you want to apply macOS defaults? [y/N]
```

По умолчанию — `N`.

---

# 15. Проверка результата

После выполнения задачи агент должен убедиться, что:

```bash
bash -n install.sh
```

проходит без ошибок.

Также проверить shell-скрипты:

```bash
bash -n scripts/*.sh
```

Если используется `shellcheck`, добавить рекомендацию в README:

```bash
brew install shellcheck
shellcheck install.sh scripts/*.sh
```

---

# 16. Ожидаемый результат

В итоге должен получиться репозиторий, который можно использовать так:

```bash
git clone https://github.com/<OWNER>/<REPO>.git
cd <REPO>
./install.sh
```

или удаленно:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/<OWNER>/<REPO>/main/install.sh)"
```

После установки пользователь получает настроенный Mac для разработки и DevOps-задач.

---

# 17. GitHub Pages deployment

Нужно подготовить проект так, чтобы GitHub Pages можно было включить из директории:

```bash
/docs
```

В README добавить инструкцию:

1. Открыть настройки репозитория.
2. Перейти в Pages.
3. Выбрать source: `Deploy from a branch`.
4. Branch: `main`.
5. Folder: `/docs`.
6. Сохранить.

После этого сайт будет доступен по адресу:

```bash
https://<OWNER>.github.io/<REPO>/
```

---

# 18. TODO.md

Дополнительно можно создать файл:

```bash
TODO.md
```

Туда складывать будущие улучшения:

```markdown
# TODO

- [ ] Добавить установку Nerd Fonts.
- [ ] Добавить настройку iTerm2 profile.
- [ ] Добавить bootstrap SSH config template.
- [ ] Добавить установку приложений через Mac App Store.
- [ ] Добавить настройку dock.
- [ ] Добавить настройку Finder.
- [ ] Добавить профиль VS Code settings.json.
- [ ] Добавить синхронизацию рабочих директорий.
- [ ] Добавить поддержку private mode.
```

---

# 19. Требования к качеству

Код должен быть:

* понятный;
* аккуратный;
* безопасный;
* с комментариями;
* без лишней магии;
* без секретов;
* пригодный для публичного GitHub-репозитория;
* безопасный для повторного запуска;
* удобный для ручной проверки.

Не нужно делать enterprise-overengineering.

Это должен быть простой, удобный и понятный setup-kit для нового Mac.

---

# 20. Финальный чек-лист

Перед завершением задачи проверить:

* [ ] Есть `install.sh`.
* [ ] Есть `Brewfile`.
* [ ] Есть `.gitignore`.
* [ ] Есть `README.md`.
* [ ] Есть `task.md`.
* [ ] Есть директория `dotfiles/`.
* [ ] Есть директория `scripts/`.
* [ ] Есть директория `docs/`.
* [ ] Есть директория `vscode/`.
* [ ] Есть `scripts/collect-current-system.sh`.
* [ ] Есть `scripts/check-system.sh`.
* [ ] Есть `scripts/install-brew.sh`.
* [ ] Есть `scripts/install-oh-my-zsh.sh`.
* [ ] Есть `scripts/install-packages.sh`.
* [ ] Есть `scripts/install-vscode-extensions.sh`.
* [ ] Есть `scripts/link-dotfiles.sh`.
* [ ] Есть `scripts/macos-defaults.sh`.
* [ ] `system-report/` добавлен в `.gitignore`.
* [ ] Агент собрал текущее состояние системы перед генерацией финального сетапа.
* [ ] Приватные данные не попали в репозиторий.
* [ ] Старые конфиги сохраняются в backup.
* [ ] Скрипт не падает при повторном запуске.
* [ ] Команда установки описана в README.
* [ ] Команда установки отображается на сайте.
* [ ] Есть сайт для GitHub Pages.
* [ ] Сайт сделан в духе apple.com: белый фон, черный крупный текст, много воздуха.
* [ ] На сайте есть верхнее тонкое меню.
* [ ] На сайте есть центральный hero-блок.
* [ ] На сайте есть две CTA-кнопки.
* [ ] На сайте есть крупная визуальная зона с командой установки.
* [ ] Дизайн не уходит в темную DevOps-тему.
* [ ] В дизайне не используются логотипы Apple, изображения Apple, товарные знаки Apple и чужие материалы.
* [ ] Shell-скрипты проходят `bash -n`.
* [ ] В README описана безопасность запуска удаленного скрипта.
* [ ] В README описано, как включить GitHub Pages.
* [ ] В README описано, как добавить новый brew-пакет.
* [ ] В README описано, как добавить VS Code extension.

---

# 21. Финальная мысль по проекту

Репозиторий должен быть не просто набором скриптов, а личным bootstrap-kit для нового Mac.

То есть задача не “поставить все подряд”, а собрать аккуратный, проверяемый и безопасный инструмент, который можно запустить на чистой машине и быстро получить привычное рабочее окружение.

Сайт должен продавать эту идею визуально: как будто это не скучная папка со скриптами, а аккуратный продукт для быстрого старта на новом Mac.
