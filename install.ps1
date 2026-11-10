#Requires -Version 5.1
<#
.SYNOPSIS
    Universal Windows / PowerShell Bootstrapper for Anderson's Dotfiles.
.DESCRIPTION
    Acquires the dotfiles repository (local or remote) and launches the PowerShell 7 profile installer.

    Remote flow (irm | iex):
        irm https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/install.ps1 | iex

    Local flow:
        .\install.ps1
        .\install.ps1 -Gui
        .\install.ps1 -NonInteractive
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
param(
    [switch]$NonInteractive,
    [string]$ThemeName = '',
    [switch]$Gui,
    [switch]$InstallFastfetch,
    [switch]$InstallTopgrade
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($PSVersionTable.PSVersion.Major -lt 6) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
}

$localPwshSetup = Join-Path $PSScriptRoot 'powershell/setup.ps1'
if (Test-Path -LiteralPath $localPwshSetup -PathType Leaf) {
    & $localPwshSetup -NonInteractive:$NonInteractive -ThemeName $ThemeName `
        -Gui:$Gui -InstallFastfetch:$InstallFastfetch -InstallTopgrade:$InstallTopgrade
    return
}

# Fallback: remote invocation
$setupUrl = 'https://raw.githubusercontent.com/AndersonTavares0/dotfiles/main/powershell/setup.ps1'
$tempSetup = Join-Path $env:TEMP "dotfiles-pwsh-setup-$([guid]::NewGuid().ToString('N')).ps1"
try {
    Invoke-WebRequest -Uri $setupUrl -OutFile $tempSetup -UseBasicParsing -ErrorAction Stop
    Unblock-File -Path $tempSetup -ErrorAction SilentlyContinue
    & $tempSetup -NonInteractive:$NonInteractive -ThemeName $ThemeName `
        -Gui:$Gui -InstallFastfetch:$InstallFastfetch -InstallTopgrade:$InstallTopgrade
} finally {
    Remove-Item -LiteralPath $tempSetup -Force -ErrorAction SilentlyContinue
}
