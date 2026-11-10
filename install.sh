#!/usr/bin/env bash
# shellcheck disable=SC2059,SC1091
# ==============================================================================
# Anderson's Dotfiles — Universal Unix Bootstrapper (Linux / macOS)
#
# One command for everything:
#   curl -fsSL https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/install.sh | bash
#
# Or run locally:
#   ./install.sh [options]
# ==============================================================================
set -euo pipefail

DOTFILES_URL="https://github.com/AndersonTavares0/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; NC=$'\033[0m'

# Resolve root repo directory
SCRIPT_DIR=""
if [[ "${BASH_SOURCE[0]:-}" != "" && "${BASH_SOURCE[0]}" != "bash" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

ensure_dotfiles() {
  if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/zsh" ]]; then
    DOTFILES_DIR="$SCRIPT_DIR"
    return 0
  fi

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    printf "${CYAN}Atualizando repositório dotfiles local em %s...${NC}\n" "$DOTFILES_DIR"
    if ! git -C "$DOTFILES_DIR" pull --ff-only 2>/dev/null; then
      printf "${YELLOW}Aviso: não foi possível atualizar via git pull — utilizando cópia existente.${NC}\n"
    fi
    return 0
  fi

  printf "${CYAN}Clonando dotfiles para %s...${NC}\n" "$DOTFILES_DIR"
  git clone --depth=1 "$DOTFILES_URL" "$DOTFILES_DIR"
}

run_zsh_installer() {
  local mode="$1"
  shift || true
  ensure_dotfiles

  if [[ ! -f "$DOTFILES_DIR/zsh/install.sh" ]]; then
    printf "${RED}Erro: zsh/install.sh não encontrado em %s${NC}\n" "$DOTFILES_DIR"
    exit 1
  fi

  case "$mode" in
    install)
      bash "$DOTFILES_DIR/zsh/install.sh" --install "$@"
      ;;
    interactive)
      bash "$DOTFILES_DIR/zsh/install.sh" "$@"
      ;;
    uninstall)
      bash "$DOTFILES_DIR/zsh/install.sh" --uninstall "$@"
      ;;
  esac
}

install_powershell_linux() {
  printf "${CYAN}Instalando PowerShell Core no Linux...${NC}\n"
  if command -v pwsh &>/dev/null; then
    printf "${GREEN}PowerShell Core já está instalado: $(pwsh --version)${NC}\n"
    return 0
  fi

  if command -v dnf &>/dev/null; then
    printf "${CYAN}Instalando pwsh via DNF (Fedora/RHEL)...${NC}\n"
    sudo dnf install -y powershell || {
      printf "${YELLOW}Tentando registrar repositório oficial da Microsoft...${NC}\n"
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
      sudo curl -sSL -o /etc/yum.repos.d/microsoft.repo https://packages.microsoft.com/config/rhel/9/prod.repo
      sudo dnf install -y powershell
    }
  elif command -v apt &>/dev/null; then
    printf "${CYAN}Instalando pwsh via APT (Ubuntu/Debian)...${NC}\n"
    sudo apt-get update
    sudo apt-get install -y powershell || {
      sudo apt-get install -y wget apt-transport-https software-properties-common
      source /etc/os-release
      wget -q "https://packages.microsoft.com/config/ubuntu/${VERSION_ID:-24.04}/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
      sudo dpkg -i /tmp/packages-microsoft-prod.deb
      rm -f /tmp/packages-microsoft-prod.deb
      sudo apt-get update
      sudo apt-get install -y powershell
    }
  elif command -v brew &>/dev/null; then
    printf "${CYAN}Instalando pwsh via Homebrew...${NC}\n"
    brew install --cask powershell
  else
    printf "${RED}Gerenciador de pacotes não suportado automaticamente para PowerShell.${NC}\n"
    printf "Consulte https://learn.microsoft.com/powershell/scripting/install/installing-powershell\n"
    return 1
  fi

  if command -v pwsh &>/dev/null; then
    printf "${GREEN}PowerShell Core instalado com sucesso: $(pwsh --version)${NC}\n"
  fi
}

show_root_menu() {
  clear 2>/dev/null || true
  printf "%s\n" \
    "${BOLD}╔══════════════════════════════════════════════════════════╗${NC}" \
    "${BOLD}║                Anderson's Dotfiles — v4.0                ║${NC}" \
    "${BOLD}╠══════════════════════════════════════════════════════════╣${NC}" \
    "║                                                          ║" \
    "║  ${CYAN}[1]${NC} Instalação Completa Zsh (recomendado: OMZ + P10k)       ║" \
    "║  ${CYAN}[2]${NC} Instalação Rápida Zsh (sem confirmações interativas)    ║" \
    "║  ${CYAN}[3]${NC} Instalar PowerShell Core (Linux/macOS)                   ║" \
    "║  ${CYAN}[4]${NC} Desinstalar Configurações Zsh                           ║" \
    "║  ${CYAN}[q]${NC} Sair                                                    ║" \
    "║                                                          ║" \
    "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
  printf "\nEscolha uma opção [1-4/q]: "

  local choice
  if [[ -t 0 ]]; then
    read -r choice
  elif [[ -r /dev/tty ]]; then
    read -r choice < /dev/tty
  else
    choice="1"
  fi

  case "${choice,,}" in
    1) run_zsh_installer interactive ;;
    2) run_zsh_installer install ;;
    3) install_powershell_linux ;;
    4) run_zsh_installer uninstall ;;
    q|quit|exit) printf "Saindo sem alterações.\n"; exit 0 ;;
    *) printf "${RED}Opção inválida.${NC}\n"; exit 1 ;;
  esac
}

# Non-interactive CLI flags
case "${1:-}" in
  --install|-i|--quick)
    run_zsh_installer install "${@:2}"
    ;;
  --uninstall|-u)
    run_zsh_installer uninstall "${@:2}"
    ;;
  --pwsh)
    install_powershell_linux
    ;;
  --help|-h)
    printf "Uso: %s [opções]\n\n" "$0"
    printf "Opções:\n"
    printf "  --install, -i      Instalação rápida do perfil Zsh\n"
    printf "  --uninstall, -u    Remove symlinks e cache do Zsh\n"
    printf "  --pwsh             Instala PowerShell Core no Linux/macOS\n"
    printf "  --help, -h         Exibe esta ajuda\n"
    exit 0
    ;;
  *)
    show_root_menu
    ;;
esac
