#!/bin/zsh
# languages.sh — языки программирования, рантаймы, менеджеры пакетов

source "$(dirname "$0")/utils.sh"

scan_languages() {
  log_section "ЯЗЫКИ ПРОГРАММИРОВАНИЯ И РАНТАЙМЫ"

  # ── Python ──────────────────────────────────────────────
  log_sub "Python"

  if has_cmd pyenv; then
    log_ok "pyenv установлен"
    run "pyenv versions"
  else
    log_skip "pyenv"
  fi

  for py in python3 python; do
    if has_cmd "$py"; then
      log_ok "$py: $($py --version 2>&1)"
    fi
  done

  if has_cmd pip3 || has_cmd pip; then
    log_sub "pip пакеты (системные)"
    run "pip3 list 2>/dev/null || pip list 2>/dev/null"
  fi

  if has_cmd pipx; then
    log_sub "pipx приложения"
    run "pipx list"
  else
    log_skip "pipx"
  fi

  if has_cmd poetry; then
    log_sub "Poetry проекты"
    run "poetry env list --full-path 2>/dev/null"
  else
    log_skip "poetry"
  fi

  if has_cmd conda; then
    log_sub "Conda окружения"
    run "conda env list"
  else
    log_skip "conda / miniconda"
  fi

  log_sub "Виртуальные окружения (venv) на диске"
  run "find ~ -maxdepth 6 -name 'pyvenv.cfg' -not -path '*/\.*' 2>/dev/null"

  log_sub "pip list в каждом venv"
  find ~ -maxdepth 6 -name "pyvenv.cfg" -not -path "*/\.*" 2>/dev/null | while read -r f; do
    local dir
    dir=$(dirname "$f")
    echo "\n  --- venv: $dir ---" | tee -a "$OUTPUT"
    "$dir/bin/pip" list 2>/dev/null | tee -a "$OUTPUT"
  done

  # ── Jupyter ─────────────────────────────────────────────
  log_sub "Jupyter"
  if has_cmd jupyter; then
    run "jupyter --version"
    run "jupyter kernelspec list 2>/dev/null"
  else
    log_skip "Jupyter"
  fi

  # ── Node.js ─────────────────────────────────────────────
  log_sub "Node.js"

  if has_cmd nvm; then
    log_ok "nvm установлен"
    run "nvm list 2>/dev/null"
  elif [[ -d "$HOME/.nvm" ]]; then
    log_warn "nvm папка есть (~/.nvm), но nvm не в PATH текущей сессии"
    run "ls ~/.nvm/versions/node 2>/dev/null"
  else
    log_skip "nvm"
  fi

  if has_cmd asdf; then
    log_ok "asdf установлен"
    run "asdf list 2>/dev/null"
  else
    log_skip "asdf"
  fi

  if has_cmd mise; then
    log_ok "mise установлен"
    run "mise list 2>/dev/null"
  else
    log_skip "mise"
  fi

  if has_cmd volta; then
    log_ok "volta установлен"
    run "volta list 2>/dev/null"
  else
    log_skip "volta"
  fi

  if has_cmd node; then
    log_ok "Node.js: $(node --version)"
    log_sub "npm глобальные пакеты"
    run "npm list -g --depth=0 2>/dev/null"
  else
    log_skip "Node.js"
  fi

  if has_cmd yarn; then
    log_sub "Yarn глобальные пакеты"
    run "yarn global list 2>/dev/null"
  else
    log_skip "yarn"
  fi

  if has_cmd pnpm; then
    log_sub "pnpm глобальные пакеты"
    run "pnpm list -g 2>/dev/null"
  else
    log_skip "pnpm"
  fi

  if has_cmd bun; then
    log_ok "Bun: $(bun --version)"
  else
    log_skip "bun"
  fi

  log_sub "Папки node_modules в ~/Documents"
  run "find ~/Documents -name 'node_modules' -maxdepth 5 -type d 2>/dev/null"

  # ── Rust ────────────────────────────────────────────────
  log_sub "Rust"
  if has_cmd rustc; then
    log_ok "Rust: $(rustc --version)"
    run "cargo install --list 2>/dev/null"
    run "ls ~/.cargo/bin 2>/dev/null"
  else
    log_skip "Rust / Cargo"
  fi

  # ── Go ──────────────────────────────────────────────────
  log_sub "Go"
  if has_cmd go; then
    log_ok "Go: $(go version)"
    run "ls ~/go/bin 2>/dev/null || echo '  ~/go/bin пуст'"
  else
    log_skip "Go"
  fi

  # ── Ruby ────────────────────────────────────────────────
  log_sub "Ruby"
  if has_cmd ruby; then
    log_ok "Ruby: $(ruby --version)"
    run "gem list 2>/dev/null | head -40"
  fi

  if has_cmd rbenv; then
    log_ok "rbenv установлен"
    run "rbenv versions 2>/dev/null"
  else
    log_skip "rbenv"
  fi

  if has_cmd rvm; then
    log_ok "rvm установлен"
    run "rvm list 2>/dev/null"
  else
    log_skip "rvm"
  fi

  # ── Java / JVM ──────────────────────────────────────────
  log_sub "Java / JVM"
  if has_cmd java; then
    log_ok "Java: $(java --version 2>&1 | head -1)"
    run "ls /Library/Java/JavaVirtualMachines 2>/dev/null || echo '  (пусто)'"
  else
    log_skip "Java"
  fi

  if has_cmd sdkman; then
    log_ok "SDKMAN установлен"
    run "sdk list 2>/dev/null | head -20"
  else
    log_skip "SDKMAN"
  fi

  # ── Другие языки ────────────────────────────────────────
  log_sub "Прочие языки"

  for lang in php r julia elixir swift kotlin scala dotnet lua perl zig; do
    if has_cmd "$lang"; then
      version=$("$lang" --version 2>&1 | head -1)
      log_ok "${lang}: ${version}"
    else
      log_skip "$lang"
    fi
  done

  if has_cmd flutter; then
    log_ok "Flutter: $(flutter --version 2>&1 | head -1)"
    run "flutter doctor --no-version-check 2>/dev/null | head -20"
  else
    log_skip "Flutter / Dart"
  fi

  # ── Haskell ─────────────────────────────────────────────
  log_sub "Haskell"
  if [[ -d "$HOME/.ghcup" ]]; then
    log_ok "ghcup найден"
    run "ls ~/.ghcup/ghc 2>/dev/null"
    run "ls ~/.cabal/bin 2>/dev/null"
  else
    log_skip "Haskell / ghcup"
  fi

  # ── Homebrew formulae ───────────────────────────────────
  log_sub "Homebrew Formulae (все)"
  if has_cmd brew; then
    run "brew list"
    log_sub "Homebrew Services"
    run "brew services list"
  else
    log_skip "Homebrew"
  fi

  # ── Бинарники в PATH ────────────────────────────────────
  log_sub "Бинарники: /opt/homebrew/bin"
  run "ls /opt/homebrew/bin 2>/dev/null || echo '  (пусто)'"

  log_sub "Бинарники: ~/.local/bin"
  run "ls ~/.local/bin 2>/dev/null || echo '  (пусто)'"

  log_sub "Бинарники: ~/bin"
  run "ls ~/bin 2>/dev/null || echo '  (пусто)'"

  # ── Xcode ───────────────────────────────────────────────
  log_sub "Xcode / Command Line Tools"
  if has_cmd xcode-select; then
    run "xcode-select --version 2>/dev/null"
    run "xcode-select -p 2>/dev/null"
  else
    log_skip "Xcode CLT"
  fi

  if [[ -d "/Applications/Xcode.app" ]]; then
    log_ok "Xcode.app установлен"
    run "xcodebuild -version 2>/dev/null"
  else
    log_skip "Xcode.app (только CLT)"
  fi
}
