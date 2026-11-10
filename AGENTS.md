# dotfiles — Agent & Engineering Guide

Welcome to **Anderson Tavares's Dotfiles Monorepo**. This repository houses cross-platform modular configurations for **Zsh** (Linux/Fedora & macOS) and **PowerShell 7+** (Windows & PowerShell Core).

---

## 1. Monorepo Architecture & Subsystems

```text
dotfiles/
├── .github/workflows/          # CI Matrix (Ubuntu, macOS, Windows 2022/2025)
├── install.sh                  # Root Unix installer (delegates to zsh/install.sh)
├── install.ps1                 # Root Windows installer (delegates to powershell/setup.ps1)
├── zsh/                        # Fedora-first Zsh environment (Oh My Zsh + P10k)
├── powershell/                 # Windows-first PowerShell 7+ environment (Oh My Posh)
├── shared/                     # Shared configs (git, fastfetch, cheatsheet)
└── docs/                       # Monorepo architecture & cross-shell documentation
```

### Isolation Boundary
- Changes affecting **Zsh** belong exclusively in `zsh/`.
- Changes affecting **PowerShell** belong exclusively in `powershell/`.
- Root bootstrappers (`install.sh`, `install.ps1`) delegate into subsystem entrypoints. Never break standalone execution of `zsh/install.sh` or `powershell/setup.ps1`.

---

## 2. Zsh Subsystem Rules (`zsh/`)

### Execution Order in `.zshrc`
1. **Powerlevel10k Instant Prompt** MUST be the very first line sourced (zero output before this).
2. **Boot timer starts** immediately after prompt initialization.
3. **Environment & PATH deduplication** (`core/environment.zsh`).
4. **Plugin init cache** (`plugins/cache.zsh`) validates tool versions via `cksum` before loading frameworks.
5. **Oh My Zsh & plugins** (`plugins/omz.zsh`).
6. **Aliases & functions** (`tools/aliases.zsh`, `tools/functions.zsh`, `tools/nvidia.zsh`).
7. **Local overrides** (`tools/local.zsh` for `~/.zshrc.local`).
8. **Theme loading** (`boot/theme.zsh`).
9. **Bytecode compilation** (`boot/compile.zsh` via background `zcompile`).
10. **Timer end** (`boot/timer-end.zsh`).

### Security Hooks
- `zshaddhistory`: Silently blocks credential patterns from history (`TOKEN`, `SECRET`, `PASSWORD`, `API_KEY`, URL tokens, AWS credentials, SSH keys, GPG passphrases, commands > 4096 chars).
- `sudo-last`: Blocks dangerous commands (`rm -rf /`, `mkfs`, `dd of=`, `chmod -R 777 /`) and requires confirmation for other root actions.

### Testing Zsh
Always run tests from repository root or `zsh/`:
```bash
./zsh/tests/run.sh
```
This executes `zsh -n` syntax check, `bash -n`, ZUnit suite (42 tests), and Bats install suite.

---

## 3. PowerShell Subsystem Rules (`powershell/`)

### Strict Mode & Error Handling
- Every script MUST declare `#Requires -Version 5.1`.
- `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'` during profile and module loading.
- Revert `$ErrorActionPreference` to user's interactive preference upon exit.
- No bare `catch {}` blocks — always log `$_.Exception.Message`.

### Profile Target & Managed Block
- Target: `$PROFILE.CurrentUserAllHosts`.
- Marker block:
  ```powershell
  # >>> dotfiles >>>
  # Managed by dotfiles. Changes inside this block are replaced.
  . '<dotfiles_path>\powershell\Microsoft.PowerShell_profile.ps1'
  # <<< dotfiles <<<
  ```
- Retain backward compatibility: `powershell/setup/modules/profile.ps1` recognizes both `config-powershell7` and `dotfiles` stubs to ensure seamless upgrades without duplicate execution.

### Plugin Boot Cache
- Managed by `modules/cache/cache.ps1` with 24-hour TTL.
- Fingerprints `oh-my-posh` and `zoxide` using `LastWriteTime` + file size.
- Hot path takes <5ms validation skipping `Get-Command` and hash recalculation.

### Testing PowerShell
Run tests using `pwsh`:
```powershell
pwsh -File powershell/tests/Unit.Tests.ps1 -Verbose
pwsh -File powershell/tests/Microsoft.PowerShell_profile.Tests.ps1 -Verbose
pwsh -File powershell/tests/Setup.Tests.ps1 -Verbose
pwsh -File powershell/tests/WindowsCompatibility.Tests.ps1
```

---

## 4. Git & Commit Guidelines

- Format: Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `chore:`).
- Specify scope when applicable: `feat(zsh): ...`, `fix(pwsh): ...`, `refactor(ci): ...`.
- Never bypass linting or tests before committing.
