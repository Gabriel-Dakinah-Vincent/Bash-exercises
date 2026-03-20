<#
.SYNOPSIS
 Startup animation module for Scriptmanem - Typewriter effect at login/reboot.

.DESCRIPTION
 Simple module to install/uninstall startup animations with typewriter effects.
 Automatically detects admin privileges and uses appropriate startup folder.

.AUTHOR
 Gabriel Dakinah Vincent

.VERSION
 1.0.0
#>

# Module-level variables
$script:AppDataPath = Join-Path $env:APPDATA "Scriptmanem\Startup"
$script:ScriptPath = Join-Path $script:AppDataPath "Animation.ps1"
$script:UserStartupFolder = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"
$script:AllUsersStartupFolder = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\StartUp"
$script:ShortcutPath = $null
$script:IsAdmin = $false

# Check if running as admin
function Test-AdminPrivileges {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    catch {
        return $false
    }
}

# Determine startup folder based on privileges
function Get-StartupFolder {
    $script:IsAdmin = Test-AdminPrivileges
    
    if ($script:IsAdmin) {
        # Admin: use All-Users folder
        if (-not (Test-Path $script:AllUsersStartupFolder)) {
            New-Item -Path $script:AllUsersStartupFolder -ItemType Directory -Force | Out-Null
        }
        $script:ShortcutPath = Join-Path $script:AllUsersStartupFolder "Animation.lnk"
        return $script:AllUsersStartupFolder
    }
    else {
        # Non-admin: use User folder
        if (-not (Test-Path $script:UserStartupFolder)) {
            New-Item -Path $script:UserStartupFolder -ItemType Directory -Force | Out-Null
        }
        $script:ShortcutPath = Join-Path $script:UserStartupFolder "Animation.lnk"
        return $script:UserStartupFolder
    }
}

# Status output helper
function Write-Status {
    param(
        [string]$Message,
        [string]$Status = 'Info'
    )
    $colors = @{
        'Success' = 'Green'
        'Error'   = 'Red'
        'Warning' = 'Yellow'
        'Info'    = 'Cyan'
    }
    Write-Host "[$Status] " -ForegroundColor $colors[$Status] -NoNewline
    Write-Host $Message
}

# Animation code template
function Get-AnimationCode {
    param([string]$Message = "INITIALIZING EADMIRAL CORE... ACCESS GRANTED. WELCOME BACK, OPERATOR.")
    
    @"
Clear-Host
`$message = "$Message"
Write-Host "`n`n    " -NoNewline
`$message.ToCharArray() | ForEach-Object {
    Write-Host `$_ -NoNewline -ForegroundColor Green
    Start-Sleep -Milliseconds 40
}
for (`$i = 0; `$i -lt 4; `$i++) {
    Write-Host "_" -NoNewline -ForegroundColor Green
    Start-Sleep -Milliseconds 300
    Write-Host "`b " -NoNewline
    Start-Sleep -Milliseconds 300
}
Write-Host "`n`n    SYSTEM READY." -ForegroundColor White
Start-Sleep -Seconds 2
"@
}

# Install startup animation
function Install-Animation {
    param([string]$Message = "INITIALIZING EADMIRAL CORE... ACCESS GRANTED. WELCOME BACK, OPERATOR.")

    Write-Status "Installing startup animation..." "Info"

    try {
        # Get appropriate startup folder
        $startupFolder = Get-StartupFolder
        $scope = if ($script:IsAdmin) { "All-Users" } else { "Current User" }
        Write-Status "Using $scope startup folder" "Info"

        # Create AppData directory
        if (-not (Test-Path $script:AppDataPath)) {
            New-Item -Path $script:AppDataPath -ItemType Directory -Force | Out-Null
        }

        # Create animation script
        $animationCode = Get-AnimationCode -Message $Message
        Set-Content -Path $script:ScriptPath -Value $animationCode -Force -ErrorAction Stop

        # Create shortcut
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($script:ShortcutPath)
        $Shortcut.TargetPath = "powershell.exe"
        $Shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($script:ScriptPath)`""
        $Shortcut.WindowStyle = 1
        $Shortcut.Save()

        Write-Status "Installation complete. Animation will run at next login." "Success"
    }
    catch {
        Write-Status "Installation failed: $($_.Exception.Message)" "Error"
        return $false
    }

    return $true
}

# Uninstall startup animation
function Uninstall-Animation {
    Write-Status "Uninstalling startup animation..." "Info"

    try {
        # Get appropriate startup folder
        $startupFolder = Get-StartupFolder
        $scope = if ($script:IsAdmin) { "All-Users" } else { "Current User" }

        if (Test-Path $script:ShortcutPath) {
            Remove-Item $script:ShortcutPath -Force -ErrorAction Stop
            Write-Status "Shortcut removed from $scope startup folder" "Success"
        }

        if (Test-Path $script:ScriptPath) {
            Remove-Item $script:ScriptPath -Force -ErrorAction Stop
            Write-Status "Animation script removed" "Success"
        }

        Write-Status "Uninstallation complete." "Success"
    }
    catch {
        Write-Status "Uninstallation failed: $($_.Exception.Message)" "Error"
        return $false
    }

    return $true
}

# Export functions
Export-ModuleMember -Function `
    Install-Animation, `
    Uninstall-Animation
