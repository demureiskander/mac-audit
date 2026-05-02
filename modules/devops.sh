#!/bin/zsh
# devops.sh — Cloud CLI, Kubernetes, DevOps инструменты

source "$(dirname "$0")/utils.sh"

scan_devops() {
  log_section "CLOUD / DEVOPS ИНСТРУМЕНТЫ"

  # ── Cloud CLI ───────────────────────────────────────────
  log_sub "Cloud CLI"

  if has_cmd aws; then
    log_ok "AWS CLI: $(aws --version 2>&1)"
    run "aws configure list 2>/dev/null"
  else
    log_skip "AWS CLI"
  fi

  if has_cmd gcloud; then
    log_ok "Google Cloud CLI: $(gcloud --version 2>&1 | head -1)"
    run "gcloud config list 2>/dev/null"
  else
    log_skip "Google Cloud CLI"
  fi

  if has_cmd az; then
    log_ok "Azure CLI: $(az --version 2>&1 | head -1)"
  else
    log_skip "Azure CLI"
  fi

  # ── Kubernetes ──────────────────────────────────────────
  log_sub "Kubernetes"

  if has_cmd kubectl; then
    log_ok "kubectl: $(kubectl version --client --short 2>/dev/null)"
    run "kubectl config get-contexts 2>/dev/null"
  else
    log_skip "kubectl"
  fi

  if has_cmd helm; then
    log_ok "Helm: $(helm version --short 2>/dev/null)"
  else
    log_skip "helm"
  fi

  if has_cmd minikube; then
    log_ok "minikube установлен"
    run "minikube status 2>/dev/null"
  else
    log_skip "minikube"
  fi

  if has_cmd k9s; then
    log_ok "k9s установлен"
  else
    log_skip "k9s"
  fi

  # ── IaC ─────────────────────────────────────────────────
  log_sub "Infrastructure as Code"

  if has_cmd terraform; then
    log_ok "Terraform: $(terraform --version 2>&1 | head -1)"
  else
    log_skip "Terraform"
  fi

  if has_cmd ansible; then
    log_ok "Ansible: $(ansible --version 2>&1 | head -1)"
  else
    log_skip "Ansible"
  fi

  # ── Deploy платформы ────────────────────────────────────
  log_sub "Deploy / Hosting CLI"

  if has_cmd vercel; then
    log_ok "Vercel CLI: $(vercel --version 2>/dev/null)"
  else
    log_skip "Vercel CLI"
  fi

  if has_cmd railway; then
    log_ok "Railway CLI: $(railway --version 2>/dev/null)"
  else
    log_skip "Railway CLI"
  fi

  if has_cmd firebase; then
    log_ok "Firebase CLI: $(firebase --version 2>/dev/null)"
  else
    log_skip "Firebase CLI"
  fi

  if has_cmd netlify; then
    log_ok "Netlify CLI: $(netlify --version 2>/dev/null)"
  else
    log_skip "Netlify CLI"
  fi

  if has_cmd fly; then
    log_ok "Fly.io CLI: $(fly version 2>/dev/null)"
  else
    log_skip "Fly.io CLI"
  fi

  if has_cmd supabase; then
    log_ok "Supabase CLI: $(supabase --version 2>/dev/null)"
  else
    log_skip "Supabase CLI"
  fi

  # ── Базы данных (локальные серверы) ─────────────────────
  log_sub "Базы данных (локальные серверы)"

  for db in postgresql mysql mongod redis-server elasticsearch; do
    if has_cmd "$db"; then
      log_ok "$db найден"
    else
      log_skip "$db"
    fi
  done

  if has_cmd psql; then
    log_ok "PostgreSQL client: $(psql --version)"
  fi

  if has_cmd mysql; then
    log_ok "MySQL client: $(mysql --version 2>&1)"
  fi

  if has_cmd mongosh; then
    log_ok "MongoDB Shell: $(mongosh --version 2>/dev/null)"
  fi

  if has_cmd redis-cli; then
    log_ok "Redis client: $(redis-cli --version)"
  fi

  # ── Туннели ─────────────────────────────────────────────
  log_sub "Туннели / прокси"

  if has_cmd ngrok; then
    log_ok "ngrok: $(ngrok version 2>/dev/null)"
  else
    log_skip "ngrok"
  fi

  if has_cmd cloudflared; then
    log_ok "Cloudflare Tunnel: $(cloudflared --version 2>/dev/null)"
  else
    log_skip "cloudflared"
  fi
}
