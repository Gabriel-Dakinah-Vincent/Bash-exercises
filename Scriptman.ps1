<#
.SYNOPSIS
 Scriptman PowerShell launcher for the Bash-Exercises Project.

.DESCRIPTION
 Runs PowerShell modules locally or remotely as defined in the core/psm-manifest.json registry.
 Automatically fetches modules from GitHub if missing locally or if Scriptman is executed remotely.

.AUTHOR
 Gabriel Dakinah Vincent
.VERSION
 2.0.3
#>

function Scriptman {
    param(
        [Parameter(Position = 0)]
        [string]$Module,
        [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
        [string[]]$ModuleArgs
    )

    #  Paths 
    $Root = (Get-Location).Path
    $ManifestPath = Join-Path $Root "core\psm-manifest.json"

    # Colors 
    function Write-Color($text, $color = 'White') {
        Write-Host $text -ForegroundColor $color
    }

    # Typewriter Effect
    function Write-Typewriter($text, $color = 'White', $speed = 45) {
        $chars = $text.ToCharArray()
        
        for ($i = 0; $i -lt $chars.Count; $i++) {
            Write-Host $chars[$i] -ForegroundColor $color -NoNewline
            Start-Sleep -Milliseconds $speed
        }
        Write-Host ""
    }

    # Banner 
    function Show-Banner {
        Clear-Host
        Write-Host "`n" -NoNewline
        Write-Typewriter "SCRIPTMAN FRAMEWORK" White 60
        Write-Typewriter "ENVIRONMENT: WINDOWS POWERSHELL" White 50
        Write-Host "AUTHOR: " -ForegroundColor White -NoNewline
        Write-Typewriter "GABRIEL DAKINAH VINCENT" White 50
        Start-Sleep -Milliseconds 1500
        Clear-Host
    }
    Show-Banner

    # Split module and optional cmdlet
    $TargetCmdlet = $null
    if ($Module -match ":") {
        $parts = $Module -split ":", 2
        $Module = $parts[0]
        $TargetCmdlet = $parts[1]
    }

    # Load Manifest 
    $Manifest = $null
    if (Test-Path $ManifestPath) {
        try {
            $Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
            Write-Host "[+]" -ForegroundColor Green -NoNewline
            Write-Host " Loaded local manifest successfully." -ForegroundColor DarkGray
        }
        catch {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " Failed to parse local manifest: $_" -ForegroundColor DarkGray
        }
    }

    # Remote fallback if no local manifest  
    if (-not $Manifest) {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Local manifest not found. Fetching remote version..." -ForegroundColor DarkGray
        $ManifestUrl = "https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/core/psm-manifest.json"
        try {
            $response = Invoke-WebRequest -Uri $ManifestUrl -UseBasicParsing
            $json = $response.Content.Trim()
            $Manifest = $json | ConvertFrom-Json
            Write-Host "[+]" -ForegroundColor Green -NoNewline
            Write-Host " Loaded remote manifest successfully." -ForegroundColor DarkGray
        }
        catch {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " Failed to load manifest locally or remotely: $_" -ForegroundColor DarkGray
            return
        }
    }

    # Helper: Fetch and import remote PowerShell module 
    function Invoke-ModuleRemote {
        param([string]$Url)
        try {
            Write-Host "[*]" -ForegroundColor Yellow -NoNewline
            Write-Host " Fetching remote module from GitHub..." -ForegroundColor DarkGray
            $tmpPath = Join-Path $env:TEMP ("RemoteModule_" + (Get-Random) + ".psm1")
            Invoke-WebRequest -Uri $Url -OutFile $tmpPath -UseBasicParsing
            Write-Host "[+]" -ForegroundColor Green -NoNewline
            Write-Host " Importing remote module..." -ForegroundColor DarkGray
            Import-Module $tmpPath -Force
            Remove-Item $tmpPath -Force
        }
        catch {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " Failed to fetch or import remote module: $_" -ForegroundColor DarkGray
        }
    }

    # Usage Help 
    if (-not $Module) {
        Write-Color "Usage: Scriptman <module-name>[:cmdlet] [options]" Cyan
        Write-Host "`nExamples:`n"
        Write-Host "  .\Scriptman.ps1 -help"
        Write-Host "  .\Scriptman.ps1 UserAudit             # Runs the module's default entry" -ForegroundColor DarkGray
        Write-Host "  .\Scriptman.ps1 UserAudit:Get-LocalAdmins   # Runs only that cmdlet`n" -ForegroundColor DarkGray
        Write-Host "Available Modules:`n"
        foreach ($key in $Manifest.PSObject.Properties.Name) {
            $info = $Manifest.$key
            $type = if ($info.type -eq "remote") { "Remote" } else { "Local" }
            Write-Color ("  - {0} ({1})" -f $key, $type) Green
        }
        return
    }

    # Dispatcher using Manifest 
    $normalized = $Module -replace '-', ''
    $matchedKey = $Manifest.PSObject.Properties.Name | Where-Object { ($_ -replace '-', '') -ieq $normalized }

    if ($matchedKey) {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " Matched '" -ForegroundColor DarkGray -NoNewline
        Write-Host $Module -ForegroundColor Green -NoNewline
        Write-Host "' to manifest key '" -ForegroundColor DarkGray -NoNewline
        Write-Host $matchedKey -ForegroundColor White -NoNewline
        Write-Host "'." -ForegroundColor DarkGray
        $entry = $Manifest.$matchedKey

        if ($entry.type -eq "local") {
            $ModulePath = Join-Path $Root $entry.path
            if (Test-Path $ModulePath) {
                Write-Host "[+]" -ForegroundColor Green -NoNewline
                Write-Host " Loading local module: " -ForegroundColor DarkGray -NoNewline
                Write-Host $matchedKey -ForegroundColor Green
                Import-Module $ModulePath -Force
            } else {
                Write-Host "[!]" -ForegroundColor Red -NoNewline
                Write-Host " Local module path not found: $ModulePath" -ForegroundColor DarkGray
                if ($entry.fallback.url) {
                    Write-Host "[*]" -ForegroundColor Yellow -NoNewline
                    Write-Host " Attempting remote fallback for $matchedKey..." -ForegroundColor DarkGray
                    Invoke-ModuleRemote -Url $entry.fallback.url
                }
            }
        }
        elseif ($entry.type -eq "remote") {
            Invoke-ModuleRemote -Url $entry.url
        }
        else {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " Unknown module type in manifest for $matchedKey" -ForegroundColor DarkGray
        }
    }
    else {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Module not listed in manifest: '$Module'" -ForegroundColor DarkGray
        Write-Color "Try adding it to core\psm-manifest.json (use the module name as the key)." Cyan
        return
    }

    # Cmdlet-specific or module-wide execution 
    if ($TargetCmdlet) {
        Write-Host "[*]" -ForegroundColor Yellow -NoNewline
        Write-Host " Running targeted cmdlet: " -ForegroundColor DarkGray -NoNewline
        Write-Host $TargetCmdlet -ForegroundColor Yellow
        if (Get-Command $TargetCmdlet -ErrorAction SilentlyContinue) {
            if ($ModuleArgs) {
                # Parse parameters from string array
                $params = @{}
                for ($i = 0; $i -lt $ModuleArgs.Count; $i++) {
                    if ($ModuleArgs[$i] -match '^-(.+)') {
                        $paramName = $matches[1]
                        if ($i + 1 -lt $ModuleArgs.Count -and $ModuleArgs[$i + 1] -notmatch '^-') {
                            $params[$paramName] = $ModuleArgs[$i + 1]
                            $i++
                        } else {
                            $params[$paramName] = $true
                        }
                    }
                }
                & $TargetCmdlet @params
            } else {
                & $TargetCmdlet
            }
        } else {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " Cmdlet '$TargetCmdlet' not found in module '$matchedKey'." -ForegroundColor DarkGray
        }
        return
    }

    # Optional Post-Execution 
    if ($ModuleArgs -contains '--help') {
        $helpFunc = "Show-" + $matchedKey + "Help"
        if (Get-Command $helpFunc -ErrorAction SilentlyContinue) {
            & $helpFunc
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No module-specific help function '$helpFunc' found. Try importing functions manually." -ForegroundColor DarkGray
        }
        return
    }

    $entryFunc = "Invoke-" + $matchedKey
    if (Get-Command $entryFunc -ErrorAction SilentlyContinue) {
        & $entryFunc @ModuleArgs
    }
    else {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " Module '$matchedKey' imported. No entry function '$entryFunc' found." -ForegroundColor DarkGray
    }

    Write-Color "`nModule execution complete.`n" Green
}

# Auto-run if parameters were passed 
if ($args.Count -gt 0) {
    Scriptman @args
}
