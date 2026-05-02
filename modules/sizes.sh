#!/bin/zsh
# sizes.sh — использование диска, где уходит место

source "$(dirname "$0")/utils.sh"

scan_sizes() {
  log_section "ИСПОЛЬЗОВАНИЕ ДИСКА"

  log_sub "Общий обзор"
  run "df -h / 2>/dev/null"

  log_sub "Скрытые папки в ~/ (топ по размеру)"
  run "du -sh ~/.[^.]* 2>/dev/null | sort -rh | head -30"

  log_sub "~/Documents (топ)"
  run "du -sh ~/Documents/* 2>/dev/null | sort -rh | head -20"

  log_sub "~/Downloads (топ)"
  run "du -sh ~/Downloads/* 2>/dev/null | sort -rh | head -20"

  log_sub "~/Library/Application Support (топ)"
  run "du -sh ~/Library/Application\ Support/* 2>/dev/null | sort -rh | head -20"

  log_sub "~/Library/Caches (топ)"
  run "du -sh ~/Library/Caches/* 2>/dev/null | sort -rh | head -20"

  log_sub "~/Library/Containers (топ)"
  run "du -sh ~/Library/Containers/* 2>/dev/null | sort -rh | head -20"

  log_sub "Крупные файлы в ~/ (>500MB)"
  run "find ~ -size +500M -not -path '*/\.*' 2>/dev/null | while read f; do
    size=\$(du -sh \"\$f\" 2>/dev/null | cut -f1)
    echo \"  \$size  \$f\"
  done | sort -rh | head -30"

  log_sub "Крупные файлы в ~/.* скрытых папках (>500MB)"
  run "find ~ -size +500M -path '*/\.*' 2>/dev/null | while read f; do
    size=\$(du -sh \"\$f\" 2>/dev/null | cut -f1)
    echo \"  \$size  \$f\"
  done | sort -rh | head -30"
}
