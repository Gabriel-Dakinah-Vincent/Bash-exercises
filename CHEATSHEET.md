# Scriptman Project - Command Cheatsheet

---

## Bash Scripts

### Scriptman Launcher

| Description | Command |
|---|---|
| Display help and usage | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- --help`</details> |
| Interactive menu mode | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash`</details> |

### Extract Aliases (ea)

| Description | Command |
|---|---|
| Extract to Markdown | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- ea`</details> |
| Extract to HTML | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- ea -o aliases.html`</details> |
| Extract to CSV | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- ea -o aliases.csv`</details> |
| Quiet mode | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- ea -q`</details> |

### b6se - Compression

| Description | Command |
|---|---|
| Compress to tar.gz | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -c myfolder`</details> |
| Compress to zip | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -c myfolder archive.zip`</details> |
| Compress to 7z | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -c myfolder data.7z`</details> |
| Decompress tar.gz | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -x archive.tar.gz`</details> |
| Decompress zip | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -x archive.zip`</details> |
| Decompress 7z | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -x archive.7z`</details> |

### b6se - Encoding

| Description | Command |
|---|---|
| Encode to Base64 | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -e myfile.txt`</details> |
| Decode Base64 | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -d encoded.b64`</details> |

### b6se - Encryption

| Description | Command |
|---|---|
| Encrypt file | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -E myfile.txt`</details> |
| Encrypt with password | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -E myfile.txt --password mySecret123`</details> |
| Decrypt file | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -D encrypted.enc`</details> |
| Decrypt with password | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -D encrypted.enc --password mySecret123`</details> |

### b6se - Checksums

| Description | Command |
|---|---|
| Generate checksum | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -C archive.tar.gz`</details> |
| Verify checksum | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -V archive.tar.gz archive.tar.gz.sha256`</details> |

### b6se - HTTP Server

| Description | Command |
|---|---|
| Serve file via HTTP | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -s myfile.pdf`</details> |
| Serve directory via HTTP | <details><summary>Show</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se -s /path/to/directory`</details> |

---

## PowerShell Scripts

### Scriptman Launcher

| Description | Command |
|---|---|
| Show help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman"`</details> |
| Run UserAudit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit"`</details> |

### UserAudit - User Enumeration

| Description | Command |
|---|---|
| Get all users | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-UserAudit"`</details> |
| Get administrators | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-LocalAdmins"`</details> |
| Get last logon | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-UserLastLogon"`</details> |
| Get sessions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-UserSessions"`</details> |

### UserAudit - Security Detection

| Description | Command |
|---|---|
| Detect security services | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-DefensiveServices"`</details> |
| Scan for EDR/AV | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-EDRSolutions"`</details> |
| Get password policies | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-PasswordPolicy"`</details> |

### UserAudit - Persistence Detection

| Description | Command |
|---|---|
| Full persistence audit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-PersistenceAudit"`</details> |
| Registry persistence | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-RegistryPersistence"`</details> |
| Scheduled task abuse | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-ScheduledTaskAbuse"`</details> |
| Service hijacking | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-ServiceHijacking"`</details> |
| DLL sideloading | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-DLLSideloading"`</details> |
| DLL sideloading (limited) | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-DLLSideloading -MaxProcesses 25 -TimeoutSeconds 15"`</details> |
| WMI event subscriptions | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-WMIEventSubscription"`</details> |

### UserAudit - Full Audit

| Description | Command |
|---|---|
| Complete audit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Invoke-UserAudit"`</details> |
| Show help | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Show-UserAuditHelp"`</details> |

---

## PowerShell Aliases Installation

### Install Convenient Aliases

| Description | Command |
|---|---|
| Install aliases (remote) | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Modules/Winmod/PowerShell/Alias.ps1 \| Invoke-Expression"`</details> |
| Install aliases (local) | <details><summary>Show</summary>`. .\Modules\Winmod\PowerShell\Alias.ps1`</details> |
| Clean PowerShell profile | <details><summary>Show</summary>`"" \| Out-File $PROFILE`</details> |

### Available Aliases (After Installation)

| Alias | Function | Description |
|---|---|---|
| `UserAudit` | Set-UserAudit | Full user audit |
| `LocalAdmins` | Set-LocalAdmins | Get local administrators |
| `UserLastLogon` | Set-UserLastLogon | Get last logon times |
| `UserSessions` | Set-UserSessions | Get active sessions |
| `DefensiveServices` | Set-DefensiveServices | Check security services |
| `EDRSolutions` | Set-EDRSolutions | Scan for EDR/AV |
| `PasswordPolicy` | Set-PasswordPolicy | Get password policy |
| `PersistenceAudit` | Set-PersistenceAudit | Full persistence scan |
| `RegistryPersistence` | Set-RegistryPersistence | Registry persistence |
| `ScheduledTaskAbuse` | Set-ScheduledTaskAbuse | Scheduled task scan |
| `ServiceHijacking` | Set-ServiceHijacking | Service hijacking scan |
| `DLLSideloading` | Set-DLLSideloading | DLL sideloading scan |
| `WMIEventSubscription` | Set-WMIEventSubscription | WMI event subscriptions |
| `UserAuditHelp` | Set-UserAuditHelp | Show help |

**Note:** Aliases are permanently installed to PowerShell profile and work in new sessions.

--- Command |
|---|---|
| Run complete audit | <details><summary>Show</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Invoke-UserAudit"`</details> |

### UserAudit - Local Import

| Description | Command |
|---|---|
| Import module | <details><summary>Show</summary>`Import-Module .\\Modules\\Winmod\\PowerShell\\UserAudit\\UserAudit.psm1 -Force`</details> |
| Get module info | <details><summary>Show</summary>`Get-Module UserAudit`</details> |
| List functions | <details><summary>Show</summary>`Get-Command -Module UserAudit`</details> |

---

## Installation & Setup

### Linux/WSL

| Description | Command |
|---|---|
| Install globally | <details><summary>Show</summary>`sudo curl -s -o /usr/local/bin/Scriptman https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman && sudo chmod +x /usr/local/bin/Scriptman`</details> |
| Clone repository | <details><summary>Show</summary>`git clone https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises.git && cd Bash-exercises`</details> |
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

### UserAudit Cmdlets

| Cmdlet | Description |
|---|---|
| `Get-UserAudit` | List all local users |
| `Get-LocalAdmins` | List administrators |
| `Get-UserLastLogon` | Show last logon times |
| `Get-UserSessions` | List active sessions |
| `Get-DefensiveServices` | Detect security services |
| `Get-EDRSolutions` | Scan for EDR/AV |
| `Get-PasswordPolicy` | Show password policies |
| `Show-UserAuditHelp` | Show help menu |
| `Invoke-UserAudit` | Run full audit |

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

| Module | Version | Language | Location |
|---|---|---|---|
| b6se | 1.3.0 | Bash 4.0+ | `Modules/Linmod/Bash/b6se/` |
| Extract Aliases | 1.1.0 | Bash 4.0+ | `Modules/Linmod/Bash/extract-aliases/` |
| UserAudit | 1.0.0 | PowerShell 5.1+ | `Modules/Winmod/PowerShell/UserAudit/` |
| Scriptman | 1.3.0 / 2.0.3 | Bash / PowerShell | Root directory |

---

**Last Updated:** 2025  
**Maintained by:** Gabriel Dakinah Vincent  
**License:** MIT
