#
# Mitigate.psm1 - Security Mitigation Module
# Reuses Audit module functions to detect and remove security threats
#

# Import required Audit module
try {
    $auditPath = Join-Path $PSScriptRoot "..\Audit\Audit.psm1"
    if (Test-Path $auditPath) {
        Import-Module $auditPath -Force -ErrorAction SilentlyContinue
    } else {
        Import-Module Audit -Force -ErrorAction SilentlyContinue
    }
} catch {
    Write-Host "[!]" -ForegroundColor Red -NoNewline
    Write-Host " Audit module required but not found. Please ensure Audit module is available." -ForegroundColor DarkGray
}

# Helper function to prompt user for individual mitigation
function Confirm-IndividualMitigation {
    param([string]$ThreatName, [string]$ThreatDetails)
    
    Write-Host "`n[?]" -ForegroundColor Yellow -NoNewline
    Write-Host " Remove '$ThreatName' ($ThreatDetails)? (Y/N): " -ForegroundColor DarkGray -NoNewline
    $response = Read-Host
    return ($response -eq 'Y' -or $response -eq 'y' -or $response -eq 'Yes' -or $response -eq 'yes')
}

# Remove-RegistryPersistence
function Remove-RegistryPersistence {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running registry persistence audit..." -ForegroundColor DarkGray
    
    # Call audit function
    Get-RegistryPersistence
    
    # Check all registry persistence locations
    $regKeys = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
    )
    
    $removedCount = 0
    foreach ($key in $regKeys) {
        if (Test-Path $key) {
            $entries = Get-ItemProperty $key -ErrorAction SilentlyContinue
            if ($entries) {
                $entries.PSObject.Properties | Where-Object { 
                    $_.Name -notmatch '^PS' -and $_.Name -ne '(default)'
                } | ForEach-Object {
                    if (Confirm-IndividualMitigation "$key\$($_.Name)" $_.Value) {
                        try {
                            Remove-ItemProperty -Path $key -Name $_.Name -Force
                            Write-Host "[+]" -ForegroundColor Green -NoNewline
                            Write-Host " Removed: $key\$($_.Name)" -ForegroundColor DarkGray
                            $removedCount++
                        } catch {
                            Write-Host "[!]" -ForegroundColor Red -NoNewline
                            Write-Host " Failed to remove: $($_.Exception.Message)" -ForegroundColor DarkGray
                        }
                    }
                }
            }
        }
    }
    
    Write-Host "[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " Registry persistence mitigation completed. Removed: $removedCount items." -ForegroundColor DarkGray
}

# Remove-ScheduledTaskAbuse
function Remove-ScheduledTaskAbuse {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running scheduled task abuse audit..." -ForegroundColor DarkGray
    
    # Call audit function
    Get-ScheduledTaskAbuse
    
    # Get all tasks and filter for suspicious ones
    $allTasks = Get-ScheduledTask -ErrorAction SilentlyContinue
    $removedCount = 0
    
    if ($allTasks) {
        foreach ($task in $allTasks) {
            $details = if ($task.Actions) { "$($task.Actions[0].Execute) $($task.Actions[0].Arguments)" } else { "No action defined" }
            if (Confirm-IndividualMitigation "Task: $($task.TaskName)" "Path: $($task.TaskPath) | Action: $details") {
                try {
                    Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
                    Write-Host "[+]" -ForegroundColor Green -NoNewline
                    Write-Host " Removed task: $($task.TaskName)" -ForegroundColor DarkGray
                    $removedCount++
                } catch {
                    Write-Host "[!]" -ForegroundColor Red -NoNewline
                    Write-Host " Failed to remove task: $($_.Exception.Message)" -ForegroundColor DarkGray
                }
            }
        }
    } else {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " No scheduled tasks found." -ForegroundColor DarkGray
    }
    
    Write-Host "[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " Scheduled task mitigation completed. Removed: $removedCount tasks." -ForegroundColor DarkGray
}

