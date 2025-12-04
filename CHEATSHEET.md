# Scriptman Project - Command Cheatsheet

---

## Bash Scripts

### Scriptman Launcher

| Description | Command |
|---|---|
| Display help and usage | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- --help`</details> |
| Interactive menu mode | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash`</details> |

### Extract Aliases (ea)

| Description | Command |
|---|---|
| Extract to Markdown | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- ea`</details> |
| Extract to HTML | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- ea -o aliases.html`</details> |
| Extract to CSV | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- ea -o aliases.csv`</details> |
| Quiet mode | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- ea -q`</details> |

### b6se - Compression

| Description | Command |
|---|---|
| Compress to tar.gz | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -c myfolder`</details> |
| Compress to zip | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -c myfolder archive.zip`</details> |
| Compress to 7z | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -c myfolder data.7z`</details> |
| Decompress tar.gz | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -x archive.tar.gz`</details> |
| Decompress zip | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -x archive.zip`</details> |
| Decompress 7z | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -x archive.7z`</details> |

### b6se - Encoding

| Description | Command |
|---|---|
| Encode to Base64 | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -e myfile.txt`</details> |
| Decode Base64 | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -d encoded.b64`</details> |

### b6se - Encryption

| Description | Command |
|---|---|
| Encrypt file | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -E myfile.txt`</details> |
| Encrypt with password | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -E myfile.txt --password mySecret123`</details> |
| Decrypt file | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -D encrypted.enc`</details> |
| Decrypt with password | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -D encrypted.enc --password mySecret123`</details> |

### b6se - Checksums

| Description | Command |
|---|---|
| Generate checksum | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -C archive.tar.gz`</details> |
| Verify checksum | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -V archive.tar.gz archive.tar.gz.sha256`</details> |

### b6se - HTTP Server

| Description | Command |
|---|---|
| Serve file via HTTP | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -s myfile.pdf`</details> |
| Serve directory via HTTP | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -s /path/to/directory`</details> |

---

## PowerShell Scripts

### Scriptman Launcher

| Description | Command |
|---|---|
| Show help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman"`</details> |
| Run Audit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit"`</details> |

### Audit - User Enumeration

| Description | Command |
|---|---|
| Get all users | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-Audit"`</details> |
| Get administrators | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-LocalAdmins"`</details> |
| Get last logon | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-LastLogon"`</details> |
| Get sessions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-Sessions"`</details> |

### Audit - Security Detection

| Description | Command |
|---|---|
| Detect security services | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-DefensiveServices"`</details> |
| Scan for EDR/AV | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-EDRSolutions"`</details> |
| Get password policies | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-PasswordPolicy"`</details> |

### Audit - Persistence Detection

| Description | Command |
|---|---|
| Profile persistence | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-ProfilePersistence"`</details> |
| Registry persistence | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-RegistryPersistence"`</details> |
| Scheduled task abuse | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-ScheduledTaskAbuse"`</details> |
| Service hijacking | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-ServiceHijacking"`</details> |
| DLL sideloading | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-DLLSideloading"`</details> |
| DLL sideloading (limited) | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-DLLSideloading -MaxProcesses 25 -TimeoutSeconds 15"`</details> |
| WMI event subscriptions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Get-WMIEventSubscription"`</details> |

### Audit - Full Audit

| Description | Command |
|---|---|
| Complete audit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Invoke-Audit"`</details> |
| Show help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Show-AuditHelp"`</details> |

### Mitigate - Threat Removal

| Description | Command |
|---|---|
| Show help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate"`</details> |
| Preview impact (dry-run) | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Test-Impact"`</details> |
| Preview registry only | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Test-Impact -Function Registry"`</details> |
| Remove registry persistence | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-RegistryPersistence"`</details> |
| Remove scheduled tasks | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-ScheduledTaskAbuse"`</details> |
| Remove unauthorized admins | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-LocalAdmins"`</details> |
| Stop suspicious services | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-ServiceHijacking"`</details> |
| Remove WMI subscriptions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-WMIEventSubscription"`</details> |
| Clean PowerShell profiles | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-ProfilePersistence"`</details> |
| Remove all threats | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-AllThreats"`</details> |

### Mitigate - Backup & Restore

| Description | Command |
|---|---|
| Create system backup | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Backup-SystemState"`</details> |
| Restore from backup | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Restore-SystemState"`</details> |

---

## Remote Modules

### PowerView - Network Enumeration

