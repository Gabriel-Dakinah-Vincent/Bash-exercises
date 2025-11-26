# Scriptman PowerShell Aliases for $PROFILE
# Add these to your PowerShell profile for quick access

function Set-UserAudit {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit
    }
}

function Set-LocalAdmins {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-LocalAdmins
    }
}

function Set-UserLastLogon {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-UserLastLogon
    }
}

function Set-UserSessions {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-UserSessions
    }
}

function Set-DefensiveServices {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-DefensiveServices
    }
}

function Set-EDRSolutions {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-EDRSolutions
    }
}

function Set-PasswordPolicy {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-PasswordPolicy
    }
}

function Set-PersistenceAudit {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-PersistenceAudit
    }
}

function Set-RegistryPersistence {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-RegistryPersistence
    }
}

function Set-ScheduledTaskAbuse {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-ScheduledTaskAbuse
    }
}

function Set-ServiceHijacking {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-ServiceHijacking
    }
}

function Set-DLLSideloading {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-DLLSideloading
    }
}

function Set-WMIEventSubscription {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Get-WMIEventSubscription
    }
}

function Set-UserAuditHelp {
    & powershell -ExecutionPolicy Bypass -Command {
        Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | Invoke-Expression
        Scriptman UserAudit:Show-UserAuditHelp
    }
}

Set-Alias UserAudit Set-UserAudit
Set-Alias LocalAdmins Set-LocalAdmins
Set-Alias UserLastLogon Set-UserLastLogon
Set-Alias UserSessions Set-UserSessions
Set-Alias DefensiveServices Set-DefensiveServices
Set-Alias EDRSolutions Set-EDRSolutions
Set-Alias PasswordPolicy Set-PasswordPolicy
Set-Alias PersistenceAudit Set-PersistenceAudit
Set-Alias RegistryPersistence Set-RegistryPersistence
Set-Alias ScheduledTaskAbuse Set-ScheduledTaskAbuse
Set-Alias ServiceHijacking Set-ServiceHijacking
Set-Alias DLLSideloading Set-DLLSideloading
Set-Alias WMIEventSubscription Set-WMIEventSubscription
Set-Alias UserAuditHelp Set-UserAuditHelp

# Set execution policy to allow profile loading
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
    Write-Host "Execution policy set to RemoteSigned for current user" -ForegroundColor Green
} catch {
    Write-Host "Could not set execution policy (may require admin rights)" -ForegroundColor Yellow
}

# Install aliases to PowerShell profile
if (-not (Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if (-not $profileContent -or -not $profileContent.Contains('# Scriptman PowerShell Aliases')) {
    $url = 'https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Modules/Winmod/PowerShell/Alias.ps1'
    $content = if ($PSCommandPath) { Get-Content $PSCommandPath -Raw } else { (Invoke-WebRequest -Uri $url -UseBasicParsing).Content }
    $functionsOnly = $content -split '# Install aliases to PowerShell profile' | Select-Object -First 1
    Add-Content -Path $PROFILE -Value "`n$functionsOnly"
    Write-Host "Scriptman aliases added to PowerShell profile: $PROFILE" -ForegroundColor Green
} else {
    Write-Host "Scriptman aliases already exist in PowerShell profile" -ForegroundColor Yellow
}


