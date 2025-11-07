<#
.SYNOPSIS
 Scriptman PowerShell launcher for Bash-Exercises Project.

.DESCRIPTION
 Runs local PowerShell modules under modules\Winmod\powershell\
 or automatically fetches them remotely from GitHub if missing.

.AUTHOR
 Gabriel Dakinah Vincent
#>

param(
    [Parameter(Position = 0)]
    [string]$Module,
    [Parameter(Position = 1)]
    [string[]]$Args
)

# === Paths ===
$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ModuleRoot = Join-Path $Root "modules\Winmod\powershell"

# === Colors ===
function Write-Color($text, $color = 'White') {
    Write-Host $text -ForegroundColor $color
}

# === Banner ===
function Show-Banner {
    Write-Color "`n=== Scriptman PowerShell Launcher ===" Magenta
    Write-Color "Environment: Windows PowerShell" Yellow
    Write-Color "Version: 1.0.0`n" DarkGray
}
Show-Banner

# === Helper: Run a remote PowerShell module from GitHub ===
function Invoke-ModuleRemote {
    param(
        [string]$RepoPath,
        [string]$ModuleScript
    )

    $rawUrl = "https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/$RepoPath/$ModuleScript"

    try {
        Write-Color "[*] Fetching remote module from GitHub..." Cyan
        $tmp = New-TemporaryFile
        Invoke-WebRequest -Uri $rawUrl -OutFile $tmp -UseBasicParsing
        Write-Color "[+] Executing module remotely..." Green
        . $tmp
        Remove-Item $tmp -Force
    }
    catch {
        Write-Color "[!] Failed to fetch remote module: $_" Red
    }
}

# === Usage Help ===
if (-not $Module) {
    Write-Color "Usage: .\Scriptman.ps1 <module-name> [options]" Cyan
    Write-Host "`nAvailable Local Modules:`n"
    if (Test-Path $ModuleRoot) {
        Get-ChildItem "$ModuleRoot" -Directory | ForEach-Object { Write-Color "  - $($_.Name)" Green }
    } else {
        Write-Color "No local modules found." Yellow
    }
    exit
}

# === Dispatcher ===
switch ($Module.ToLower()) {
    'audit-user' {
        $ModulePath = Join-Path $ModuleRoot "UserAudit\UserAudit.psm1"
        if (Test-Path $ModulePath) {
            Write-Color "[+] Loading local module: UserAudit" Cyan
            Import-Module $ModulePath -Force
        }
        else {
            Write-Color "[!] Local module not found. Running remotely..." Yellow
            Invoke-ModuleRemote "modules/Winmod/powershell/UserAudit" "UserAudit.psm1"
            exit
        }

        # === Handle Help Argument ===
        if ($Args -and ($Args -contains '--help' -or $Args -contains '-h')) {
            Show-UserAuditHelp
            exit
        }

        # === Run main module actions ===
        Write-Color "`n--- User Audit Report ---" Magenta
        Get-UserAudit
        Get-LocalAdmins
        Get-UserLastLogon
    }

    default {
        Write-Color "[!] Unknown module: '$Module'" Red
        Write-Color "Try: .\Scriptman.ps1 audit-user" Cyan
    }
}