| Description | Command |
|---|---|
| Load PowerView | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView"`</details> |
| Get domain info | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetDomain"`</details> |
| Get domain controller | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetDomainController"`</details> |
| Get forest info | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetForest"`</details> |
| List domain users | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetUser"`</details> |
| List domain computers | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetComputer"`</details> |
| List domain groups | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetGroup"`</details> |
| Get group members | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetGroupMember -GroupName 'Domain Admins'"`</details> |
| Find local admin access | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Find-LocalAdminAccess"`</details> |
| Find domain shares | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Invoke-ShareFinder"`</details> |
| Get user sessions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetSession"`</details> |
| Get logged on users | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetLoggedon"`</details> |
| Get domain trusts | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetDomainTrust"`</details> |
| Get GPOs | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetGPO"`</details> |
| Get OUs | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView:Get-NetOU"`</details> |
| List all functions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView; Get-Command -Name *-Net*"`</details> |
| Get function help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PowerView; Get-Help Get-NetDomain"`</details> |

### PSWriteColor - Console Output

| Description | Command |
|---|---|
| Load PSWriteColor | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PSWriteColor"`</details> |
| Green text | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PSWriteColor:Write-Color -Text 'Success' -Color Green"`</details> |
| Red text | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PSWriteColor:Write-Color -Text 'Error' -Color Red"`</details> |
| Yellow text | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PSWriteColor:Write-Color -Text 'Warning' -Color Yellow"`</details> |
| Multiple colors | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PSWriteColor; Write-Color -Text 'Pass','Warn','Fail' -Color Green,Yellow,Red"`</details> |
| Get help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman PSWriteColor; Get-Help Write-Color"`</details> |

---

## PowerShell Aliases Installation

### Install Convenient Aliases

| Description | Command |
|---|---|
| Install aliases (remote) | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Modules/Winmod/PowerShell/Alias.ps1 \| Invoke-Expression"`</details> |
| Install aliases (local) | <details><summary>Show</summary>`. .\Modules\Winmod\PowerShell\Alias.ps1`</details> |
| Clean PowerShell profile | <details><summary>Show</summary>`"" \| Out-File $PROFILE`</details> |

### Available Aliases (After Installation)

| Alias | Function | Description |
|---|---|---|
| `Audit` | Set-Audit | Full user audit |
| `LocalAdmins` | Set-LocalAdmins | Get local administrators |
| `LastLogon` | Set-LastLogon | Get last logon times |
| `Sessions` | Set-Sessions | Get active sessions |
| `DefensiveServices` | Set-DefensiveServices | Check security services |
| `EDRSolutions` | Set-EDRSolutions | Scan for EDR/AV |
| `PasswordPolicy` | Set-PasswordPolicy | Get password policy |
| `ProfilePersistence` | Set-ProfilePersistence | PowerShell profile scan |
| `RegistryPersistence` | Set-RegistryPersistence | Registry persistence |
| `ScheduledTaskAbuse` | Set-ScheduledTaskAbuse | Scheduled task scan |
| `ServiceHijacking` | Set-ServiceHijacking | Service hijacking scan |
| `DLLSideloading` | Set-DLLSideloading | DLL sideloading scan |
| `WMIEventSubscription` | Set-WMIEventSubscription | WMI event subscriptions |
| `AuditHelp` | Set-AuditHelp | Show help |

**After Installation:**
1. **Open a new PowerShell window** - Aliases work automatically
2. **Or reload current session:** `. $PROFILE`
3. **Test aliases:** `Audit`, `LocalAdmins`, `ProfilePersistence`

**Note:** Execution policy is automatically configured. Aliases are permanent.

--- Command |
|---|---|
| Run complete audit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Invoke-Audit"`</details> |

### Audit - Local Import

| Description | Command |
|---|---|
| Import module | <details><summary>Show</summary>`Import-Module .\\Modules\\Winmod\\PowerShell\\Audit\\Audit.psm1 -Force`</details> |
| Get module info | <details><summary>Show</summary>`Get-Module Audit`</details> |
| List functions | <details><summary>Show</summary>`Get-Command -Module Audit`</details> |

---

## Installation & Setup

### Linux/WSL

| Description | Command |
|---|---|
| Install globally | <details><summary>Show</summary>`sudo curl -s -o /usr/local/bin/Scriptman https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman && sudo chmod +x /usr/local/bin/Scriptman`</details> |
| Clone repository | <details><summary>Show</summary>`git clone https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem.git && cd Scriptmanem`</details> |
| Run tests | <details><summary>Show</summary>`bash tests/test_project.sh`</details> |

