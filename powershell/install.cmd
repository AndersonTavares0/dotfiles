<# : batch script
@echo off & setlocal
title dotfiles - PowerShell 7 Installer
chcp 65001 >nul
echo.
echo  Baixando instalador...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p = Join-Path $env:TEMP 'dotfiles-pwsh-setup.ps1'; ^
   try { irm 'https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/powershell/setup.ps1' -OutFile $p; & $p } ^
   finally { Remove-Item $p -Force -ErrorAction SilentlyContinue }"
set "install_exit=%errorlevel%"
echo.
if "%install_exit%"=="0" (echo  Concluido.) else (echo  Falha na instalacao. Codigo: %install_exit%)
echo  Pressione qualquer tecla para sair...
pause >nul
exit /b %install_exit%
#>
# PowerShell code aqui (executado quando via irm | iex)
$p = Join-Path $env:TEMP "dotfiles-pwsh-setup-$([guid]::NewGuid().ToString('N')).ps1"
try {
    Invoke-WebRequest 'https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/powershell/setup.ps1' -OutFile $p -UseBasicParsing
    Unblock-File -Path $p -ErrorAction SilentlyContinue
    & $p
} finally {
    Remove-Item $p -Force -ErrorAction SilentlyContinue
}
