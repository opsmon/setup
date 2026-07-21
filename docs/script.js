const translations = {
  ru: {
    "meta.description": "macOS Setup: одна команда для готового инженерного окружения на новом Mac.",
    "nav.label": "Основная навигация",
    "nav.open": "Открыть меню",
    "nav.close": "Закрыть меню",
    "language.label": "Выбор языка",
    "hero.eyebrow": "Персональный bootstrap kit",
    "hero.subtitle": "Одна команда. Новый Mac. Готовое рабочее окружение.",
    "hero.install": "Установить",
    "hero.demo": "Пример установки",
    "common.copy": "Копировать",
    "common.copied": "Готово",
    "common.copyFailed": "Не удалось",
    "flow.homebrew": "Основа пакетов",
    "flow.terminal": "Zsh и dotfiles",
    "flow.editor": "Расширения VS Code",
    "tools.eyebrow": "Основа рабочего окружения",
    "tools.title": "Всё нужное. Без ручной рутины.",
    "tools.subtitle": "Проверенный набор для разработки, инфраструктуры и ежедневной работы.",
    "badge.foundation": "Основа",
    "badge.containers": "Контейнеры",
    "badge.platform": "Платформа",
    "badge.infrastructure": "Инфраструктура",
    "badge.editor": "Редактор",
    "badge.languages": "Языки",
    "card.homebrew": "Единый декларативный Brewfile для CLI и приложений.",
    "card.zsh": "Плагины, powerlevel10k и удобные инженерные алиасы.",
    "card.docker": "Docker Desktop, CLI и Compose для локальной разработки.",
    "card.kubernetes": "kubectl, Helm, k9s, kind и полезные дополнения устанавливаются автоматически.",
    "card.terraform": "Terraform, Ansible и Argo CD для управления инфраструктурой.",
    "card.vscode": "Редактор и расширения устанавливаются автоматически. Скачивать VS Code вручную не нужно.",
    "card.runtime": "Актуальная база из Python, Go, Node.js и nvm.",
    "card.terminal": "fzf, ripgrep, bat, eza, jq, yq, tmux и zoxide.",
    "checklist.eyebrow": "Чек-лист установки",
    "checklist.title": "Что поставить и проверить.",
    "checklist.subtitle": "Большую часть сделает скрипт. После него останется несколько коротких ручных действий.",
    "checklist.autoBadge": "Автоматически",
    "checklist.autoTitle": "Скрипт установит",
    "checklist.cliTitle": "Homebrew и CLI",
    "checklist.cliText": "Git, jq, yq, fzf, ripgrep, bat, eza и другие утилиты.",
    "checklist.vscodeText": "Приложение и расширения. Отдельно скачивать редактор не нужно.",
    "checklist.dockerText": "Приложение, Docker CLI и Docker Compose.",
    "checklist.shellTitle": "Shell и dotfiles",
    "checklist.shellText": "Oh My Zsh, плагины, тема, aliases и managed Git config.",
    "checklist.afterBadge": "После установки",
    "checklist.manualTitle": "Сделайте вручную",
    "checklist.terminalTitle": "Откройте новое окно Terminal",
    "checklist.terminalText": "Так загрузятся новые настройки Zsh и PATH.",
    "checklist.startDockerTitle": "Запустите Docker Desktop",
    "checklist.startDockerText": "Примите системные запросы и дождитесь запуска Docker Engine.",
    "checklist.openCodeTitle": "Откройте VS Code",
    "checklist.openCodeText": "При необходимости войдите в аккаунт и включите Settings Sync.",
    "checklist.gitTitle": "Настройте Git identity",
    "checklist.gitText": "Укажите собственные <code>user.name</code> и <code>user.email</code>.",
    "install.eyebrow": "Пять простых шагов",
    "install.title": "От коробки до работы.",
    "install.subtitle": "Сначала прочитайте скрипт. Затем запустите и дождитесь понятного отчёта по каждому шагу.",
    "install.step1Title": "Откройте Terminal",
    "install.step1Text": "Подойдёт стандартный Terminal или iTerm2.",
    "install.step2Title": "Проверьте скрипт",
    "install.step2Text": "Посмотрите код до удалённого запуска.",
    "install.step3Title": "Запустите установку",
    "install.step3Text": "Одна команда запускает весь последовательный setup.",
    "install.step4Title": "Следите за логами",
    "install.step4Text": "Каждое действие явно отмечено в терминале.",
    "install.step5Title": "Перезапустите shell",
    "install.step5Text": "Откройте новое окно и начинайте работу.",
    "install.reviewBash": "Проверить Bash",
    "install.reviewPython": "Проверить Python",
    "install.runBash": "Установить через Bash",
    "install.runPython": "Установить через Python",
    "snapshot.eyebrow": "Снимок системы",
    "snapshot.title": "Сначала понять. Потом устанавливать.",
    "snapshot.subtitle": "Сборщик анализирует текущие пакеты, инструменты и безопасную часть конфигурации. Отчёт остаётся только на машине и не попадает в git.",
    "snapshot.collect": "Собрать отчёт",
    "snapshot.result": "Результат",
    "security.eyebrow": "Создано для проверки",
    "security.title": "Безопасность видна в коде.",
    "security.backupTitle": "Backup до изменения",
    "security.backupText": "Старые конфиги сохраняются в ~/.macos-setup-backup/.",
    "security.repeatTitle": "Повторный запуск",
    "security.repeatText": "Установленные компоненты пропускаются, одинаковые файлы не копируются.",
    "security.secretsTitle": "Никаких секретов",
    "security.secretsText": "SSH keys, credentials, history и environment не переносятся.",
    "security.defaultsTitle": "Defaults только по согласию",
    "security.defaultsText": "Системные настройки macOS являются отдельным opt-in шагом.",
    "structure.eyebrow": "Открытая структура",
    "structure.title": "Простая структура.",
    "structure.subtitle": "Каждый слой можно прочитать, изменить или запустить отдельно.",
    "footer.text": "macOS Setup — персональный bootstrap-kit для нового рабочего окружения macOS.",
  },
  en: {
    "meta.description": "macOS Setup: one command for a ready-to-use engineering workspace on a new Mac.",
    "nav.label": "Main navigation",
    "nav.open": "Open menu",
    "nav.close": "Close menu",
    "language.label": "Language selection",
    "hero.eyebrow": "Personal bootstrap kit",
    "hero.subtitle": "One command. Fresh Mac. Ready workspace.",
    "hero.install": "Install now",
    "hero.demo": "Installation example",
    "common.copy": "Copy",
    "common.copied": "Copied",
    "common.copyFailed": "Failed",
    "flow.homebrew": "Package foundation",
    "flow.terminal": "Zsh and dotfiles",
    "flow.editor": "VS Code extensions",
    "tools.eyebrow": "Workspace essentials",
    "tools.title": "Everything you need. None of the busywork.",
    "tools.subtitle": "A curated toolkit for development, infrastructure, and everyday engineering.",
    "badge.foundation": "Foundation",
    "badge.containers": "Containers",
    "badge.platform": "Platform",
    "badge.infrastructure": "Infrastructure",
    "badge.editor": "Editor",
    "badge.languages": "Languages",
    "card.homebrew": "One declarative Brewfile for command-line tools and applications.",
    "card.zsh": "Plugins, powerlevel10k, and practical engineering aliases.",
    "card.docker": "Docker Desktop, CLI, and Compose for local development.",
    "card.kubernetes": "kubectl, Helm, k9s, kind, and useful additions are installed automatically.",
    "card.terraform": "Terraform, Ansible, and Argo CD for infrastructure management.",
    "card.vscode": "The editor and extensions are installed automatically. No manual download needed.",
    "card.runtime": "A current foundation with Python, Go, Node.js, and nvm.",
    "card.terminal": "fzf, ripgrep, bat, eza, jq, yq, tmux, and zoxide.",
    "checklist.eyebrow": "Setup checklist",
    "checklist.title": "What gets installed and checked.",
    "checklist.subtitle": "The script handles most of the work. Only a few short manual steps remain.",
    "checklist.autoBadge": "Automatic",
    "checklist.autoTitle": "The script installs",
    "checklist.cliTitle": "Homebrew and CLI",
    "checklist.cliText": "Git, jq, yq, fzf, ripgrep, bat, eza, and other utilities.",
    "checklist.vscodeText": "The application and extensions. No separate editor download is required.",
    "checklist.dockerText": "The application, Docker CLI, and Docker Compose.",
    "checklist.shellTitle": "Shell and dotfiles",
    "checklist.shellText": "Oh My Zsh, plugins, theme, aliases, and managed Git config.",
    "checklist.afterBadge": "After installation",
    "checklist.manualTitle": "Complete manually",
    "checklist.terminalTitle": "Open a new Terminal window",
    "checklist.terminalText": "This loads the new Zsh settings and PATH.",
    "checklist.startDockerTitle": "Start Docker Desktop",
    "checklist.startDockerText": "Accept the system prompts and wait for Docker Engine to start.",
    "checklist.openCodeTitle": "Open VS Code",
    "checklist.openCodeText": "Sign in and enable Settings Sync if you use it.",
    "checklist.gitTitle": "Configure your Git identity",
    "checklist.gitText": "Set your own <code>user.name</code> and <code>user.email</code>.",
    "install.eyebrow": "Five simple steps",
    "install.title": "From unboxed to productive.",
    "install.subtitle": "Review the script first. Then run it and follow the clear status output for every step.",
    "install.step1Title": "Open Terminal",
    "install.step1Text": "Use the built-in Terminal or iTerm2.",
    "install.step2Title": "Review the script",
    "install.step2Text": "Read the code before running it remotely.",
    "install.step3Title": "Run the installer",
    "install.step3Text": "One command starts the complete setup sequence.",
    "install.step4Title": "Follow the logs",
    "install.step4Text": "Every action is clearly labeled in the terminal.",
    "install.step5Title": "Restart your shell",
    "install.step5Text": "Open a new window and get to work.",
    "install.reviewBash": "Review Bash",
    "install.reviewPython": "Review Python",
    "install.runBash": "Install with Bash",
    "install.runPython": "Install with Python",
    "snapshot.eyebrow": "System snapshot",
    "snapshot.title": "Understand first. Install second.",
    "snapshot.subtitle": "The collector reviews current packages, tools, and safe configuration metadata. The report stays on the machine and is excluded from Git.",
    "snapshot.collect": "Collect report",
    "snapshot.result": "Result",
    "security.eyebrow": "Designed to be reviewed",
    "security.title": "Security you can see in the code.",
    "security.backupTitle": "Backup before changes",
    "security.backupText": "Existing configs are saved under ~/.macos-setup-backup/.",
    "security.repeatTitle": "Safe to run again",
    "security.repeatText": "Installed components are skipped and identical files are not copied again.",
    "security.secretsTitle": "No secrets",
    "security.secretsText": "SSH keys, credentials, history, and environment data are never transferred.",
    "security.defaultsTitle": "Defaults require consent",
    "security.defaultsText": "macOS system settings remain a separate opt-in step.",
    "structure.eyebrow": "Open by design",
    "structure.title": "A simple structure.",
    "structure.subtitle": "Every layer can be reviewed, changed, or run independently.",
    "footer.text": "macOS Setup — a personal bootstrap kit for a fresh macOS workspace.",
  },
};