# Remove-ServiceHijacking
function Remove-ServiceHijacking {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running service hijacking audit..." -ForegroundColor DarkGray
    
    # Call audit function
    Get-ServiceHijacking
    
    # Check for suspicious services
    $suspiciousServices = Get-WmiObject Win32_Service -ErrorAction SilentlyContinue | Where-Object {
        $_.PathName -and $_.PathName -match '(temp|appdata|users)' -and $_.State -eq 'Running'
    }
    
    if ($suspiciousServices) {
        foreach ($svc in $suspiciousServices) {
            if (Confirm-IndividualMitigation $svc.Name $svc.PathName) {
                try {
                    Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                    Write-Host "[+]" -ForegroundColor Green -NoNewline
                    Write-Host " Stopped service: $($svc.Name)" -ForegroundColor DarkGray
                } catch {}
            }
        }
    }
    
    Write-Host "[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " Service hijacking mitigation completed." -ForegroundColor DarkGray
}

# Remove-WMIEventSubscription
function Remove-WMIEventSubscription {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running WMI event subscription audit..." -ForegroundColor DarkGray
    
    # Call audit function
    Get-WMIEventSubscription
    
    # Check for suspicious WMI subscriptions
    $suspiciousFilters = Get-WmiObject -Namespace root\subscription -Class __EventFilter -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -eq 'Updater' -or $_.Query -match '(SystemUpTime|Win32_LocalTime.*Hour.*Minute)'
    }
    
    $suspiciousConsumers = Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer -ErrorAction SilentlyContinue
    
    if ($suspiciousFilters -or $suspiciousConsumers) {
        foreach ($filter in $suspiciousFilters) {
            if (Confirm-IndividualMitigation "Filter: $($filter.Name)" $filter.Query) {
                try {
                    $filter | Remove-WmiObject -ErrorAction SilentlyContinue
                    Write-Host "[+]" -ForegroundColor Green -NoNewline
                    Write-Host " Removed filter: $($filter.Name)" -ForegroundColor DarkGray
                } catch {}
            }
        }
        
        foreach ($consumer in $suspiciousConsumers) {
            if (Confirm-IndividualMitigation "Consumer: $($consumer.Name)" $consumer.CommandLineTemplate) {
                try {
                    $consumer | Remove-WmiObject -ErrorAction SilentlyContinue
                    Write-Host "[+]" -ForegroundColor Green -NoNewline
                    Write-Host " Removed consumer: $($consumer.Name)" -ForegroundColor DarkGray
                } catch {}
            }
        }
    }
    
    Write-Host "[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " WMI event subscription mitigation completed." -ForegroundColor DarkGray
}

# Remove-ProfilePersistence
function Remove-ProfilePersistence {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running PowerShell profile persistence audit..." -ForegroundColor DarkGray
    
    # Call audit function
    Get-ProfilePersistence
    
    # Check for suspicious profiles
    $profiles = @($PROFILE.AllUsersAllHosts, $PROFILE.CurrentUserAllHosts, $PROFILE.AllUsersCurrentHost, $PROFILE.CurrentUserCurrentHost)
    $suspiciousProfiles = @()
    
    foreach ($prof in $profiles) {
        if ($prof -and (Test-Path $prof)) {
            $content = Get-Content $prof -Raw -ErrorAction SilentlyContinue
            if ($content -and ($content -match '\s{200,}' -or $content -match 'sal a New-Object' -or $content -match 'bypass')) {
                $suspiciousProfiles += $prof
            }
        }
    }
    
    if ($suspiciousProfiles) {
        foreach ($prof in $suspiciousProfiles) {
            $fileName = Split-Path $prof -Leaf
            if (Confirm-IndividualMitigation "Profile: $fileName" $prof) {
                try {
                    Remove-Item $prof -Force -ErrorAction SilentlyContinue
                    Write-Host "[+]" -ForegroundColor Green -NoNewline
                    Write-Host " Removed profile: $prof" -ForegroundColor DarkGray
                } catch {}
            }
        }
    }
    
    Write-Host "[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " PowerShell profile persistence mitigation completed." -ForegroundColor DarkGray
}

