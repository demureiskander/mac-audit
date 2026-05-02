#!/bin/zsh
# sizes.sh — использование диска, где уходит место

source "$(dirname "$0")/utils.sh"

scan_sizes() {
  log_section "ИСПОЛЬЗОВАНИЕ ДИСКА"

  log_sub "Общий обзор"
  run "df -h / 2>/dev/null"

  log_sub "Скрытые папки в ~/ (топ по размеру)"
  for dir in ~/.ollama ~/.cache ~/.local ~/.npm ~/.cargo ~/.go ~/.nvm ~/.pyenv ~/.config ~/.docker ~/.vscode; do
    if [[ -d "$dir" ]]; then
      size=$(du -sh "$dir" 2>/dev/null | cut -f1)
      echo "  $size  $dir" | tee -a "$OUTPUT"
    fi
  done

  log_sub "~/Documents (топ)"
  run "find ~/Documents -maxdepth 1 -mindepth 1 -exec du -sh {} \; 2>/dev/null | sort -rh | head -20"

  log_sub "~/Downloads (топ)"
  run "find ~/Downloads -maxdepth 1 -mindepth 1 -exec du -sh {} \; 2>/dev/null | sort -rh | head -20"

  log_sub "~/Library/Application Support (топ)"
  run "find ~/Library/Application\ Support -maxdepth 1 -mindepth 1 -exec du -sh {} \; 2>/dev/null | sort -rh | head -20"

  log_sub "~/Library/Caches (топ)"
  run "find ~/Library/Caches -maxdepth 1 -mindepth 1 -exec du -sh {} \; 2>/dev/null | sort -rh | head -20"

}
