<#
.SYNOPSIS
 UserAudit launcher - imports the module (psm1) and runs its default actions.

.DESCRIPTION
 This launcher allows direct execution of the UserAudit module (local or remote).
 It accepts --help / -h to show module help.
#>

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ModulePsm1 = Join-Path $PSScriptRoot "UserAudit.psm1"

if (Test-Path $ModulePsm1) {
    Write-Host "[+] Importing local UserAudit module..." -ForegroundColor Cyan
    Import-Module $ModulePsm1 -Force
}
else {
    Write-Host "[!] Local module not found. Attempting remote fetch..." -ForegroundColor Yellow
    $branch = "b6se_"
    $remote = "https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/$branch/modules/Winmod/powershell/UserAudit/UserAudit.psm1"
    try {
        $tmp = [System.IO.Path]::GetTempFileName()
        Invoke-WebRequest -Uri $remote -OutFile $tmp -UseBasicParsing -ErrorAction Stop
        . $tmp
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "[✗] Failed to download remote module: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# If args include --help or -h, show help
if ($Args -and ($Args -contains '--help' -or $Args -contains '-h')) {
    Show-UserAuditHelp
    exit 0
}

# Default behavior: run all key audit functions
Write-Host "`n--- User Audit Report (launcher) ---" -ForegroundColor Magenta
Get-UserAudit
Get-LocalAdmins
Get-UserLastLogon