# Remove-LocalAdmins
function Remove-LocalAdmins {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running local administrators audit..." -ForegroundColor DarkGray
    
    # Call audit function
    Get-LocalAdmins
    
    # Get current admins (excluding built-in accounts)
    $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -notmatch '(Administrator|SYSTEM|TrustedInstaller|NT AUTHORITY)' -and
        $_.Name -notlike '*\Administrator' -and
        $_.Name -ne $env:USERNAME
    }
    
    $removedCount = 0
    if ($admins) {
        foreach ($admin in $admins) {
            if (Confirm-IndividualMitigation "Admin: $($admin.Name)" "Type: $($admin.ObjectClass)") {
                try {
                    Remove-LocalGroupMember -Group "Administrators" -Member $admin.Name -Confirm:$false
                    Write-Host "[+]" -ForegroundColor Green -NoNewline
                    Write-Host " Removed admin: $($admin.Name)" -ForegroundColor DarkGray
                    $removedCount++
                } catch {
                    Write-Host "[!]" -ForegroundColor Red -NoNewline
                    Write-Host " Failed to remove admin: $($_.Exception.Message)" -ForegroundColor DarkGray
                }
            }
        }
    } else {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " No removable administrators found." -ForegroundColor DarkGray
    }
    
    Write-Host "[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " Local administrators mitigation completed. Removed: $removedCount admins." -ForegroundColor DarkGray
}

# Backup-SystemState
function Backup-SystemState {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Creating system backup..." -ForegroundColor DarkGray
    
    $backupPath = "$env:TEMP\ScriptmanBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    
    try {
        # Create backup directory
        New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
        
        # Create system restore point
        Checkpoint-Computer -Description "Scriptman Mitigation Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
        
        # Backup registry keys
        reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "$backupPath\HKLM_Run.reg" /y 2>$null
        reg export "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "$backupPath\HKCU_Run.reg" /y 2>$null
        reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "$backupPath\HKLM_RunOnce.reg" /y 2>$null
        reg export "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "$backupPath\HKCU_RunOnce.reg" /y 2>$null
        
        # Backup scheduled tasks
        Get-ScheduledTask -ErrorAction SilentlyContinue | Export-Csv "$backupPath\ScheduledTasks.csv" -NoTypeInformation
        
        # Backup local group members
        Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue | Export-Csv "$backupPath\Administrators.csv" -NoTypeInformation
        
        Write-Host "[+]" -ForegroundColor Green -NoNewline
        Write-Host " Backup created: $backupPath" -ForegroundColor DarkGray
        return $backupPath
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Backup failed: $($_.Exception.Message)" -ForegroundColor DarkGray
        return $null
    }
}