---

## Quick Reference

### b6se Options

| Short | Long | Description |
|---|---|---|
| `-c` | `--compress` | Compress file/directory |
| `-x` | `--decompress` | Decompress archive |
| `-e` | `--encode` | Encode to Base64 |
| `-d` | `--decode` | Decode Base64 |
| `-E` | `--encrypt` | Encrypt file (AES-256) |
| `-D` | `--decrypt` | Decrypt file |
| `-C` | `--checksum` | Generate SHA-256 |
| `-V` | `--verify` | Verify checksum |
| `-s` | `--serve` | Serve via HTTP |
| `-p` | `--password` | Set password |
| `-v` | `--version` | Show version |
| `-h` | `--help` | Show help |

### Extract Aliases Options

| Short | Long | Description |
|---|---|---|
| `-o` | `--output` | Output filename/format |
| `-q` | `--quiet` | Suppress auto-open |
| `-h` | `--help` | Show help |

### Audit Cmdlets

| Cmdlet | Description |
|---|---|
| `Get-Audit` | List all local users |
| `Get-LocalAdmins` | List administrators |
| `Get-LastLogon` | Show last logon times |
| `Get-Sessions` | List active sessions |
| `Get-RegistryPersistence` | Registry persistence scan |
| `Get-ScheduledTaskAbuse` | Scheduled task abuse scan |
| `Get-ServiceHijacking` | Service hijacking scan |
| `Get-DLLSideloading` | DLL sideloading scan |
| `Get-WMIEventSubscription` | WMI event subscription scan |
| `Get-ProfilePersistence` | PowerShell profile persistence |
| `Get-DefensiveServices` | Detect security services |
| `Get-EDRSolutions` | Scan for EDR/AV |
| `Get-PasswordPolicy` | Show password policies |
| `Show-AuditHelp` | Show help menu |
| `Invoke-Audit` | Run full audit |

### Mitigate Cmdlets

| Cmdlet | Description |
|---|---|
| `Remove-RegistryPersistence` | Remove suspicious registry entries |
| `Remove-ScheduledTaskAbuse` | Remove suspicious scheduled tasks |
| `Remove-ServiceHijacking` | Stop suspicious services |
| `Remove-WMIEventSubscription` | Remove malicious WMI subscriptions |
| `Remove-ProfilePersistence` | Clean suspicious PowerShell profiles |
| `Remove-LocalAdmins` | Remove unauthorized administrators |
| `Remove-AllThreats` | Run all mitigation functions |
| `Test-Impact` | Preview changes (dry-run mode) |
| `Backup-SystemState` | Create system backup |
| `Restore-SystemState` | Restore from backup |
| `Show-MitigateHelp` | Show help menu |
| `Invoke-Mitigate` | Default entry point |

---

## Best Practices

**Bash:**
- Use `curl -s` for silent execution
- Use `bash -s --` to pass arguments
- Use `sudo` for privileged operations
- Verify checksums after transfers
- Use `.7z` for maximum compression
- Combine: compress then encrypt

**PowerShell:**
- Use `-ExecutionPolicy Bypass` for remote execution
- Run as Administrator for full functionality
- Redirect output: `| Out-File audit.txt`
- Pin to branch (b6se_) for stability
- Verify URLs before executing

---

## Module Metadata

| Module | Version | Language | Location | Type |
|---|---|---|---|---|
| b6se | 1.3.0 | Bash 4.0+ | `Modules/Linmod/Bash/b6se/` | Local |
| Extract Aliases | 1.1.0 | Bash 4.0+ | `Modules/Linmod/Bash/extract-aliases/` | Local |
| Audit | 1.0.0 | PowerShell 5.1+ | `Modules/Winmod/PowerShell/Audit/` | Local |
| Mitigate | 1.0.0 | PowerShell 5.1+ | `Modules/Winmod/PowerShell/Mitigate/` | Local |
| PowerView | 3.0 | PowerShell 5.1+ | External (PowerShellEmpire) | Remote |
| PSWriteColor | 1.0 | PowerShell 5.1+ | External (EvotecIT) | Remote |
| Scriptman | 1.5.0 / 2.0.3 | Bash / PowerShell | Root directory | Framework |

---

**Last Updated:** 2025  
**Maintained by:** Gabriel Dakinah Vincent  
**License:** MIT