const supportedLanguages = Object.keys(translations);
const requestedLanguage = new URLSearchParams(window.location.search).get("lang");
const storedLanguage = window.localStorage.getItem("macos-setup-language");
let currentLanguage = supportedLanguages.includes(requestedLanguage)
  ? requestedLanguage
  : supportedLanguages.includes(storedLanguage)
    ? storedLanguage
    : "en";

const navToggle = document.querySelector(".nav-toggle");
const navLinks = document.querySelector(".nav-links");

function translate(key) {
  return translations[currentLanguage][key] ?? translations.en[key] ?? key;
}

function updateNavLabel() {
  const isOpen = navToggle?.getAttribute("aria-expanded") === "true";
  navToggle?.setAttribute("aria-label", translate(isOpen ? "nav.close" : "nav.open"));
}

function applyLanguage(language, updateUrl = false) {
  currentLanguage = supportedLanguages.includes(language) ? language : "en";
  document.documentElement.lang = currentLanguage;
  window.localStorage.setItem("macos-setup-language", currentLanguage);

  if (updateUrl) {
    const url = new URL(window.location.href);
    url.searchParams.set("lang", currentLanguage);
    window.history.replaceState({}, "", url);
  }

  document.querySelectorAll("[data-i18n]").forEach((element) => {
    element.textContent = translate(element.dataset.i18n);
  });

  document.querySelectorAll("[data-i18n-html]").forEach((element) => {
    element.innerHTML = translate(element.dataset.i18nHtml);
  });

  document.querySelectorAll("[data-i18n-content]").forEach((element) => {
    element.setAttribute("content", translate(element.dataset.i18nContent));
  });

  document.querySelectorAll("[data-i18n-aria-label]").forEach((element) => {
    element.setAttribute("aria-label", translate(element.dataset.i18nAriaLabel));
  });

  document.querySelectorAll("[data-lang]").forEach((button) => {
    const isActive = button.dataset.lang === currentLanguage;
    button.setAttribute("aria-pressed", String(isActive));
    button.classList.toggle("active", isActive);
  });

  updateNavLabel();
}

