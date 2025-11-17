<#
.SYNOPSIS
 User account auditing functions for Windows.
#>

function Get-UserAudit {
    Write-Host "`n[+] Collecting user account information..." -ForegroundColor Cyan
    try {
        $users = Get-LocalUser | Select-Object Name, Enabled, LastLogon
        if ($users) {
            $users | Format-Table Name, Enabled, LastLogon -AutoSize
        } else {
            Write-Host "No local users found." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error fetching local users: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Get-LocalAdmins {
    Write-Host "`n[+] Enumerating local administrators..." -ForegroundColor Cyan
    try {
        $admins = Get-LocalGroupMember -Group "Administrators" |
                  Select-Object Name, ObjectClass
        if ($admins) {
            $admins | Format-Table Name, ObjectClass -AutoSize
        } else {
            Write-Host "No administrators found." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error retrieving administrators: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Get-UserLastLogon {
    Write-Host "`n[+] Gathering last logon data..." -ForegroundColor Cyan
    try {
        Get-LocalUser | ForEach-Object {
            [PSCustomObject]@{
                UserName  = $_.Name
                LastLogon = $_.LastLogon
            }
        } | Format-Table UserName, LastLogon -AutoSize
    } catch {
        Write-Host "Error retrieving last logon times: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-UserAuditHelp {
    Write-Host "`n=== UserAudit Module Help ===" -ForegroundColor Magenta
    Write-Host "Version: 1.0.0" -ForegroundColor Yellow
    Write-Host "Description: A PowerShell module to audit users and user accounts." -ForegroundColor Cyan

    Write-Host "`nAvailable Commands:`n" -ForegroundColor Green
    Write-Host "  Get-UserAudit           - Displays local user summary"
    Write-Host "  Get-LocalAdmins         - Lists members of the Administrators group"
    Write-Host "  Get-UserLastLogon       - Shows last logon timestamp for each user"
    Write-Host "  Get-UserSessions        - Shows currently logged-in user sessions"
    Write-Host "  Get-DefensiveServices   - Detects Windows Defender/security services"
    Write-Host "  Get-EDRSolutions        - Best-effort detection of EDR/AV products"
    Write-Host "  Get-PasswordPolicy      - Shows password & lockout policies"
    Write-Host "  Show-UserAuditHelp      - Displays this help menu"

    Write-Host "`nUsage Examples:" -ForegroundColor Yellow
    Write-Host "  Scriptman UserAudit"
    Write-Host "  Scriptman UserAudit:Get-UserSessions"
}

function Invoke-UserAudit {
    Write-Host "`n[+] Running OPSEC-friendly UserAudit summary..." -ForegroundColor Cyan
    
    Get-UserAudit
    Get-LocalAdmins
    Get-UserLastLogon
    Get-UserSessions
    Get-DefensiveServices
}

# 
# Get-UserSessions
# 
function Get-UserSessions {
    Write-Host "`n[+] Enumerating active user sessions..." -ForegroundColor Cyan
    try {
        $raw = $null
        try { $raw = quser 2>$null } catch {}
        if ($raw) {
            $lines = ($raw -split "`n") | Where-Object { $_ -match '\S' }
            if ($lines.Count -le 1) {
                Write-Host "No active sessions found." -ForegroundColor Yellow
                return
            }
            $parsed = @()
            foreach ($l in $lines[1..($lines.Count-1)]) {
                $cols = ($l -replace '^\s+','') -replace '\s{2,}', ',' -split ','
                $parsed += [PSCustomObject]@{
                    UserName  = $cols[0].Trim()
                    Session   = $cols[1].Trim()
                    Id        = $cols[2].Trim()
                    State     = $cols[3].Trim()
                    IdleTime  = $cols[4].Trim()
                    LogonTime = ($cols[5..($cols.Count-1)] -join ' ').Trim()
                }
            }
            $parsed | Format-Table UserName, Session, State, IdleTime, LogonTime -AutoSize
            return
        }

        $sessions = Get-CimInstance -ClassName Win32_LoggedOnUser -ErrorAction SilentlyContinue
        if (-not $sessions) {
            Write-Host "No session information available." -ForegroundColor Yellow
            return
        }
        $sessions | ForEach-Object {
            $acct = ($_).Antecedent -replace '.*Domain="([^"]+)",Name="([^"]+)".*','$1\$2'
            [PSCustomObject]@{ Account = $acct }
        } | Format-Table -AutoSize

    } catch {
        Write-Host "Error retrieving session data: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 
# Get-DefensiveServices
# 
function Get-DefensiveServices {
    Write-Host "`n[+] Checking for Windows Defender/security services..." -ForegroundColor Cyan

    $svcNames = @(
        'WinDefend','WdNisSvc','mpssvc','sense','WdFilter','Wscsvc','AppIDSvc'
    )

    $results = foreach ($s in $svcNames) {
        try {
            $svc = Get-Service -Name $s -ErrorAction SilentlyContinue
            if ($svc) {
                [PSCustomObject]@{
                    Name        = $svc.Name
                    DisplayName = $svc.DisplayName
                    Status      = $svc.Status
                }
            } else {
                [PSCustomObject]@{
                    Name        = $s
                    DisplayName = $null
                    Status      = 'NotFound'
                }
            }
        } catch {
            [PSCustomObject]@{ Name=$s; DisplayName=$null; Status='Error' }
        }
    }

    $results | Format-Table Name, DisplayName, Status -AutoSize
}

# 
# Get-EDRSolutions
# 
function Get-EDRSolutions {
    Write-Host "`n[+] Scanning for common EDR/AV indicators..." -ForegroundColor Cyan

    $indicators = @{
        'CrowdStrike' = @{ Services=@('CSFalconService','csagent'); Processes=@('csagent','falcon'); Reg=@('CrowdStrike') }
        'SentinelOne' = @{ Services=@('SentinelCtl','SentinelAgent'); Processes=@('SentinelAgent'); Reg=@('SentinelOne') }
        'Sophos'      = @{ Services=@('SophosMCS'); Processes=@('SophosUI'); Reg=@('Sophos') }
        'CarbonBlack' = @{ Services=@('cb'); Processes=@('cb.exe'); Reg=@('Carbon Black') }
        'McAfee'      = @{ Services=@('McShield'); Processes=@('mcshield'); Reg=@('McAfee') }
        'ESET'        = @{ Services=@('ekrn'); Processes=@('ekrn'); Reg=@('ESET') }
    }

    $found = @()
    $procNames = Get-Process -ErrorAction SilentlyContinue | Select-Object -Expand Name

    foreach ($prod in $indicators.Keys) {
        $meta = $indicators[$prod]
        $svcFound = $meta.Services | Where-Object { Get-Service -Name $_ -ErrorAction SilentlyContinue } | Measure-Object | Select-Object -Expand Count
        $procFound = $meta.Processes | Where-Object { $procNames -contains $_ } | Measure-Object | Select-Object -Expand Count

        $regFound = $false
        try {
            $reg = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue
            if ($reg.DisplayName -like "*$prod*") { $regFound = $true }
        } catch {}

        if ($svcFound -or $procFound -or $regFound) {
            $found += [PSCustomObject]@{
                Product          = $prod
                ServiceDetected  = [bool]$svcFound
                ProcessDetected  = [bool]$procFound
                RegistryDetected = $regFound
            }
        }
    }

    if ($found) {
        $found | Format-Table Product, ServiceDetected, ProcessDetected, RegistryDetected -AutoSize
    } else {
        Write-Host "No EDR detected (best-effort)." -ForegroundColor Yellow
    }
}

# 
# Get-PasswordPolicy
# 
function Get-PasswordPolicy {
    Write-Host "`n[+] Retrieving password policy..." -ForegroundColor Cyan
    try {
        $raw = net accounts 2>$null
        if (-not $raw) { Write-Host "Could not retrieve policy." -ForegroundColor Yellow; return }

        $lines = $raw -split "`n"
        $policy = @{}

        foreach ($l in $lines) {
            if ($l -match 'Minimum password age')       { $policy.MinPasswordAge       = ($l -split ':')[1].Trim() }
            if ($l -match 'Maximum password age')       { $policy.MaxPasswordAge       = ($l -split ':')[1].Trim() }
            if ($l -match 'Minimum password length')    { $policy.MinPasswordLength    = ($l -split ':')[1].Trim() }
            if ($l -match 'Password history length')    { $policy.PasswordHistory      = ($l -split ':')[1].Trim() }
            if ($l -match 'Lockout threshold')          { $policy.LockoutThreshold     = ($l -split ':')[1].Trim() }
            if ($l -match 'Lockout duration')           { $policy.LockoutDuration      = ($l -split ':')[1].Trim() }
            if ($l -match 'Lockout observation')        { $policy.LockoutObservation   = ($l -split ':')[1].Trim() }
        }

        [PSCustomObject]$policy | Format-List

    } catch {
        Write-Host "Error retrieving password policy: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 
# Export functions
# 
Export-ModuleMember -Function `
    Get-UserAudit, `
    Get-LocalAdmins, `
    Get-UserLastLogon, `
    Get-UserSessions, `
    Get-DefensiveServices, `
    Get-EDRSolutions, `
    Get-PasswordPolicy, `
    Show-UserAuditHelp, `
    Invoke-UserAudit