# Anderson's Dotfiles

> Cross-platform, high-performance personal development environment for Linux (Fedora-first), macOS, and Windows.

[![CI - Zsh Profile](https://github.com/AndersonTavares0/dotfiles/actions/workflows/ci-zsh.yml/badge.svg)](https://github.com/AndersonTavares0/dotfiles/actions/workflows/ci-zsh.yml)
[![CI - PowerShell Profile](https://github.com/AndersonTavares0/dotfiles/actions/workflows/ci-powershell.yml/badge.svg)](https://github.com/AndersonTavares0/dotfiles/actions/workflows/ci-powershell.yml)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue?logo=powershell)
![Zsh](https://img.shields.io/badge/Zsh-5.9%2B-f15a24?logo=zsh&logoColor=white)
![Fedora](https://img.shields.io/badge/Fedora-Linux-blue?logo=fedora)
![Windows](https://img.shields.io/badge/Windows-10%2F11-blue?logo=windows)

---

## One-Line Install

### Linux & macOS (Zsh)
```bash
curl -fsSL https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/install.sh | bash
```

### Windows (PowerShell 7)
```powershell
irm https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/install.ps1 | iex
```

---

## Architecture Overview

```text
dotfiles/
├── install.sh                  # Bootstrap Unix (curl ... | bash)
├── install.ps1                 # Bootstrap Windows (irm ... | iex)
├── zsh/                        # Modular Zsh Configuration
│   ├── .zshrc                  # Entrypoint
│   ├── .p10k.zsh               # Powerlevel10k theme configuration
│   ├── modules/                # boot, core, plugins, tools
│   ├── tests/                  # ZUnit + Bats test suite
│   └── docs/TECHNICAL.md       # Deep technical documentation
├── powershell/                 # Modular PowerShell 7+ Configuration
│   ├── Microsoft.PowerShell_profile.ps1 # Profile Entrypoint
│   ├── modules/                # cache, config, git, nav, psreadline, system, text_utils
│   ├── setup/                  # CLI & GUI installer engine
│   ├── themes/                 # Oh My Posh themes
│   ├── tests/                  # Pester & Unit test suite
│   └── docs/                   # Modules, auditing, and troubleshooting guides
├── shared/                     # Cross-platform shared configs
│   ├── git/                    # .gitconfig base
│   └── fastfetch/              # Fastfetch system info layout
├── docs/
│   └── cross-shell-cheatsheet.md # Parity cheatsheet between Zsh & PWSH
└── AGENTS.md                   # Engineering standards & guidelines for AI assistants
```

---

## Key Features

### Zsh Environment (`zsh/`)
- **Fast Startup**: <150ms boot time with Powerlevel10k instant prompt and bytecode compilation (`.zshrc.zwc`).
- **Smart Plugin Caching**: Tool fingerprinting via `cksum` for `zoxide` and `fzf` without slow disk queries.
- **In-Shell Security Safeguards**: `zshaddhistory` filters tokens, secrets, API keys, passwords, and long commands.
- **Sudo Guard**: `sudo-last` intercepts dangerous commands (`rm -rf /`, `mkfs`, `dd`, `chmod 777`).
- **Productive Utilities**: `mkcd`, `up [n]`, `dtop`, `nf`, `gcom`, `lazyg`, `sedi`, `extract`, `bk`, `port`.
- **Fedora & NVIDIA Integration**: `gpu-status`, `rpmfusion-check`, `akmods-status`, and CUDA helpers.

### PowerShell Environment (`powershell/`)
- **Strict Mode Loading**: High reliability with `Set-StrictMode -Version Latest`.
- **TTL Cache System**: 24h caching for Oh My Posh and Zoxide hot path (~5ms cache validation).
- **Zero Elevation Linking**: Maintains a marked stub in `$PROFILE.CurrentUserAllHosts` without replacing user content.
- **Cross-Platform Compatibility**: Full Windows 10/11 x64 target with fallback and support for PowerShell Core.
- **Dual Installer**: Interactive terminal setup or full WPF GUI with theme preview.

### Cross-Shell Parity
Check out the [Cross-Shell Cheatsheet](docs/cross-shell-cheatsheet.md) for command mapping between Fedora and Windows environments.

---

## Testing & Quality Gates

Run local test suites:

```bash
# Zsh test suite (Syntax + ZUnit + Bats)
./zsh/tests/run.sh

# PowerShell test suite (run under Windows/pwsh)
pwsh -File powershell/tests/Unit.Tests.ps1
```

---

## License

MIT © [Anderson Tavares](https://github.com/AndersonTavares0)