document.querySelectorAll("[data-lang]").forEach((button) => {
  button.addEventListener("click", () => applyLanguage(button.dataset.lang, true));
});

applyLanguage(currentLanguage);

const revealItems = document.querySelectorAll(".reveal");

if ("IntersectionObserver" in window) {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.remove("reveal-pending");
          entry.target.classList.add("visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12 },
  );

  revealItems.forEach((item) => {
    if (item.getBoundingClientRect().top < window.innerHeight * 1.05) {
      item.classList.add("visible");
    } else {
      item.classList.add("reveal-pending");
      observer.observe(item);
    }
  });
} else {
  revealItems.forEach((item) => item.classList.add("visible"));
}

const copyButtons = document.querySelectorAll("[data-copy]");

async function copyText(button, text) {
  try {
    await navigator.clipboard.writeText(text);
    button.textContent = translate("common.copied");
  } catch {
    button.textContent = translate("common.copyFailed");
  }

  window.setTimeout(() => {
    button.textContent = translate("common.copy");
  }, 1600);
}

copyButtons.forEach((button) => {
  button.addEventListener("click", () => {
    copyText(button, button.dataset.copy);
  });
});

navToggle?.addEventListener("click", () => {
  const isOpen = navToggle.getAttribute("aria-expanded") === "true";
  navToggle.setAttribute("aria-expanded", String(!isOpen));
  navLinks?.classList.toggle("open", !isOpen);
  updateNavLabel();
});

navLinks?.querySelectorAll("a").forEach((link) => {
  link.addEventListener("click", () => {
    navToggle?.setAttribute("aria-expanded", "false");
    navLinks.classList.remove("open");
    updateNavLabel();
  });
});
