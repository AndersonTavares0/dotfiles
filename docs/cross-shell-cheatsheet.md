# Guia de Equivalência Cross-Shell: Zsh vs PowerShell 7

Este guia consolida os atalhos, comandos e funções disponíveis nas duas shells do ecossistema `dotfiles`.

---

## 1. Navegação e Manipulação de Diretórios

| Ação | Fedora / Linux / macOS (`zsh`) | Windows 10/11 (`pwsh 7`) | Detalhes |
|---|---|---|---|
| Ir para o Desktop | `dtop` | `dtop` | Resolve dinamicamente `~/Desktop` |
| Ir para Documentos | `cd ~/Documents` | `docs` | Resolve caminho em `AppData` / `UserProfile` |
| Ir para Downloads | `cd ~/Downloads` | `dl` | Atalho rápido para pasta Downloads |
| Subir N diretórios | `up [n]` (ex: `up 3`) | `up [n]` (ex: `up 3`) | Sobe `n` níveis ou 1 se omitido |
| Criar pasta e entrar | `mkcd <pasta>` | `mkcd <pasta>` | Cria recursivamente e altera diretório |
| Salto inteligente | `z <termo>` (zoxide) | `z <termo>` (zoxide) | Indexação por frequência de acesso |

---

## 2. Produtividade e Git

| Ação | Fedora / Linux / macOS (`zsh`) | Windows 10/11 (`pwsh 7`) | Detalhes |
|---|---|---|---|
| Status conciso | `gst` | `gst` | `git status -sb` |
| Commit rápido | `gcom "<mensagem>"` | `gcmt "<mensagem>"` | `gcmt` no PS evita colisão com `Get-Command` |
| Log gráfico | `gl` | `gl` | Visualização de branches em grafo |
| Stage de tudo | `gaa` | `gaa` | `git add --all` |
| Push | `gp` | `gp` | `git push` |
| Pull | `gpl` | `gpl` | `git pull` |
| Switch / Checkout | `gco <branch>` | `gco <branch>` | Alterna branch |
| Commit interativo | `lazyg "<mensagem>"` | — | Confirmação com timeout de 10s para push |

---

## 3. Diagnóstico e Sistema

| Ação | Fedora / Linux / macOS (`zsh`) | Windows 10/11 (`pwsh 7`) | Detalhes |
|---|---|---|---|
| Medir tempo de boot | `zshrc-time` | Painel de startup / `benchmark.ps1` | Diagnóstico de latência de inicialização |
| Listagem com ícones | `ls`, `ll`, `la`, `l`, `lt` (`eza`) | `ls`, `ll`, `la` (`eza` ou `Terminal-Icons`) | Ícones Nerd Font e flags de cores |
| Portas em escuta | `port [num]` (`ss -tulpn`) | `ports [num]` (`Get-NetTCPConnection`) | Diagnóstico de portas TCP/UDP |
| Matar processo em porta | `fuser -k <porta>/tcp` | `killport <porta>` | Encerra processo associado |
| Backup timestamped | `bk <arquivo>` | `bk <arquivo>` | Cria `<arquivo>.bak.YYYYMMDD_HHMMSS` |
| Limpeza de sistema | `sys-clean`, `dnf-clean` | `clean-cache` | Limpa caches de pacotes e temporários |
| GPU NVIDIA | `gpu-status`, `akmods-status` | `nvidia-smi` | Diagnóstico de driver e aceleração |

---

## 4. Prompt e Temas

| Shell | Engine de Prompt | Arquivo de Configuração | Cache |
|---|---|---|---|
| **Zsh** | Powerlevel10k (Instant Prompt) | `zsh/.p10k.zsh` | `$XDG_CACHE_HOME/p10k-instant-prompt-...` |
| **PowerShell 7** | Oh My Posh (`atomic` theme) | `powershell/themes/atomic.omp.json` | `$HOME/.cache_pwsh_plugins.ps1` (TTL 24h) |
