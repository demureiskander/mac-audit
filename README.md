# 🔍 mac-audit

![Shell](https://img.shields.io/badge/shell-zsh-informational) ![Platform](https://img.shields.io/badge/platform-macOS-lightgrey) ![License](https://img.shields.io/badge/license-MIT-green)

Универсальный скрипт для полного аудита установленного ПО на macOS.

Показывает **что установлено, где лежит и для чего нужно** — приложения, языки программирования, AI/LLM модели, Docker, DevOps инструменты, инструменты безопасности и использование диска.

## ✨ Что сканирует

| Модуль | Что находит |
|--------|-------------|
| `apps` | /Applications, ~/Applications, Homebrew Casks, App Store, Login Items, VS Code extensions |
| `languages` | Python (pyenv, pip, venv, conda), Node.js (nvm, npm, yarn, pnpm), Rust, Go, Ruby, Java, PHP, R, Flutter, Haskell и др. |
| `ai` | Ollama, LM Studio, Jan, GPT4All, Msty, TabbyML, llama.cpp, Hugging Face, файлы `.gguf` `.safetensors` `.ckpt` |
| `docker` | Образы, контейнеры, тома, docker-compose проекты |
| `devops` | AWS/GCP/Azure CLI, kubectl, Terraform, Ansible, Vercel, Railway, Firebase, БД |
| `security` | nmap, Burp Suite, Metasploit, Wireshark, hashcat, john, radare2, Lynis |
| `sizes` | Топ папок по размеру, крупные файлы (>500MB), кэши |

## 🚀 Быстрый старт

```bash
# 1. Клонировать репозиторий
git clone https://github.com/demureiskander/mac-audit.git
cd mac-audit

# 2. Дать права на запуск
chmod +x mac_audit.sh

# 3. Запустить полный аудит
./mac_audit.sh
```

Результат сохранится в `~/Desktop/mac_audit_ДАТА_ВРЕМЯ.txt`

## 📦 Использование

```bash
# Полный аудит
./mac_audit.sh

# Отдельные модули
./mac_audit.sh apps        # только приложения
./mac_audit.sh languages   # только языки программирования
./mac_audit.sh ai          # только AI/LLM модели
./mac_audit.sh docker      # только Docker
./mac_audit.sh devops      # только DevOps инструменты
./mac_audit.sh security    # только инструменты безопасности
./mac_audit.sh sizes       # только размеры папок

# Справка
./mac_audit.sh --help
```

## 🔐 Нужен ли sudo?

Большинство функций работают **без sudo**. Sudo запрашивается только для `/Library/LaunchDaemons` — системных фоновых служб. Если отказаться, скрипт продолжит работу и просто пропустит этот раздел.

## 📋 Требования

- macOS 12 Monterey и новее
- Zsh (стандартный shell в macOS с Catalina)
- Интернет не нужен

## ⚠️ Известные ограничения

- Тестировался на macOS Tahoe 26.3, Apple M4 Pro
- Поиск `.gguf`, `.safetensors`, `.ckpt` файлов выполняется только в `~/Documents`, `~/Downloads`, `~/Desktop`, `~/MLXModels` — поиск по всему `~` зависает на больших дисках
- Поиск виртуальных окружений (venv) только в `~/Documents`
- Языки `swift`, `kotlin`, `scala`, `dotnet`, `r` не проверяются через `--version` — зависают на macOS без полного Xcode
- Docker должен быть запущен перед аудитом, иначе команды docker пропускаются

## 🤝 Contributing

Нашёл инструмент которого нет в скрипте? Открой Pull Request — добавь проверку в нужный модуль в папке `modules/`.

**Как добавить новый модуль:**

1. Создай файл `modules/mymodule.sh`:

```zsh
#!/bin/zsh
source "$(dirname "$0")/utils.sh"

scan_mymodule() {
  log_section "МОЙ МОДУЛЬ"

  log_sub "Название инструмента"
  if has_cmd mytool; then
    log_ok "mytool: $(mytool --version 2>/dev/null)"
    run "mytool list 2>/dev/null"
  else
    log_skip "mytool"
  fi
}
```

2. Подключи в `mac_audit.sh`:

```zsh
source "$SCRIPT_DIR/modules/mymodule.sh"
# ...и добавь scan_mymodule в блок case
```

## 📄 Лицензия

MIT
