<#
.SYNOPSIS
 Scriptman PowerShell launcher for the Bash-Exercises Project.

.DESCRIPTION
 Runs PowerShell modules locally or remotely as defined in the core/psm-manifest.json registry.
 Automatically fetches modules from GitHub if missing locally or if Scriptman is executed remotely.

.AUTHOR
 Gabriel Dakinah Vincent
.VERSION
 2.0.2
#>

function Scriptman {
    param(
        [Parameter(Position = 0)]
        [string]$Module,
        [Parameter(Position = 1)]
        [string[]]$ModuleArgs
    )

    # === Paths ===
    $Root = (Get-Location).Path
    $ManifestPath = Join-Path $Root "core\psm-manifest.json"

    # === Colors ===
    function Write-Color($text, $color = 'White') {
        Write-Host $text -ForegroundColor $color
    }

    # === Banner ===
    function Show-Banner {
        Write-Color "`n=== Scriptman PowerShell Launcher ===" Magenta
        Write-Color "Environment: Windows PowerShell" Yellow
        Write-Color "Version: 2.0.2`n" DarkGray
    }
    Show-Banner

    # === Load Manifest ===
    $Manifest = $null
    if (Test-Path $ManifestPath) {
        try {
            $Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
            Write-Color "[+] Loaded local manifest successfully." Green
        }
        catch {
            Write-Color "[!] Failed to parse local manifest: $_" Red
        }
    }

    # --- Remote fallback if no local manifest ---
    if (-not $Manifest) {
        Write-Color "[!] Local manifest not found. Fetching remote version..." Yellow
        $ManifestUrl = "https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/core/psm-manifest.json"
        try {
            $Manifest = Invoke-RestMethod -Uri $ManifestUrl | ConvertFrom-Json
            Write-Color "[+] Loaded remote manifest successfully." Green
        }
        catch {
            Write-Color "[!] Failed to load manifest locally or remotely: $_" Red
            return
        }
    }

    # === Helper: Fetch and import remote PowerShell module ===
    function Invoke-ModuleRemote {
        param(
            [string]$Url
        )
        try {
            Write-Color "[*] Fetching remote module from GitHub..." Cyan
            $tmpPath = Join-Path $env:TEMP ("RemoteModule_" + (Get-Random) + ".psm1")
            Invoke-WebRequest -Uri $Url -OutFile $tmpPath -UseBasicParsing
            Write-Color "[+] Importing remote module..." Green
            Import-Module $tmpPath -Force
            Remove-Item $tmpPath -Force
        }
        catch {
            Write-Color "[!] Failed to fetch or import remote module: $_" Red
        }
    }

    # === Usage Help ===
    if (-not $Module) {
        Write-Color "Usage: Scriptman <module-name> [options]" Cyan
        Write-Host "`nAvailable Modules:`n"
        foreach ($key in $Manifest.PSObject.Properties.Name) {
            $info = $Manifest.$key
            $type = if ($info.type -eq "remote") { "Remote" } else { "Local" }
            Write-Color ("  - {0} ({1})" -f $key, $type) Green
        }
        return
    }

    # === Dispatcher using Manifest ===
    $normalized = $Module -replace '-', ''
    $matchedKey = $Manifest.PSObject.Properties.Name | Where-Object { ($_ -replace '-', '') -ieq $normalized }

    if ($matchedKey) {
        Write-Color "[i] Matched requested name '$Module' to manifest key '$matchedKey'." DarkGray
        $entry = $Manifest.$matchedKey

        if ($entry.type -eq "local") {
            $ModulePath = Join-Path $Root $entry.path
            if (Test-Path $ModulePath) {
                Write-Color "[+] Loading local module: $matchedKey (path: $ModulePath)" Cyan
                Import-Module $ModulePath -Force
            } else {
                Write-Color "[!] Local module path not found: $ModulePath" Yellow
            }
        }
        elseif ($entry.type -eq "remote") {
            Invoke-ModuleRemote -Url $entry.url
        }
        else {
            Write-Color "[!] Unknown module type in manifest for $matchedKey" Red
        }
    }
    else {
        Write-Color "[!] Module not listed in manifest: '$Module'" Red
        Write-Color "Try adding it to core\psm-manifest.json (use the module name as the key)." Cyan
        return
    }

    # === Optional Post-Execution ===
    if ($ModuleArgs -contains '--help') {
        $helpFunc = "Show-" + $matchedKey + "Help"
        if (Get-Command $helpFunc -ErrorAction SilentlyContinue) {
            & $helpFunc
        } else {
            Write-Color "[i] No module-specific help function '$helpFunc' found. Try importing functions manually." DarkGray
        }
        return
    }

    $entryFunc = "Invoke-" + $matchedKey
    if (Get-Command $entryFunc -ErrorAction SilentlyContinue) {
        & $entryFunc @ModuleArgs
    }
    else {
        Write-Color "[i] Module '$matchedKey' imported. No entry function '$entryFunc' found." DarkGray
    }

    Write-Color "`nModule execution complete.`n" Green
}

# === Auto-run if parameters were passed ===
if ($args.Count -gt 0) {
    Scriptman @args
}