#!/bin/zsh
# ╔══════════════════════════════════════════════════════════╗
# ║              mac-audit — полный аудит macOS              ║
# ║         github.com/demureiskander/mac-audit              ║
# ╚══════════════════════════════════════════════════════════╝
#
# Использование:
#   ./mac_audit.sh              — полный аудит
#   ./mac_audit.sh apps         — только приложения
#   ./mac_audit.sh languages    — только языки
#   ./mac_audit.sh ai           — только AI/LLM
#   ./mac_audit.sh docker       — только Docker
#   ./mac_audit.sh devops       — только DevOps
#   ./mac_audit.sh security     — только безопасность
#   ./mac_audit.sh sizes        — только размеры
#   ./mac_audit.sh --help       — эта справка

set -euo pipefail

# ── Пути ────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export OUTPUT="$HOME/Desktop/mac_audit_$(date '+%Y%m%d_%H%M%S').txt"

# ── Загрузка модулей ────────────────────────────────────────
source "$SCRIPT_DIR/modules/utils.sh"
source "$SCRIPT_DIR/modules/apps.sh"
source "$SCRIPT_DIR/modules/languages.sh"
source "$SCRIPT_DIR/modules/ai_models.sh"
source "$SCRIPT_DIR/modules/docker.sh"
source "$SCRIPT_DIR/modules/devops.sh"
source "$SCRIPT_DIR/modules/security.sh"
source "$SCRIPT_DIR/modules/sizes.sh"

# ── Заголовок ───────────────────────────────────────────────
print_header() {
  echo "" | tee "$OUTPUT"
  echo "╔══════════════════════════════════════════════════════════╗" | tee -a "$OUTPUT"
  echo "║                    mac-audit v1.0                        ║" | tee -a "$OUTPUT"
  echo "║              Полный аудит установленного ПО              ║" | tee -a "$OUTPUT"
  echo "╚══════════════════════════════════════════════════════════╝" | tee -a "$OUTPUT"
  echo "" | tee -a "$OUTPUT"
  echo "  📅 Дата:    $(date '+%d.%m.%Y %H:%M:%S')" | tee -a "$OUTPUT"
  echo "  💻 Машина:  $(scutil --get ComputerName 2>/dev/null || hostname)" | tee -a "$OUTPUT"
  echo "  👤 Юзер:    $USER" | tee -a "$OUTPUT"
  echo "  🍎 macOS:   $(sw_vers -productVersion 2>/dev/null) ($(sw_vers -buildVersion 2>/dev/null))" | tee -a "$OUTPUT"
  echo "  🏛️  Arch:   $(uname -m)" | tee -a "$OUTPUT"
  echo "  📄 Лог:     $OUTPUT" | tee -a "$OUTPUT"
  echo "" | tee -a "$OUTPUT"
}

# ── Справка ─────────────────────────────────────────────────
print_help() {
  echo ""
  echo "Использование: ./mac_audit.sh [модуль]"
  echo ""
  echo "Доступные модули:"
  echo "  (без аргументов)  — полный аудит всех модулей"
  echo "  apps              — приложения и автозапуск"
  echo "  languages         — языки программирования и рантаймы"
  echo "  ai                — AI/LLM модели и инструменты"
  echo "  docker            — Docker образы, контейнеры, тома"
  echo "  devops            — Cloud CLI, Kubernetes, DevOps"
  echo "  security          — инструменты безопасности и пентеста"
  echo "  sizes             — использование диска"
  echo ""
  echo "Пример:"
  echo "  ./mac_audit.sh ai       # только AI модели"
  echo "  ./mac_audit.sh sizes    # только размеры папок"
  echo ""
}

# ── Финальный итог ──────────────────────────────────────────
print_footer() {
  echo "" | tee -a "$OUTPUT"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$OUTPUT"
  echo "✅ Аудит завершён: $OUTPUT" | tee -a "$OUTPUT"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$OUTPUT"
  echo "" | tee -a "$OUTPUT"
  echo "💡 Совет: прикрепи $OUTPUT в чат с Claude для анализа" | tee -a "$OUTPUT"
}

# ── Запуск ──────────────────────────────────────────────────
main() {
  local module="${1:-all}"

  case "$module" in
    --help|-h|help)
      print_help
      exit 0
      ;;
  esac

  print_header

  case "$module" in
    all)
      scan_apps
      scan_languages
      scan_ai
      scan_docker
      scan_devops
      scan_security
      scan_sizes
      ;;
    apps)       scan_apps ;;
    languages)  scan_languages ;;
    ai)         scan_ai ;;
    docker)     scan_docker ;;
    devops)     scan_devops ;;
    security)   scan_security ;;
    sizes)      scan_sizes ;;
    *)
      echo "❌ Неизвестный модуль: $module"
      print_help
      exit 1
      ;;
  esac

  print_footer
}

main "${1:-all}"
