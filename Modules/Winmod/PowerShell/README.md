# Audit PowerShell Module  
### Windows Local Account Auditing Toolkit

---

![PowerShell](https://img.shields.io/badge/PowerShell-Module-blue)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)
![Version](https://img.shields.io/badge/Version-1.0.0-purple)
![Status](https://img.shields.io/badge/Status-Stable-brightgreen)

---

## 📘 Overview

Audit is a lightweight PowerShell module that provides fast and reliable insights into local user accounts and the security posture of Windows systems.

It is designed for:

- System Administrators  
- Security Analysts  
- Cybersecurity Interns  
- Incident Responders  
- Workstation and Server Auditors  

The module collects and summarizes key security data including:

- Local users & account states  
- Local Administrators group members  
- Last logon timestamps  
- Active user sessions  
- Windows Defender & core security services  
- Basic EDR/AV detection  
- Password and lockout policies  
- Registry-based persistence mechanisms
- Scheduled task abuse detection
- Service hijacking indicators
- DLL sideloading detection
- WMI event subscription monitoring
- PowerShell profile persistence  

---

## 📁 Project Structure

```
Audit/
│
├── Audit.psm1     # Main module implementation
├── Audit.psd1     # Module manifest metadata
└── Audit.ps1      # Optional standalone runner
```

---

## ⚙️ Installation

### 1️⃣ Import the Module

```powershell
Import-Module .\Audit.psm1 -Force
```

Verify:

```powershell
Get-Module Audit
```

---

## 🚀 Usage

### 2️⃣ Core Commands

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

### Example Session

```powershell
Import-Module .\Audit.psm1 -Force
```
```powershell
Get-Audit
```
```powershell
Get-LocalAdmins
```
```powershell
Get-LastLogon
```
```powershell
Get-Sessions
```
```powershell
Get-RegistryPersistence
```
```powershell
Get-ProfilePersistence
```
```powershell
Get-PasswordPolicy
```
```powershell
Get-DefensiveServices
```

---

## 🤖 Full Automated Audit

```powershell
Invoke-Audit
```

---

## 🌐 Remote Execution (No Clone Needed)

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | iex; Scriptman Audit"
```

Open remote help:

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | iex; Scriptman Audit:Show-AuditHelp"
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

- Run PowerShell as **Administrator**  
- Use **ExecutionPolicy Bypass** only when needed  
- Verify remote script URLs before executing  
- Pin to a specific branch (e.g., `b6se_`)  
- Update often to access new features  

---

## 🧩 Extending the Module

To add new features:

1. Add the function inside **Audit.psm1**  
2. Add its name to **FunctionsToExport** in *Audit.psd1*  
3. Increment the version number  

### Example Extension

```powershell
function Get-UserGroups {
    Get-LocalGroup | ForEach-Object {
        [PSCustomObject]@{
            GroupName = $_.Name
            Members   = (Get-LocalGroupMember -Group $_.Name).Count
        }
    } | Format-Table -AutoSize
}
```

---

## 📄 Module Metadata

| Property | Value |
|----------|--------|
| Module Name | Audit |
| Version | 1.0.0 |
| Author | Gabriel Dakinah Vincent |
| Compatible PowerShell | Windows PowerShell 5.1, PowerShell 7+ |
| License | MIT |
| Repository | https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem |

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
Scriptman

# Load remote module
Scriptman PowerView

# Run specific function (follows Scriptman pattern)
Scriptman PowerView:Get-NetDomain
Scriptman PowerView:Get-NetUser
Scriptman PowerView:Get-NetComputer
Scriptman PowerView:Find-LocalAdminAccess

# Get help for remote modules
Scriptman PowerView
Get-Command -Name *-Net*
Get-Help Get-NetDomain

# Use array parameters (load module first)
Scriptman PSWriteColor
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
