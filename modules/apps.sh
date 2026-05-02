#!/bin/zsh
# apps.sh — установленные приложения

source "$(dirname "$0")/modules/utils.sh"

scan_apps() {
  log_section "ПРИЛОЖЕНИЯ"

  log_sub "/Applications"
  run "ls /Applications 2>/dev/null"

  log_sub "~/Applications (пользовательские)"
  if [[ -d "$HOME/Applications" ]]; then
    run "ls ~/Applications"
  else
    log_skip "~/Applications"
  fi

  log_sub "/System/Applications (системные)"
  run "ls /System/Applications 2>/dev/null"

  log_sub "Homebrew Casks"
  if has_cmd brew; then
    run "brew list --cask"
  else
    log_skip "Homebrew"
  fi

  log_sub "App Store (mas)"
  if has_cmd mas; then
    run "mas list"
  else
    log_warn "mas не установлен. Установи: brew install mas"
  fi

  log_sub "Login Items (автозапуск при входе)"
  run "osascript -e 'tell application \"System Events\" to get name of every login item' 2>/dev/null"

  log_sub "LaunchAgents пользователя (~/Library/LaunchAgents)"
  run "ls ~/Library/LaunchAgents/ 2>/dev/null || echo '  (пусто)'"

  log_sub "LaunchAgents системные (/Library/LaunchAgents)"
  run "ls /Library/LaunchAgents/ 2>/dev/null || echo '  (пусто)'"

  log_sub "LaunchDaemons (sudo)"
  if [[ "$EUID" -eq 0 ]] || sudo -n true 2>/dev/null; then
    run "sudo ls /Library/LaunchDaemons/ 2>/dev/null"
  else
    log_warn "Нет sudo — пропускаем LaunchDaemons. Запусти скрипт с sudo для полного результата"
  fi

  log_sub "Raycast Extensions"
  local raycast_ext="$HOME/Library/Application Support/com.raycast.macos/extensions"
  if [[ -d "$raycast_ext" ]]; then
    run "ls \"$raycast_ext\""
  else
    log_skip "Raycast extensions"
  fi

  log_sub "VS Code расширения"
  if has_cmd code; then
    run "code --list-extensions"
  else
    log_skip "VS Code CLI (code)"
  fi
}
