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
| Get-UserLastLogon | Shows last logon timestamps |
| Get-UserSessions | Lists currently active sessions |
| Get-DefensiveServices | Detects Defender & security services |
| Get-EDRSolutions | Basic EDR/AV detection |
| Get-PasswordPolicy | Displays password & lockout policies |
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
Get-UserLastLogon
```
```powershell
Get-UserSessions
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
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | iex; Scriptman Audit"
```

Open remote help:

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | iex; Scriptman Audit:Show-AuditHelp"
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
powershell -ExecutionPolicy Bypass -Command "Invoke-RestMethod https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Modules/Winmod/PowerShell/Alias.ps1 | Invoke-Expression"
```

**Available Aliases:**
- `Audit` - Full audit
- `LocalAdmins` - Get administrators
- `UserSessions` - Active sessions
- `PersistenceAudit` - Persistence scan
- `PasswordPolicy` - Password policy
- `AuditHelp` - Show help
- And more...

**After Installation:**
1. **Open a new PowerShell window** - Aliases are automatically available
2. **Or reload current session:** `. $PROFILE`
3. **Test aliases:** `Audit`, `LocalAdmins`, `PersistenceAudit`

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
| Repository | https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises |

---

## 👤 Author

**Gabriel Dakinah Vincent**  
Cybersecurity Intern • Developer • PowerShell Automation Enthusiast  
Maintainer of *Bash-Exercises* Repository  

© 2025 Gabriel Dakinah Vincent. All rights reserved.
