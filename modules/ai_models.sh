#!/bin/zsh
# ai_models.sh — LLM модели, AI инструменты, генеративные модели

source "$(dirname "$0")/utils.sh"

scan_ai() {
  log_section "AI / LLM МОДЕЛИ И ИНСТРУМЕНТЫ"

  # ── Ollama ──────────────────────────────────────────────
  log_sub "Ollama"
  if has_cmd ollama; then
    log_ok "Ollama установлена"
    run "ollama list 2>/dev/null || echo '  (сервер не запущен — запусти ollama serve)'"
    log_sub "Ollama — файлы моделей (~/.ollama/models)"
    run "du -sh ~/.ollama/models/blobs/* 2>/dev/null | sort -rh | head -30 || echo '  (пусто)'"
  else
    log_skip "Ollama"
    if [[ -d "$HOME/.ollama" ]]; then
      log_warn "Папка ~/.ollama существует (остатки?)"
      run "du -sh ~/.ollama/*"
    fi
  fi

  # ── LM Studio ───────────────────────────────────────────
  log_sub "LM Studio"
  if [[ -d "$HOME/.cache/lm-studio" ]]; then
    log_ok "LM Studio кэш найден"
    run "find ~/.cache/lm-studio/models -maxdepth 4 -type d 2>/dev/null"
    log_sub "LM Studio — размеры моделей"
    run "du -sh ~/.cache/lm-studio/models/*/* 2>/dev/null | sort -rh || echo '  (пусто)'"
  else
    log_skip "LM Studio (~/.cache/lm-studio)"
  fi

  # ── Hugging Face ────────────────────────────────────────
  log_sub "Hugging Face кэш (~/.cache/huggingface)"
  if [[ -d "$HOME/.cache/huggingface" ]]; then
    log_ok "HuggingFace кэш найден"
    run "du -sh ~/.cache/huggingface 2>/dev/null"
    run "find ~/.cache/huggingface -maxdepth 5 -type d 2>/dev/null"
  else
    log_skip "Hugging Face кэш"
  fi

  # ── MLX (Apple Silicon) ─────────────────────────────────
  log_sub "MLX модели (~/MLXModels)"
  if [[ -d "$HOME/MLXModels" ]]; then
    log_ok "MLXModels найден"
    run "du -sh ~/MLXModels/* 2>/dev/null | sort -rh"
  else
    log_skip "MLXModels"
  fi

  # ── Jan ─────────────────────────────────────────────────
  log_sub "Jan App"
  local jan_path="$HOME/Library/Application Support/jan"
  if [[ -d "$jan_path" ]]; then
    log_ok "Jan найден"
    run "find \"$jan_path\" -maxdepth 4 -type d 2>/dev/null"
    run "du -sh \"$jan_path/models\"/* 2>/dev/null | sort -rh || echo '  (моделей нет)'"
  else
    log_skip "Jan"
  fi

  # ── AnythingLLM ─────────────────────────────────────────
  log_sub "AnythingLLM"
  local allm_path="$HOME/Library/Application Support/anythingllm-desktop"
  if [[ -d "$allm_path" ]]; then
    log_ok "AnythingLLM найден"
    run "ls \"$allm_path\" 2>/dev/null"
  else
    log_skip "AnythingLLM"
  fi

  # ── GPT4All ─────────────────────────────────────────────
  log_sub "GPT4All"
  local gpt4all_path="$HOME/Library/Application Support/nomic.ai/GPT4All"
  if [[ -d "$gpt4all_path" ]]; then
    log_ok "GPT4All найден"
    run "du -sh \"$gpt4all_path\"/* 2>/dev/null | sort -rh"
  else
    log_skip "GPT4All"
  fi

  # ── Msty ────────────────────────────────────────────────
  log_sub "Msty"
  local msty_path="$HOME/Library/Application Support/msty"
  if [[ -d "$msty_path" ]]; then
    log_ok "Msty найден"
    run "du -sh \"$msty_path\"/* 2>/dev/null | sort -rh"
  else
    log_skip "Msty"
  fi

  # ── TabbyML ─────────────────────────────────────────────
  log_sub "TabbyML (~/.tabby)"
  if [[ -d "$HOME/.tabby" ]]; then
    log_ok "Tabby найден"
    run "du -sh ~/.tabby/* 2>/dev/null | sort -rh"
  else
    log_skip "TabbyML"
  fi

  # ── llama.cpp ───────────────────────────────────────────
  log_sub "llama.cpp"
  if has_cmd llama || has_cmd llama-cli; then
    log_ok "llama.cpp найден в PATH"
  else
    log_skip "llama.cpp"
  fi

  # ── text-generation-webui (oobabooga) ───────────────────
  log_sub "text-generation-webui (oobabooga)"
  run "find ~ -maxdepth 4 -type d -name 'text-generation-webui' 2>/dev/null"
  run "find ~ -maxdepth 4 -type d -name 'oobabooga' 2>/dev/null"

  # ── Stable Diffusion / ComfyUI / InvokeAI ───────────────
  log_sub "Stable Diffusion и генеративные инструменты"
  run "find ~ -maxdepth 4 -type d 2>/dev/null | grep -iE 'comfy|stable.diff|invokeai|automatic1111|fooocus|diffusion' | grep -v '.git'"

  # ── Open WebUI ──────────────────────────────────────────
  log_sub "Open WebUI"
  local webui_data="$HOME/Library/Application Support/open-webui"
  if [[ -d "$webui_data" ]]; then
    log_ok "Open WebUI данные найдены"
    run "ls \"$webui_data\""
  else
    log_warn "Open WebUI скорее всего в Docker — проверь модуль docker.sh"
  fi

  # ── LocalAI ─────────────────────────────────────────────
  log_sub "LocalAI"
  if has_cmd local-ai || has_cmd localai; then
    log_ok "LocalAI найден в PATH"
  else
    log_skip "LocalAI (CLI)"
  fi
  run "find ~ -maxdepth 4 -type d -name 'localai' 2>/dev/null"

  # ── Поиск файлов моделей по расширению ──────────────────
  log_sub "Файлы .gguf (GGUF — LLaMA, Gemma, Qwen, Mistral...)"
  local gguf_found=0
  find ~ -maxdepth 4 -name "*.gguf" 2>/dev/null | while read -r f; do
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  ${size}  ${f}" | tee -a "$OUTPUT"
    gguf_found=1
  done
  [[ $gguf_found -eq 0 ]] && log_skip ".gguf файлы"

  log_sub "Файлы .safetensors (Stable Diffusion, transformers...)"
  local st_found=0
  find ~ -maxdepth 4 -name "*.safetensors" 2>/dev/null | while read -r f; do
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  ${size}  ${f}" | tee -a "$OUTPUT"
    st_found=1
  done
  [[ $st_found -eq 0 ]] && log_skip ".safetensors файлы"

  log_sub "Файлы .ckpt (Stable Diffusion checkpoint)"
  find ~ -maxdepth 4 -name "*.ckpt" 2>/dev/null | while read -r f; do
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  ${size}  ${f}" | tee -a "$OUTPUT"
  done || log_skip ".ckpt файлы"

  log_sub "Файлы pytorch_model*.bin (PyTorch модели)"
  find ~ -maxdepth 4 -name "pytorch_model*.bin" 2>/dev/null | while read -r f; do
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  ${size}  ${f}" | tee -a "$OUTPUT"
  done || log_skip "pytorch_model.bin файлы"

  log_sub "Файлы .mlpackage / .mlmodel (CoreML модели)"
  find ~ -maxdepth 4 \( -name "*.mlpackage" -o -name "*.mlmodel" \) 2>/dev/null | while read -r f; do
    size=$(du -sh "$f" 2>/dev/null | cut -f1)
    echo "  ${size}  ${f}" | tee -a "$OUTPUT"
  done || log_skip ".mlpackage / .mlmodel файлы"

  # ── Общий поиск AI-папок ────────────────────────────────
  log_sub "Другие AI-папки (поиск по ключевым словам)"
  run "find ~ -maxdepth 4 -type d 2>/dev/null | grep -iE '(llm|gpt|llama|gemma|qwen|mistral|phi|falcon|vicuna|alpaca|wizard|neural|diffusion|embedding|checkpoint|model.weights)' | grep -v '.git' | grep -v 'node_modules' | head -30"
}
