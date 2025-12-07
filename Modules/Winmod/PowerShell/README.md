# Scriptman'em Modules
### Comprehensive Security & Automation Toolkit

---

![PowerShell](https://img.shields.io/badge/PowerShell-Module-blue)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)
![Version](https://img.shields.io/badge/Version-2.0.0-purple)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen)

---

## 📘 Overview

Scriptmanem is a comprehensive security and automation toolkit with modules for Windows and Linux systems. It provides fast and reliable insights into system security posture, threat detection, and mitigation capabilities.

Designed for:

- System Administrators  
- Security Analysts  
- Cybersecurity Interns  
- Incident Responders  
- Workstation and Server Auditors  

### Module Categories

**Windows (Winmod):**
- Audit - System security auditing and threat detection
- Mitigate - Automated threat removal and remediation
- Cmd - Command-line utilities



---

## 📁 Project Structure

```
Scriptmanem/
│
├── Modules/
│   └── Winmod/
│       ├── PowerShell/
│       │   ├── Audit/          # Windows security auditing
│       │   ├── Mitigate/       # Threat mitigation & remediation
│       │   └── Alias.ps1       # PowerShell aliases
│       └── Cmd/                # Command-line utilities
│
└── core/
    └── psm-manifest.json       # Module manifest
```

---

## ⚙️ Installation

### Windows Modules (PowerShell)

```powershell
Import-Module .\Audit.psm1 -Force
Import-Module .\Mitigate.psm1 -Force
```

Verify:

```powershell
Get-Module Audit, Mitigate
```

---

## 🚀 Usage

### Audit Module (Windows)

| Function | Description |
|----------|-------------|
| Get-Audit | Lists all local users with state + last logon |
| Get-LocalAdmins | Displays Administrators group members |
| Get-LastLogon | Shows last logon timestamps |
| Get-Sessions | Lists currently active sessions |
| Get-DefensiveServices | Detects Defender & security services |
| Get-EDRSolutions | Basic EDR/AV detection |
| Get-PasswordPolicy | Displays password & lockout policies |
| Get-RegistryPersistence | Scans registry-based persistence |
| Get-ScheduledTaskAbuse | Detects suspicious scheduled tasks |
| Get-ServiceHijacking | Identifies service hijacking |
| Get-DLLSideloading | Scans for DLL sideloading indicators |
| Get-WMIEventSubscription | Checks WMI event subscriptions |
| Get-ProfilePersistence | Scans PowerShell profile persistence |
| Show-AuditHelp | Shows module usage help |
| Invoke-Audit | Runs a full audit summary |

### Mitigate Module (Windows)

| Function | Description |
|----------|-------------|
| Remove-RegistryPersistence | Remove suspicious registry entries |
| Remove-ScheduledTaskAbuse | Remove malicious scheduled tasks |
| Remove-ServiceHijacking | Stop suspicious services |
| Remove-WMIEventSubscription | Remove malicious WMI subscriptions |
| Remove-ProfilePersistence | Clean PowerShell profile threats |
| Remove-LocalAdmins | Remove unauthorized administrators |
| Remove-AllThreats | Run all mitigation functions |
| Test-Impact | Preview changes (dry-run mode) |
| Backup-SystemState | Create system backup |
| Restore-SystemState | Restore from backup |
| Show-MitigateHelp | Display help menu |

### Example Sessions

**Windows Audit:**
```powershell
Import-Module .\Audit.psm1 -Force
Get-Audit
Get-LocalAdmins
Get-RegistryPersistence
Get-ProfilePersistence
```

**Windows Mitigation:**
```powershell
Import-Module .\Mitigate.psm1 -Force
Test-Impact
Backup-SystemState
Remove-RegistryPersistence
```

---

## 🤖 Full Automated Operations

**Windows Audit:**
```powershell
Invoke-Audit
```

**Windows Mitigation:**
```powershell
Invoke-Mitigate
```

---

## 🌐 Remote Execution (No Clone Needed)

**Audit Module:**
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | iex; .\Scriptman.ps1 Audit"
```

**Mitigate Module:**
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | iex; .\Scriptman.ps1 Mitigate:Test-Impact"
```

---

## 🔗 PowerShell Aliases Installation

Install convenient aliases for all Audit functions:

**Local Installation:**

```powershell
. .\Alias.ps1
```
```powershell
. .\Modules\Winmod\PowerShell\Alias.ps1
```

**Remote Installation:**
```powershell
powershell -ExecutionPolicy Bypass -Command "Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Modules/Winmod/PowerShell/Alias.ps1 | Invoke-Expression"
```

**Available Aliases:**
- `Audit` - Full audit
- `LocalAdmins` - Get administrators
- `LastLogon` - Last logon times
- `Sessions` - Active sessions
- `RegistryPersistence` - Registry persistence scan
- `ProfilePersistence` - PowerShell profile scan
- `ScheduledTaskAbuse` - Scheduled task scan
- `ServiceHijacking` - Service hijacking scan
- `DLLSideloading` - DLL sideloading scan
- `WMIEventSubscription` - WMI event scan
- `PasswordPolicy` - Password policy
- `AuditHelp` - Show help

**After Installation:**
1. **Open a new PowerShell window** - Aliases are automatically available
2. **Or reload current session:** `. $PROFILE`
3. **Test aliases:** `Audit`, `LocalAdmins`, `ProfilePersistence`

**Note:** Execution policy is automatically configured during installation.

---

## 🧰 Best Practices

**Windows:**
- Run PowerShell as **Administrator**  
- Use **ExecutionPolicy Bypass** only when needed  
- Create backups before running Mitigate functions
- Use Test-Impact for dry-run validation
- Verify remote script URLs before executing  



---

## 🧩 Extending Modules

**PowerShell (Audit/Mitigate):**
1. Add function to module file (.psm1)
2. Export in manifest (.psd1)
3. Increment version number



---

## 📄 Module Metadata

| Property | Value |
|----------|--------|
| Project Name | Scriptmanem |
| Version | 2.0.0 |
| Author | Gabriel Dakinah Vincent |
| Compatible PowerShell | Windows PowerShell 5.1, PowerShell 7+ |
| License | MIT |
| Repository | https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem |
| Platforms | Windows 10/11, Windows Server |

---

## 🎯 Recent Improvements (v2.0.0)

### Windows Modules
- **Mitigate Module** - New threat remediation framework with backup/restore
- **Individual Confirmations** - Each threat requires separate approval
- **Preview Mode** - Test-Impact for dry-run validation
- **System Backups** - Automatic backup before mitigation
- **Enhanced Detection** - Improved persistence mechanism detection

### Framework
- **Remote Module Support** - Load modules from external repositories
- **Unified Manifest** - Central module configuration
- **Cross-Platform** - Windows and Linux support
- **Better Documentation** - Comprehensive help and examples

---

## 👤 Author

**Gabriel Dakinah Vincent**  
Cybersecurity Intern • Developer • PowerShell Automation Enthusiast  
Maintainer of *Scriptmanem* Repository  

© 2025 Gabriel Dakinah Vincent. All rights reserved.

---

# Remote Module Support

## Quick Start

Scriptman.ps1 now supports remote modules from external repositories. Simply add them to `core/psm-manifest.json`.

## Adding Remote Modules

### 1. Edit Manifest

Add to `core/psm-manifest.json`:

```json
{
  "ModuleName": {
    "description": "Module description",
    "type": "remote",
    "url": "https://raw.githubusercontent.com/user/repo/branch/path/module.ps1",
    "version": "1.0",
    "author": "Author Name"
  }
}
```

### 2. Example: PowerView (Already Added)

```json
{
  "PowerView": {
    "description": "PowerShell tool for gaining network situational awareness on Windows domains.",
    "type": "remote",
    "url": "https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/refs/heads/master/PowerView/powerview.ps1",
    "version": "3.0",
    "author": "PowerShellEmpire"
  }
}
```

## Usage

```powershell
# List available modules (shows Remote/Local)
.\Scriptman.ps1

# Load remote module
.\Scriptman.ps1 PowerView

# Run specific function (follows Scriptman pattern)
.\Scriptman.ps1 PowerView:Get-NetDomain
.\Scriptman.ps1 PowerView:Get-NetUser
.\Scriptman.ps1 PowerView:Get-NetComputer
.\Scriptman.ps1 PowerView:Find-LocalAdminAccess

# Get help for remote modules
.\Scriptman.ps1 PowerView
Get-Command -Name *-Net*
Get-Help Get-NetDomain

# Use array parameters (load module first)
.\Scriptman.ps1 PSWriteColor
Write-Color -Text "Pass","Warn","Fail" -Color Green,Yellow,Red
```

## How It Works

1. Scriptman checks manifest for module type
2. If `type: "remote"`, downloads from URL to temp file
3. Imports module into session
4. Executes function
5. Cleans up temp file

## More Examples

### Invoke-Mimikatz
```json
{
  "Invoke-Mimikatz": {
    "description": "PowerShell implementation of Mimikatz",
    "type": "remote",
    "url": "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1",
    "version": "3.0",
    "author": "PowerShellMafia"
  }
}
```

### Custom Module
```json
{
  "MyModule": {
    "description": "My custom PowerShell module",
    "type": "remote",
    "url": "https://raw.githubusercontent.com/myuser/myrepo/main/MyModule.ps1",
    "version": "1.0",
    "author": "Your Name"
  }
}
```

## Notes

- Use raw GitHub URLs (not HTML pages)
- Windows Defender may block security tools
- Test modules before production use
- Remote modules work with existing Scriptman logic
