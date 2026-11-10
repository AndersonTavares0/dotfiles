#!/usr/bin/env bash
# ==============================================================================
# Anderson's Dotfiles — Local Quality Check Harness
# Runs all syntax, unit tests, and hygiene checks locally before pushing.
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; CYAN=$'\033[0;36m'; BOLD=$'\033[1m'; NC=$'\033[0m'

printf "${BOLD}==> Anderson's Dotfiles Quality Check <==${NC}\n\n"

# 1. Shell Syntax Check
printf "${CYAN}[1/4] Verificando sintaxe de scripts Shell (bash -n / zsh -n)...${NC}\n"
bash -n install.sh
find zsh -type f -name '*.sh' -exec bash -n {} +
find zsh -type f \( -name '*.zsh' -o -name '.zshrc' \) -exec zsh -n {} +
printf "${GREEN}✓ Sintaxe Shell OK${NC}\n\n"

# 2. ShellCheck (se disponível)
printf "${CYAN}[2/4] Verificando com ShellCheck...${NC}\n"
if command -v shellcheck &>/dev/null; then
  shellcheck install.sh zsh/install.sh zsh/tests/*.sh
  printf "${GREEN}✓ ShellCheck aprovado${NC}\n\n"
else
  printf "${YELLOW}⊘ ShellCheck não encontrado no PATH (pulando verificação local)${NC}\n\n"
fi

# 3. Zsh Test Suite (ZUnit + Bats)
printf "${CYAN}[3/4] Executando suíte de testes Zsh (ZUnit + Bats)...${NC}\n"
"$ROOT_DIR/zsh/tests/run.sh"
printf "${GREEN}✓ Testes Zsh aprovados${NC}\n\n"

# 4. Git & Working Tree Hygiene
printf "${CYAN}[4/4] Verificando integridade da árvore Git...${NC}\n"
if git status --porcelain | grep -q '^[?MADRCU]'; then
  printf "${YELLOW}Aviso: existem arquivos modificados ou não rastreados no repositório:${NC}\n"
  git status --short
else
  printf "${GREEN}✓ Árvore de trabalho limpa${NC}\n"
fi

printf "\n${GREEN}${BOLD}✔ Todas as verificações locais passaram com sucesso!${NC}\n"
