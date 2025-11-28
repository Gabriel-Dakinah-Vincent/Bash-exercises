<#
.SYNOPSIS
 User account auditing functions for Windows.
#>

function Get-Audit {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Collecting user account information..." -ForegroundColor DarkGray
    try {
        $users = Get-LocalUser | Select-Object Name, Enabled, LastLogon
        if ($users) {
            $users | Format-Table Name, Enabled, LastLogon -AutoSize
        } else {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " No local users found." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error fetching local users: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

function Get-LocalAdmins {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Enumerating local administrators..." -ForegroundColor DarkGray
    try {
        $admins = Get-LocalGroupMember -Group "Administrators" |
                  Select-Object Name, ObjectClass
        if ($admins) {
            $admins | Format-Table Name, ObjectClass -AutoSize
        } else {
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " No administrators found." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error retrieving administrators: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

function Get-LastLogon {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Gathering last logon data..." -ForegroundColor DarkGray
    try {
        Get-LocalUser | ForEach-Object {
            [PSCustomObject]@{
                UserName  = $_.Name
                LastLogon = $_.LastLogon
            }
        } | Format-Table UserName, LastLogon -AutoSize
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error retrieving last logon times: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

function Show-AuditHelp {
    Write-Host "`nAudit Module Help" -ForegroundColor Yellow
    Write-Host "Description: A PowerShell module to audit users and user accounts." -ForegroundColor DarkGray

    Write-Host "`nAvailable Commands:`n" -ForegroundColor Green
    Write-Host "  Get-Audit           - Displays local user summary"
    Write-Host "  Get-LocalAdmins         - Lists members of the Administrators group"
    Write-Host "  Get-LastLogon           - Shows last logon timestamp for each user"
    Write-Host "  Get-Sessions            - Shows currently logged-in user sessions"
    Write-Host "  Get-DefensiveServices   - Detects Windows Defender/security services"
    Write-Host "  Get-EDRSolutions        - Best-effort detection of EDR/AV products"
    Write-Host "  Get-PasswordPolicy      - Shows password & lockout policies"

    Write-Host "  Get-RegistryPersistence - Checks registry-based persistence"
    Write-Host "  Get-ScheduledTaskAbuse  - Detects suspicious scheduled tasks"
    Write-Host "  Get-ServiceHijacking    - Identifies potential service hijacking"
    Write-Host "  Get-DLLSideloading      - Scans for DLL sideloading indicators (supports -MaxProcesses, -TimeoutSeconds)"
    Write-Host "  Get-WMIEventSubscription - Checks WMI event subscriptions"
    Write-Host "  Get-ProfilePersistence  - Scans PowerShell profiles for persistence"
    Write-Host "  Show-AuditHelp      - Displays this help menu"

    Write-Host "`nUsage Examples:" -ForegroundColor Yellow
    Write-Host "  .\Scriptman.ps1 -help"
    Write-Host "  .\Scriptman.ps1 Audit"
    Write-Host "  .\Scriptman.ps1 Audit:Get-Sessions"
    Write-Host "  .\Scriptman.ps1 Audit:Get-DLLSideloading -MaxProcesses 25 -TimeoutSeconds 15"
}

function Invoke-Audit {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Running OPSEC-friendly Audit summary..." -ForegroundColor DarkGray
    
    Get-Audit
    Get-LocalAdmins
    Get-LastLogon
    Get-Sessions
    Get-DefensiveServices
    Get-RegistryPersistence
    Get-ProfilePersistence
}

# 
# Get-UserSessions
# 
function Get-Sessions {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Enumerating active user sessions..." -ForegroundColor DarkGray
    try {
        $raw = $null
        try { $raw = quser 2>$null } catch {}
        if ($raw) {
            $lines = ($raw -split "`n") | Where-Object { $_ -match '\S' }
            if ($lines.Count -le 1) {
                Write-Host "[!]" -ForegroundColor Red -NoNewline
                Write-Host " No active sessions found." -ForegroundColor DarkGray
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
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " No session information available." -ForegroundColor DarkGray
            return
        }
        $sessions | ForEach-Object {
            $acct = ($_).Antecedent -replace '.*Domain="([^"]+)",Name="([^"]+)".*','$1\$2'
            [PSCustomObject]@{ Account = $acct }
        } | Format-Table -AutoSize

    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error retrieving session data: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# 
# Get-DefensiveServices
# 
function Get-DefensiveServices {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Checking for Windows Defender/security services..." -ForegroundColor DarkGray

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
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Scanning for common EDR/AV indicators..." -ForegroundColor DarkGray

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
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " No EDR detected (best-effort)." -ForegroundColor DarkGray
    }
}

# 
# Get-PasswordPolicy
# 
function Get-PasswordPolicy {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Retrieving password policy..." -ForegroundColor DarkGray
    try {
        $raw = net accounts 2>$null
        if (-not $raw) { 
            Write-Host "[!]" -ForegroundColor Red -NoNewline
            Write-Host " Could not retrieve policy." -ForegroundColor DarkGray
            return 
        }

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
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error retrieving password policy: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# 
# Test-AdminPrivileges - Helper function to check administrator privileges
# 
function Test-AdminPrivileges {
    try {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

# 
# Get-RiskLevel - Helper function for risk scoring
# 
function Get-RiskLevel {
    param(
        [string]$Type,
        [string]$Value,
        [string]$Signature = 'Unknown',
        [string]$Location = ''
    )
    
    switch ($Type) {
        'Registry' {
            if ($Location -like '*Image File Execution Options*') { return 'High' }
            if ($Location -like '*Winlogon*') { return 'High' }
            if ($Location -like '*Lsa*') { return 'High' }
            if ($Value -match '(powershell.*NonInteractive|WindowStyle Hidden|sal a New-Object|IO\.Compression)') { return 'High' }
            if ($Value -match '(powershell|cmd|wscript|cscript).*(-enc|-e |-w hidden|bypass)') { return 'High' }
            if ($Value -match '(temp|appdata|users)') { return 'Medium' }
            return 'Low'
        }
        'Service' {
            if ($Signature -eq 'Invalid/Unsigned') { return 'High' }
            if ($Value -match '(temp|appdata|users)') { return 'Medium' }
            return 'Low'
        }
        'Task' {
            if ($Value -match '(NonInteractive|bypass|hidden|encoded)') { return 'High' }
            if ($Value -match '(powershell|cmd)') { return 'Medium' }
            return 'Low'
        }
        'DLL' { return 'Medium' }
        'WMI' { 
            if ($Value -match '(SystemUpTime|Win32_LocalTime.*Hour.*Minute|CommandLineTemplate)') { return 'High' }
            return 'High' 
        }
        default { return 'Low' }
    }
}



# 
# Get-RegistryPersistence
# 
function Get-RegistryPersistence {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Checking registry persistence locations..." -ForegroundColor DarkGray
    
    $regKeys = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run',
        'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
        'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options',
        'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
    )
    
    $findings = @()
    
    # Check PowerShell profiles for persistence
    $profiles = @($PROFILE.AllUsersAllHosts, $PROFILE.CurrentUserAllHosts, $PROFILE.AllUsersCurrentHost, $PROFILE.CurrentUserCurrentHost)
    foreach ($prof in $profiles) {
        if ($prof -and (Test-Path $prof)) {
            try {
                $content = Get-Content $prof -Raw -ErrorAction SilentlyContinue
                if ($content -and ($content -match '\s{200,}' -or $content -match 'sal a New-Object' -or $content -match 'IO\.Compression\.DeflateStream')) {
                    $risk = 'High'
                    $findings += [PSCustomObject]@{
                        Location = 'PowerShell Profile'
                        Name = Split-Path $prof -Leaf
                        Value = $prof
                        FileHash = (Get-FileHash $prof -ErrorAction SilentlyContinue).Hash
                        Risk = $risk
                    }
                }
            } catch {}
        }
    }
    
    foreach ($key in $regKeys) {
        try {
            if (Test-Path $key) {
                if ($key -like '*Lsa*') {
                    $entries = Get-ItemProperty $key -ErrorAction SilentlyContinue
                    if ($entries.'Security Packages') {
                        $packages = $entries.'Security Packages'
                        foreach ($pkg in $packages) {
                            if ($pkg -and $pkg -notmatch '^(kerberos|msv1_0|schannel|wdigest|tspkg|pku2u|livessp)$') {
                                $risk = 'High'
                                $findings += [PSCustomObject]@{
                                    Location = $key
                                    Name = 'Security Packages'
                                    Value = $pkg
                                    FileHash = 'N/A'
                                    Risk = $risk
                                }
                            }
                        }
                    }
                } elseif ($key -like '*Winlogon*') {
                    $entries = Get-ItemProperty $key -ErrorAction SilentlyContinue
                    @('Shell', 'Userinit', 'Taskman', 'AppSetup') | ForEach-Object {
                        if ($entries.$_) {
                            $hash = if (Test-Path ($entries.$_ -split ' ')[0]) { (Get-FileHash ($entries.$_ -split ' ')[0] -ErrorAction SilentlyContinue).Hash } else { 'N/A' }
                            $risk = Get-RiskLevel -Type 'Registry' -Value $entries.$_ -Location $key
                            $findings += [PSCustomObject]@{
                                Location = $key
                                Name = $_
                                Value = $entries.$_
                                FileHash = $hash
                                Risk = $risk
                            }
                        }
                    }
                } elseif ($key -like '*Image File Execution Options*') {
                    Get-ChildItem $key -ErrorAction SilentlyContinue | ForEach-Object {
                        $debugger = Get-ItemProperty $_.PSPath -Name 'Debugger' -ErrorAction SilentlyContinue
                        if ($debugger.Debugger) {
                            $hash = if (Test-Path ($debugger.Debugger -split ' ')[0]) { (Get-FileHash ($debugger.Debugger -split ' ')[0] -ErrorAction SilentlyContinue).Hash } else { 'N/A' }
                            $risk = Get-RiskLevel -Type 'Registry' -Value $debugger.Debugger -Location $_.PSPath
                            $findings += [PSCustomObject]@{
                                Location = $_.PSPath
                                Name = 'Debugger'
                                Value = $debugger.Debugger
                                FileHash = $hash
                                Risk = $risk
                            }
                        }
                    }
                } else {
                    $entries = Get-ItemProperty $key -ErrorAction SilentlyContinue
                    if ($entries) {
                        $entries.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                            $hash = if (Test-Path ($_.Value -split ' ')[0]) { (Get-FileHash ($_.Value -split ' ')[0] -ErrorAction SilentlyContinue).Hash } else { 'N/A' }
                            $risk = Get-RiskLevel -Type 'Registry' -Value $_.Value -Location $key
                            # Enhanced detection for PowerSploit-style payloads
                            if ($_.Value -match '(powershell.*-NonInteractive|WindowStyle Hidden|sal a New-Object)') { $risk = 'High' }
                            $findings += [PSCustomObject]@{
                                Location = $key
                                Name = $_.Name
                                Value = $_.Value
                                FileHash = $hash
                                Risk = $risk
                            }
                        }
                    }
                }
            }
        } catch {}
    }
    
    if ($findings) {
        $findings | Sort-Object @{Expression={switch($_.Risk){'High'{1};'Medium'{2};'Low'{3}}}}, Name | Format-Table Risk, Location, Name, Value, FileHash -AutoSize
    } else {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " No registry persistence entries found." -ForegroundColor DarkGray
    }
}

# 
# Get-ScheduledTaskAbuse
# 
function Get-ScheduledTaskAbuse {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Scanning for suspicious scheduled tasks..." -ForegroundColor DarkGray
    
    if (-not (Test-AdminPrivileges)) {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Administrator privileges required for full scheduled task enumeration." -ForegroundColor DarkGray
    }
    
    try {
        $tasks = Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { 
            ($_.TaskName -eq 'Updater' -or $_.TaskName -like '*Update*') -or
            ($_.State -eq 'Ready' -and 
            ($_.Actions.Execute -match '(powershell|cmd|wscript|cscript)' -or
             $_.Actions.Arguments -match '(bypass|hidden|encoded|NonInteractive)' -or
             $_.Principal.UserId -eq 'SYSTEM' -or
             $_.Triggers.Repetition.Interval -eq 'PT1H'))
        }
        
        if ($tasks) {
            $results = @()
            foreach ($task in $tasks) {
                $executeValue = $task.Actions.Execute + ' ' + $task.Actions.Arguments
                $risk = Get-RiskLevel -Type 'Task' -Value $executeValue
                # Enhanced detection for PowerSploit patterns
                if ($task.TaskName -eq 'Updater' -or $executeValue -match 'NonInteractive' -or $task.Principal.UserId -eq 'SYSTEM') { $risk = 'High' }
                $triggerType = if ($task.Triggers) { $task.Triggers[0].CimClass.CimClassName } else { 'Unknown' }
                $results += [PSCustomObject]@{
                    TaskName = $task.TaskName
                    State = $task.State
                    Execute = $task.Actions.Execute
                    Arguments = $task.Actions.Arguments
                    TriggerType = $triggerType
                    Principal = $task.Principal.UserId
                    Risk = $risk
                }
            }
            $results | Sort-Object @{Expression={switch($_.Risk){'High'{1};'Medium'{2};'Low'{3}}}}, TaskName | Format-Table Risk, TaskName, State, Execute, Arguments, TriggerType, Principal -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No suspicious scheduled tasks detected." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error scanning scheduled tasks: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# 
# Get-ServiceHijacking
# 
function Get-ServiceHijacking {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Checking for potential service hijacking..." -ForegroundColor DarkGray
    
    if (-not (Test-AdminPrivileges)) {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Administrator privileges required for service enumeration." -ForegroundColor DarkGray
        return
    }
    
    try {
        $services = Get-WmiObject Win32_Service -ErrorAction SilentlyContinue | Where-Object {
            $_.PathName -and 
            ($_.PathName -notmatch '^"?[A-Z]:\\Windows\\' -or
             $_.PathName -match '\s[^"]*\.(exe|bat|cmd|ps1)' -or
             $_.StartName -eq 'LocalSystem' -and $_.PathName -match '^[^"]*\s')
        }
        
        if ($services) {
            $results = @()
            foreach ($svc in $services) {
                $exePath = ($svc.PathName -replace '"', '' -split ' ')[0]
                $signature = 'Unknown'
                $hash = 'N/A'
                
                if (Test-Path $exePath) {
                    try {
                        $sig = Get-AuthenticodeSignature $exePath -ErrorAction SilentlyContinue
                        $signature = if ($sig.Status -eq 'Valid') { 'Valid' } else { 'Invalid/Unsigned' }
                        $hash = (Get-FileHash $exePath -ErrorAction SilentlyContinue).Hash
                    } catch {}
                }
                
                $risk = Get-RiskLevel -Type 'Service' -Value $svc.PathName -Signature $signature
                $results += [PSCustomObject]@{
                    Name = $svc.Name
                    State = $svc.State
                    StartMode = $svc.StartMode
                    PathName = $svc.PathName
                    StartName = $svc.StartName
                    Signature = $signature
                    FileHash = $hash
                    Risk = $risk
                }
            }
            $results | Sort-Object @{Expression={switch($_.Risk){'High'{1};'Medium'{2};'Low'{3}}}}, Name | Format-Table Risk, Name, State, StartMode, PathName, StartName, Signature, FileHash -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No suspicious service configurations detected." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error checking services: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# 
# Get-DLLSideloading
# 
function Get-DLLSideloading {
    param(
        [int]$MaxProcesses = 50,
        [int]$TimeoutSeconds = 30
    )
    
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Scanning for DLL sideloading indicators..." -ForegroundColor DarkGray
    
    if (-not (Test-AdminPrivileges)) {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Administrator privileges recommended for complete process module access." -ForegroundColor DarkGray
    }
    
    $commonDLLs = @('version.dll', 'dwmapi.dll', 'uxtheme.dll', 'winmm.dll', 'wtsapi32.dll')
    $systemPaths = @('C:\Windows\System32', 'C:\Windows\SysWOW64')
    $findings = @()
    $startTime = Get-Date
    $processCount = 0
    
    try {
        foreach ($dll in $commonDLLs) {
            if ((Get-Date) - $startTime -gt [TimeSpan]::FromSeconds($TimeoutSeconds)) {
                Write-Host "[!]" -ForegroundColor Red -NoNewline
                Write-Host " Scan timeout reached ($TimeoutSeconds seconds). Results may be incomplete." -ForegroundColor DarkGray
                break
            }
            
            $processes = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Modules -and $_.ProcessName -ne 'Idle' } | Select-Object -First $MaxProcesses
            
            foreach ($proc in $processes) {
                $processCount++
                if ($processCount -gt $MaxProcesses) {
                    Write-Host "[!]" -ForegroundColor Red -NoNewline
                    Write-Host " Process limit reached ($MaxProcesses). Results may be incomplete." -ForegroundColor DarkGray
                    break
                }
                
                try {
                    $modules = $proc.Modules | Where-Object { $_.ModuleName -eq $dll }
                    foreach ($mod in $modules) {
                        $isSystemPath = $false
                        foreach ($sysPath in $systemPaths) {
                            if ($mod.FileName -like "$sysPath\*") { $isSystemPath = $true; break }
                        }
                        if (-not $isSystemPath) {
                            $hash = 'N/A'
                            try {
                                if (Test-Path $mod.FileName) {
                                    $hash = (Get-FileHash $mod.FileName -ErrorAction SilentlyContinue).Hash
                                }
                            } catch {}
                            
                            $risk = Get-RiskLevel -Type 'DLL' -Value $mod.FileName
                            $findings += [PSCustomObject]@{
                                Process = $proc.ProcessName
                                PID = $proc.Id
                                DLL = $mod.ModuleName
                                Path = $mod.FileName
                                FileHash = $hash
                                Risk = $risk
                            }
                        }
                    }
                } catch {}
            }
            if ($processCount -gt $MaxProcesses) { break }
        }
        
        if ($findings) {
            $findings | Sort-Object @{Expression={switch($_.Risk){'High'{1};'Medium'{2};'Low'{3}}}}, Process | Format-Table Risk, Process, PID, DLL, Path, FileHash -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No DLL sideloading indicators detected." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error scanning for DLL sideloading: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# 
# Get-WMIEventSubscription
# 
function Get-WMIEventSubscription {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Checking WMI event subscriptions..." -ForegroundColor DarkGray
    
    if (-not (Test-AdminPrivileges)) {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Administrator privileges required for WMI subscription access." -ForegroundColor DarkGray
        return
    }
    
    try {
        $filters = Get-WmiObject -Namespace root\subscription -Class __EventFilter -ErrorAction SilentlyContinue
        $consumers = Get-WmiObject -Namespace root\subscription -Class CommandLineEventConsumer -ErrorAction SilentlyContinue
        $allConsumers = Get-WmiObject -Namespace root\subscription -Class __EventConsumer -ErrorAction SilentlyContinue
        $bindings = Get-WmiObject -Namespace root\subscription -Class __FilterToConsumerBinding -ErrorAction SilentlyContinue
        
        $findings = @()
        
        if ($filters) {
            foreach ($filter in $filters) {
                $risk = Get-RiskLevel -Type 'WMI' -Value $filter.Query
                # Enhanced detection for PowerSploit patterns
                if ($filter.Name -eq 'Updater' -or $filter.Query -match '(SystemUpTime|Win32_LocalTime.*Hour.*Minute)') { $risk = 'High' }
                $findings += [PSCustomObject]@{
                    Type = 'EventFilter'
                    Name = $filter.Name
                    Query = $filter.Query
                    Details = $filter.QueryLanguage
                    Risk = $risk
                }
            }
        }
        
        if ($consumers) {
            foreach ($consumer in $consumers) {
                $details = $consumer.CommandLineTemplate
                $risk = 'High' # CommandLineEventConsumer is always high risk
                if ($consumer.Name -eq 'Updater' -or $details -match 'NonInteractive') { $risk = 'High' }
                $findings += [PSCustomObject]@{
                    Type = 'CommandLineEventConsumer'
                    Name = $consumer.Name
                    Query = $consumer.__CLASS
                    Details = $details
                    Risk = $risk
                }
            }
        }
        
        if ($allConsumers) {
            foreach ($consumer in $allConsumers) {
                if ($consumer.__CLASS -ne 'CommandLineEventConsumer') {
                    $details = if ($consumer.ScriptText) { $consumer.ScriptText } else { $consumer.CommandLineTemplate }
                    $risk = Get-RiskLevel -Type 'WMI' -Value $details
                    $findings += [PSCustomObject]@{
                        Type = $consumer.__CLASS
                        Name = $consumer.Name
                        Query = $consumer.__CLASS
                        Details = $details
                        Risk = $risk
                    }
                }
            }
        }
        
        if ($findings) {
            $findings | Sort-Object @{Expression={switch($_.Risk){'High'{1};'Medium'{2};'Low'{3}}}}, Type | Format-Table Risk, Type, Name, Query, Details -AutoSize
        } else {
            Write-Host "[i]" -ForegroundColor Cyan -NoNewline
            Write-Host " No WMI event subscriptions found." -ForegroundColor DarkGray
        }
    } catch {
        Write-Host "[!]" -ForegroundColor Red -NoNewline
        Write-Host " Error checking WMI subscriptions: $($_.Exception.Message)" -ForegroundColor DarkGray
    }
}

# 
# Get-ProfilePersistence
# 
function Get-ProfilePersistence {
    Write-Host "`n[+]" -ForegroundColor Green -NoNewline
    Write-Host " Checking PowerShell profile persistence..." -ForegroundColor DarkGray
    
    $profiles = @(
        @{Path=$PROFILE.AllUsersAllHosts; Scope='AllUsersAllHosts'},
        @{Path=$PROFILE.CurrentUserAllHosts; Scope='CurrentUserAllHosts'},
        @{Path=$PROFILE.AllUsersCurrentHost; Scope='AllUsersCurrentHost'},
        @{Path=$PROFILE.CurrentUserCurrentHost; Scope='CurrentUserCurrentHost'}
    )
    
    $findings = @()
    
    foreach ($prof in $profiles) {
        if ($prof.Path -and (Test-Path $prof.Path)) {
            try {
                $content = Get-Content $prof.Path -Raw -ErrorAction SilentlyContinue
                if ($content) {
                    $risk = 'Low'
                    $suspicious = @()
                    
                    if ($content -match '\s{200,}') { $suspicious += 'Large whitespace padding'; $risk = 'High' }
                    if ($content -match 'sal a New-Object') { $suspicious += 'Compressed payload'; $risk = 'High' }
                    if ($content -match 'IO\.Compression\.DeflateStream') { $suspicious += 'Deflate decompression'; $risk = 'High' }
                    if ($content -match 'FromBase64String') { $suspicious += 'Base64 decoding'; $risk = 'Medium' }
                    if ($content -match '(bypass|hidden|NonInteractive)') { $suspicious += 'Stealth execution'; $risk = 'High' }
                    if ($content -match 'Invoke-Expression|iex') { $suspicious += 'Dynamic execution'; $risk = 'Medium' }
                    
                    $hash = (Get-FileHash $prof.Path -ErrorAction SilentlyContinue).Hash
                    $size = (Get-Item $prof.Path -ErrorAction SilentlyContinue).Length
                    
                    $findings += [PSCustomObject]@{
                        ProfileScope = $prof.Scope
                        Path = $prof.Path
                        Size = $size
                        FileHash = $hash
                        Indicators = ($suspicious -join ', ')
                        Risk = $risk
                    }
                }
            } catch {}
        }
    }
    
    if ($findings) {
        $findings | Sort-Object @{Expression={switch($_.Risk){'High'{1};'Medium'{2};'Low'{3}}}}, ProfileScope | Format-Table Risk, ProfileScope, Path, Size, Indicators, FileHash -AutoSize
    } else {
        Write-Host "[i]" -ForegroundColor Cyan -NoNewline
        Write-Host " No PowerShell profile persistence detected." -ForegroundColor DarkGray
    }
}

# 
# Export functions
# 
Export-ModuleMember -Function `
    Get-Audit, `
    Get-LocalAdmins, `
    Get-LastLogon, `
    Get-Sessions, `
    Get-DefensiveServices, `
    Get-EDRSolutions, `
    Get-PasswordPolicy, `
    Get-RegistryPersistence, `
    Get-ScheduledTaskAbuse, `
    Get-ServiceHijacking, `
    Get-DLLSideloading, `
    Get-WMIEventSubscription, `
    Get-ProfilePersistence, `
    Show-AuditHelp, `
    Invoke-Audit