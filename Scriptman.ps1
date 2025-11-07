<#
.SYNOPSIS
 Scriptman PowerShell launcher for Bash-Exercises Project.

.DESCRIPTION
 Runs local PowerShell modules under Modules\Winmod\PowerShell\
 or automatically fetches them remotely from GitHub if missing.

.AUTHOR
 Gabriel Dakinah Vincent
#>

function Scriptman {
    param(
        [Parameter(Position = 0)]
        [string]$Module,
        [Parameter(Position = 1)]
        [string[]]$ModuleArgs
    )

    # === Paths ===
    # ✅ Compatible with remote execution (no file path dependency)
    $Root = (Get-Location).Path
    $ModuleRoot = Join-Path $Root "Modules\Winmod\PowerShell"

    # === Colors ===
    function Write-Color($text, $color = 'White') {
        Write-Host $text -ForegroundColor $color
    }

    # === Banner ===
    function Show-Banner {
        Write-Color "`n=== Scriptman PowerShell Launcher ===" Magenta
        Write-Color "Environment: Windows PowerShell" Yellow
        Write-Color "Version: 1.0.3`n" DarkGray
    }
    Show-Banner

    # === Helper: Run a remote PowerShell module from GitHub ===
    function Invoke-ModuleRemote {
        param(
            [string]$RepoPath,
            [string]$ModuleScript
        )

        # ✅ Corrected raw GitHub URL format
        $rawUrl = "https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/$RepoPath/$ModuleScript"

        try {
            Write-Color "[*] Fetching remote module from GitHub..." Cyan
            $tmp = New-TemporaryFile
            Invoke-WebRequest -Uri $rawUrl -OutFile $tmp -UseBasicParsing
            Write-Color "[+] Executing remote module..." Green
            . $tmp
            Remove-Item $tmp -Force
        }
        catch {
            Write-Color "[!] Failed to fetch remote module: $_" Red
        }
    }

    # === Usage Help ===
    if (-not $Module) {
        Write-Color "Usage: Scriptman <module-name> [options]" Cyan
        Write-Host "`nAvailable Local Modules:`n"
        if (Test-Path $ModuleRoot) {
            Get-ChildItem "$ModuleRoot" -Directory | ForEach-Object { Write-Color "  - $($_.Name)" Green }
        } else {
            Write-Color "No local modules found." Yellow
        }
        return
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
                Invoke-ModuleRemote "Modules/Winmod/PowerShell/UserAudit" "UserAudit.psm1"
            }

            # === Handle Help Argument ===
            if ($ModuleArgs -and ($ModuleArgs -contains '--help' -or $ModuleArgs -contains '-h')) {
                Show-UserAuditHelp
                return
            }

            # === Run main module actions ===
            Write-Color "`n--- User Audit Report ---" Magenta
            Get-UserAudit
            Get-LocalAdmins
            Get-UserLastLogon
        }

        default {
            Write-Color "[!] Unknown module: '$Module'" Red
            Write-Color "Try: Scriptman audit-user" Cyan
            return
        }
    }

    # === Completion Message ===
    Write-Color "`n✅ Module execution complete.`n" Green
}

# === Auto-run if parameters were passed ===
if ($args.Count -gt 0) {
    Scriptman @args
}