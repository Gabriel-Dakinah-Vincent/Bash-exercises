# Scriptman PowerShell Aliases for $PROFILE
# Add these to your PowerShell profile for quick access

function Set-Audit {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit
        }
    } catch {
        Write-Error "Failed to execute Audit: $($_.Exception.Message)"
    }
}

function Set-LocalAdmins {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-LocalAdmins
        }
    } catch {
        Write-Error "Failed to execute LocalAdmins: $($_.Exception.Message)"
    }
}

function Set-LastLogon {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-LastLogon
        }
    } catch {
        Write-Error "Failed to execute LastLogon: $($_.Exception.Message)"
    }
}

function Set-Sessions {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-Sessions
        }
    } catch {
        Write-Error "Failed to execute Sessions: $($_.Exception.Message)"
    }
}

function Set-DefensiveServices {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-DefensiveServices
        }
    } catch {
        Write-Error "Failed to execute DefensiveServices: $($_.Exception.Message)"
    }
}

function Set-EDRSolutions {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-EDRSolutions
        }
    } catch {
        Write-Error "Failed to execute EDRSolutions: $($_.Exception.Message)"
    }
}

function Set-PasswordPolicy {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-PasswordPolicy
        }
    } catch {
        Write-Error "Failed to execute PasswordPolicy: $($_.Exception.Message)"
    }
}



function Set-RegistryPersistence {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-RegistryPersistence
        }
    } catch {
        Write-Error "Failed to execute RegistryPersistence: $($_.Exception.Message)"
    }
}

function Set-ScheduledTaskAbuse {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-ScheduledTaskAbuse
        }
    } catch {
        Write-Error "Failed to execute ScheduledTaskAbuse: $($_.Exception.Message)"
    }
}

function Set-ServiceHijacking {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-ServiceHijacking
        }
    } catch {
        Write-Error "Failed to execute ServiceHijacking: $($_.Exception.Message)"
    }
}

function Set-DLLSideloading {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-DLLSideloading
        }
    } catch {
        Write-Error "Failed to execute DLLSideloading: $($_.Exception.Message)"
    }
}

function Set-WMIEventSubscription {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-WMIEventSubscription
        }
    } catch {
        Write-Error "Failed to execute WMIEventSubscription: $($_.Exception.Message)"
    }
}

function Set-ProfilePersistence {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Get-ProfilePersistence
        }
    } catch {
        Write-Error "Failed to execute ProfilePersistence: $($_.Exception.Message)"
    }
}

function Set-AuditHelp {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Audit:Show-AuditHelp
        }
    } catch {
        Write-Error "Failed to execute AuditHelp: $($_.Exception.Message)"
    }
}

function Set-InstallAnimation {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Startup:Install-Animation
        }
    } catch {
        Write-Error "Failed to execute Install-Animation: $($_.Exception.Message)"
    }
}

function Set-UninstallAnimation {
    try {
        & powershell -ExecutionPolicy Bypass -Command {
            Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | Invoke-Expression
            Scriptman Startup:Uninstall-Animation
        }
    } catch {
        Write-Error "Failed to execute Uninstall-Animation: $($_.Exception.Message)"
    }
}

Set-Alias Audit Set-Audit
Set-Alias LocalAdmins Set-LocalAdmins
Set-Alias LastLogon Set-LastLogon
Set-Alias Sessions Set-Sessions
Set-Alias DefensiveServices Set-DefensiveServices
Set-Alias EDRSolutions Set-EDRSolutions
Set-Alias PasswordPolicy Set-PasswordPolicy

Set-Alias RegistryPersistence Set-RegistryPersistence
Set-Alias ScheduledTaskAbuse Set-ScheduledTaskAbuse
Set-Alias ServiceHijacking Set-ServiceHijacking
Set-Alias DLLSideloading Set-DLLSideloading
Set-Alias WMIEventSubscription Set-WMIEventSubscription
Set-Alias ProfilePersistence Set-ProfilePersistence
Set-Alias AuditHelp Set-AuditHelp
Set-Alias InstallAnimation Set-InstallAnimation
Set-Alias UninstallAnimation Set-UninstallAnimation

# Set execution policy to allow profile loading
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
    Write-Host "Execution policy set to RemoteSigned for current user" -ForegroundColor Green
} catch {
    Write-Host "Could not set execution policy (may require admin rights)" -ForegroundColor Yellow
}

# Install aliases to PowerShell profile
try {
    if (-not (Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
    $profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if (-not $profileContent -or -not $profileContent.Contains('# Scriptman PowerShell Aliases')) {
        $url = 'https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Modules/Winmod/PowerShell/Alias.ps1'
        $content = if ($PSCommandPath) { Get-Content $PSCommandPath -Raw } else { (Invoke-WebRequest -Uri $url -UseBasicParsing).Content }
        $functionsOnly = ($content -split '# Set execution policy to allow profile loading')[0]
        Add-Content -Path $PROFILE -Value "`n$functionsOnly"
        Write-Host "Scriptman aliases added to PowerShell profile: $PROFILE" -ForegroundColor Green
    } else {
        Write-Host "Scriptman aliases already exist in PowerShell profile" -ForegroundColor Yellow
    }
} catch {
    Write-Warning "Failed to install aliases to profile: $($_.Exception.Message)"
}


