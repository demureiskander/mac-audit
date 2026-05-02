#!/bin/zsh
# utils.sh — общие утилиты для всех модулей

# ── Цвета ────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

DIVIDER="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── Вывод в файл и в терминал ────────────────────────────
OUTPUT="${OUTPUT:-$HOME/Desktop/mac_audit.txt}"

log_section() {
  local title="$1"
  echo -e "\n${DIVIDER}" | tee -a "$OUTPUT"
  echo -e "📌 ${BOLD}${BLUE}${title}${RESET}" | tee -a "$OUTPUT"
  echo -e "${DIVIDER}" | tee -a "$OUTPUT"
}

log_sub() {
  local title="$1"
  echo -e "\n  ${CYAN}▸ ${title}${RESET}" | tee -a "$OUTPUT"
}

log_ok() {
  echo -e "  ${GREEN}✓${RESET} $1" | tee -a "$OUTPUT"
}

log_warn() {
  echo -e "  ${YELLOW}⚠${RESET}  $1" | tee -a "$OUTPUT"
}

log_skip() {
  echo -e "  ${RED}✗${RESET} $1 — не найдено / не установлено" | tee -a "$OUTPUT"
}

# Запустить команду и записать вывод
run() {
  local cmd="$1"
  local output
  output=$(eval "$cmd" 2>&1)
  if [[ -n "$output" ]]; then
    echo "$output" | tee -a "$OUTPUT"
  else
    echo "  (пусто)" | tee -a "$OUTPUT"
  fi
}

# Проверить наличие команды
has_cmd() {
  command -v "$1" &>/dev/null
}

# Найти файлы по расширению, показать с размером
find_files_by_ext() {
  local ext="$1"
  local search_path="${2:-$HOME}"
  find "$search_path" -name "*.${ext}" 2>/dev/null | while read -r f; do
    local size
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  ${size}  ${f}"
  done | sort -rh
}
