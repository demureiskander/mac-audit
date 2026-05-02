#!/bin/zsh
# security.sh — инструменты кибербезопасности и пентеста

source "$(dirname "$0")/utils.sh"

scan_security() {
  log_section "ИНСТРУМЕНТЫ БЕЗОПАСНОСТИ / ПЕНТЕСТ"

  log_sub "Сетевые сканеры"
  for tool in nmap masscan netcat nc socat; do
    if has_cmd "$tool"; then
      log_ok "$tool: $($tool --version 2>&1 | head -1)"
    else
      log_skip "$tool"
    fi
  done

  log_sub "Анализ трафика"
  for tool in wireshark tshark tcpdump; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  log_sub "Web-пентест"
  for tool in burpsuite sqlmap nikto dirb gobuster ffuf wfuzz; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  log_sub "Эксплуатация"
  for tool in msfconsole msfvenom metasploit exploitdb searchsploit; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  log_sub "Пароли и криптография"
  for tool in hashcat john hydra ophcrack; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  log_sub "Реверс-инжиниринг"
  for tool in ghidra radare2 r2 gdb lldb objdump strings; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  log_sub "OSINT"
  for tool in maltego recon-ng theHarvester; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  log_sub "VPN / Анонимность"
  for tool in openvpn wireguard-tools tor proxychains; do
    if has_cmd "$tool"; then
      log_ok "$tool установлен"
    else
      log_skip "$tool"
    fi
  done

  if [[ -d "/Applications/Tor Browser.app" ]]; then
    log_ok "Tor Browser.app установлен"
  fi

  log_sub "Системный аудит"
  if has_cmd lynis; then
    log_ok "Lynis: $(lynis --version 2>/dev/null)"
  else
    log_skip "Lynis"
  fi

  log_sub "Виртуальные машины (UTM / VirtualBox / VMware)"
  for app in "UTM" "VirtualBox" "VMware Fusion"; do
    if [[ -d "/Applications/${app}.app" ]]; then
      log_ok "${app}.app установлен"
    else
      log_skip "$app"
    fi
  done

  if has_cmd vboxmanage; then
    log_sub "VirtualBox ВМ"
    run "vboxmanage list vms 2>/dev/null"
  fi
}