# Restore-SystemState
function Restore-SystemState {
    param([string]$BackupPath)
    
    if (-not $BackupPath) {
        Write-Host "[?]" -ForegroundColor Yellow -NoNewline
        $BackupPath = Read-Host " Enter backup path"
    }
    
    if (-not (Test-Path $BackupPath)) {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Backup path not found: $BackupPath" -ForegroundColor DarkGray
        return
    }
    
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Restoring from backup: $BackupPath" -ForegroundColor DarkGray
    
    try {
        # Restore registry keys
        if (Test-Path "$BackupPath\HKLM_Run.reg") { reg import "$BackupPath\HKLM_Run.reg" 2>$null }
        if (Test-Path "$BackupPath\HKCU_Run.reg") { reg import "$BackupPath\HKCU_Run.reg" 2>$null }
        if (Test-Path "$BackupPath\HKLM_RunOnce.reg") { reg import "$BackupPath\HKLM_RunOnce.reg" 2>$null }
        if (Test-Path "$BackupPath\HKCU_RunOnce.reg") { reg import "$BackupPath\HKCU_RunOnce.reg" 2>$null }
        
        Write-Host "[+]" -ForegroundColor Green -NoNewline
        Write-Host " Registry keys restored. Use System Restore for full rollback." -ForegroundColor DarkGray
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Restore failed: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# Test-Impact
function Test-Impact {
    param([string]$Function = "All")
    
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Impact preview - no changes will be made..." -ForegroundColor DarkGray
    
    $totalItems = 0
    
    # Registry Impact
    if ($Function -eq "All" -or $Function -eq "Registry") {
        Write-Host "`n[+]" -ForegroundColor Green -NoNewline
        Write-Host " Registry persistence entries..." -ForegroundColor DarkGray
        $regKeys = @(
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
            'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce'
        )
        $count = 0
        $items = @()
        foreach ($key in $regKeys) {
            if (Test-Path $key) {
                $entries = Get-ItemProperty $key -ErrorAction SilentlyContinue
                $entries.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' -and $_.Name -ne '(default)' } | ForEach-Object {
                    $items += [PSCustomObject]@{
                        Name = $_.Name
                        Location = ($key -replace 'HKLM:', 'HKEY_LOCAL_MACHINE' -replace 'HKCU:', 'HKEY_CURRENT_USER')
                        Value = if ($_.Value.Length -gt 50) { $_.Value.Substring(0,47) + "..." } else { $_.Value }
                    }
                    $count++
                }
            }
        }
        if ($items) {
            $items | Format-Table @{Label="Entry Name";Expression={$_.Name}}, @{Label="Registry Key";Expression={$_.Location}}, @{Label="Value";Expression={$_.Value}} -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No registry entries found." -ForegroundColor DarkGray
        }
        $totalItems += $count
    }
    
    # Scheduled Tasks Impact
    if ($Function -eq "All" -or $Function -eq "Tasks") {
        Write-Host "`n[+]" -ForegroundColor Green -NoNewline
        Write-Host " Scheduled tasks..." -ForegroundColor DarkGray
        $tasks = Get-ScheduledTask -ErrorAction SilentlyContinue
        $count = 0
        $items = @()
        $tasks | ForEach-Object {
            $action = if ($_.Actions) { $_.Actions[0].Execute } else { "No action" }
            $items += [PSCustomObject]@{
                TaskName = $_.TaskName
                Path = $_.TaskPath
                Action = if ($action.Length -gt 40) { $action.Substring(0,37) + "..." } else { $action }
                State = $_.State
            }
            $count++
        }
        if ($items) {
            $items | Format-Table TaskName, Path, Action, State -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No scheduled tasks found." -ForegroundColor DarkGray
        }
        $totalItems += $count
    }
    
    # Local Admins Impact
    if ($Function -eq "All" -or $Function -eq "Admins") {
        Write-Host "`n[+]" -ForegroundColor Green -NoNewline
        Write-Host " Local administrators..." -ForegroundColor DarkGray
        $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue | Where-Object {
            $_.Name -notmatch '(Administrator|SYSTEM|TrustedInstaller|NT AUTHORITY)' -and
            $_.Name -notlike '*\Administrator' -and
            $_.Name -ne $env:USERNAME
        }
        $count = 0
        $items = @()
        $admins | ForEach-Object {
            $items += [PSCustomObject]@{
                Name = $_.Name
                Type = $_.ObjectClass
                Source = if ($_.PrincipalSource) { $_.PrincipalSource } else { "Local" }
            }
            $count++
        }
        if ($items) {
            $items | Format-Table Name, Type, Source -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No removable administrators found." -ForegroundColor DarkGray
        }
        $totalItems += $count
    }
    
    # Services Impact
    if ($Function -eq "All" -or $Function -eq "Services") {
        Write-Host "`n[+]" -ForegroundColor Green -NoNewline
        Write-Host " Suspicious services..." -ForegroundColor DarkGray
        $services = Get-WmiObject Win32_Service -ErrorAction SilentlyContinue | Where-Object {
            $_.PathName -and $_.PathName -match '(temp|appdata|users)' -and $_.State -eq 'Running'
        }
        $count = 0
        $items = @()
        $services | ForEach-Object {
            $items += [PSCustomObject]@{
                Name = $_.Name
                State = $_.State
                StartMode = $_.StartMode
                Path = if ($_.PathName.Length -gt 50) { $_.PathName.Substring(0,47) + "..." } else { $_.PathName }
            }
            $count++
        }
        if ($items) {
            $items | Format-Table Name, State, StartMode, Path -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No suspicious services found." -ForegroundColor DarkGray
        }
        $totalItems += $count
    }
    
    Write-Host "`n[i]" -ForegroundColor Cyan -NoNewline
    Write-Host " Preview completed. Total items: $totalItems" -ForegroundColor DarkGray
}

# Remove-AllThreats
function Remove-AllThreats {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running comprehensive threat mitigation..." -ForegroundColor DarkGray
    
    Write-Host "`n[?]" -ForegroundColor Yellow -NoNewline
    Write-Host " Create backup before mitigation? (Y/N): " -ForegroundColor DarkGray -NoNewline
    $backupResponse = Read-Host
    
    $backupPath = $null
    if ($backupResponse -eq 'Y' -or $backupResponse -eq 'y') {
        $backupPath = Backup-SystemState
    }
    
    Write-Host "`n[?]" -ForegroundColor Yellow -NoNewline
    Write-Host " Run all mitigation functions? This will check and remove all detected threats. (Y/N): " -ForegroundColor DarkGray -NoNewline
    $response = Read-Host
    
    if ($response -eq 'Y' -or $response -eq 'y' -or $response -eq 'Yes' -or $response -eq 'yes') {
        Remove-RegistryPersistence
        Remove-ScheduledTaskAbuse
        Remove-ServiceHijacking
        Remove-WMIEventSubscription
        Remove-ProfilePersistence
        Remove-LocalAdmins
        
        Write-Host "`n[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " All threat mitigation functions completed." -ForegroundColor DarkGray
        
        if ($backupPath) {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " Backup available at: $backupPath" -ForegroundColor DarkGray
        }
    } else {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " Mitigation cancelled." -ForegroundColor DarkGray
    }
}

# Invoke-Mitigate
function Invoke-Mitigate {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running Mitigate module overview..." -ForegroundColor DarkGray
    
    Show-MitigateHelp
}

# Show-MitigateHelp
function Show-MitigateHelp {
    Write-Host "`nMitigate Module Help" -ForegroundColor Yellow
    Write-Host "Description: Security mitigation module that removes detected threats." -ForegroundColor DarkGray

    Write-Host "`nAvailable Commands:`n" -ForegroundColor Green
    Write-Host "  Remove-RegistryPersistence  - Remove suspicious registry persistence entries"
    Write-Host "  Remove-ScheduledTaskAbuse   - Remove suspicious scheduled tasks"
    Write-Host "  Remove-ServiceHijacking     - Stop suspicious services"
    Write-Host "  Remove-WMIEventSubscription - Remove malicious WMI subscriptions"
    Write-Host "  Remove-ProfilePersistence   - Clean suspicious PowerShell profiles"
    Write-Host "  Remove-LocalAdmins          - Remove unauthorized administrators"
    Write-Host "  Remove-AllThreats           - Run all mitigation functions"
    Write-Host "  Backup-SystemState          - Create system backup before mitigation"
    Write-Host "  Restore-SystemState         - Restore from backup"
    Write-Host "  Test-Impact                 - Preview mitigation impact (dry-run mode)"
    Write-Host "  Show-MitigateHelp           - Display this help menu"

    Write-Host "`nUsage Examples:" -ForegroundColor Yellow
    Write-Host "  Scriptman Mitigate:Remove-RegistryPersistence"
    Write-Host "  Scriptman Mitigate:Remove-ScheduledTaskAbuse"
    Write-Host "  Scriptman Mitigate:Remove-AllThreats"
    Write-Host "  Scriptman Mitigate:Test-Impact"
    Write-Host "  Scriptman Mitigate:Test-Impact -Function Registry"
    Write-Host "  Scriptman Mitigate:Backup-SystemState"
    Write-Host "  Scriptman Mitigate:Show-MitigateHelp"
}

# Export functions
Export-ModuleMember -Function `
    Remove-RegistryPersistence, `
    Remove-ScheduledTaskAbuse, `
    Remove-ServiceHijacking, `
    Remove-WMIEventSubscription, `
    Remove-ProfilePersistence, `
    Remove-LocalAdmins, `
    Remove-AllThreats, `
    Backup-SystemState, `
    Restore-SystemState, `
    Test-Impact, `
    Invoke-Mitigate, `
    Show-MitigateHelp