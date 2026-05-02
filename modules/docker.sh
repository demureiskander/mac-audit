#!/bin/zsh
# docker.sh — Docker образы, контейнеры, тома

source "$(dirname "$0")/modules/utils.sh"

scan_docker() {
  log_section "DOCKER"

  if ! has_cmd docker; then
    log_skip "Docker не установлен"
    return
  fi

  if ! docker info &>/dev/null; then
    log_warn "Docker установлен, но не запущен — запусти Docker Desktop"
    return
  fi

  log_ok "Docker запущен: $(docker --version)"

  log_sub "Образы (images)"
  run "docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}'"

  log_sub "Контейнеры (все)"
  run "docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"

  log_sub "Тома (volumes)"
  run "docker volume ls"

  log_sub "Сети (networks)"
  run "docker network ls"

  log_sub "Использование диска"
  run "docker system df"

  log_sub "Docker Compose проекты"
  run "find ~ -name 'docker-compose.yml' -o -name 'docker-compose.yaml' 2>/dev/null | grep -v node_modules | head -20"
  run "find ~ -name 'compose.yml' -o -name 'compose.yaml' 2>/dev/null | grep -v node_modules | head -20"
}
