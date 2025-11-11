# 🧩 UserAudit PowerShell Module

> **Module Name:** `UserAudit`  
> **Version:** 1.0.0  
> **Author:** Gabriel Dakinah Vincent  
> **Project:** [Bash-Exercises](https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises)

---

## 📘 Overview

`UserAudit` is a PowerShell module designed to **audit local users and account permissions** on Windows systems.  
It provides administrators and security interns with quick visibility into:

- Local user accounts  
- Enabled or disabled states  
- Membership of the Administrators group  
- Last logon timestamps  

This module supports both **local execution** and **remote GitHub-based execution**, enabling portable use across environments.

---

## ⚙️ Module Files

UserAudit/
├── UserAudit.psm1   # Core module functions
├── UserAudit.psd1   # Module manifest (metadata)
└── UserAudit.ps1    # Optional standalone runner

---

## 🚀 Usage

### 🧠 1. Import the Module
To load the module manually:

```powershell
Import-Module .\UserAudit.psm1 -Force
```
Verify it’s loaded:

Get-Module UserAudit


⸻

🧾 2. Run the Audit Functions

List all local users

```powershell
Get-UserAudit
```
```powershell
View local administrators
```
```powershell
Get-LocalAdmins
```
```powershell
Show last logon timestamps
```
```powershell
Get-UserLastLogon
```

⸻

💡 3. Run via the Included Launcher (Optional)

You can also use the launcher script for quick access:

```powershell
.\UserAudit.ps1
```

This script automatically imports the module and runs all three audit commands sequentially.

⸻

🌐 4. Remote Execution (No Local Files Required)

You can run UserAudit directly from GitHub:

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | iex; Scriptman UserAudit"
```

💬 This is useful for quick remote audits or testing environments where the module is not yet cloned locally.

⸻

🧾 Module Functions

Function	Description
Get-UserAudit	Lists all local users with their enabled/disabled state and last logon timestamp.
Get-LocalAdmins	Displays all members of the local Administrators group.
Get-UserLastLogon	Shows the last logon date for each local account.
Show-UserAuditHelp (optional)	Displays module help and usage examples.


⸻

🧰 Best Practices
	1.	Run PowerShell as Administrator for accurate results.
	2.	Use ExecutionPolicy Bypass when running remote scripts.
	3.	Always verify remote script sources before executing them in production.
	4.	For reproducibility, reference a specific GitHub branch or tag (e.g., b6se_).
	5.	Regularly update the module to get the latest auditing improvements.

⸻

🧑‍💻 Example: Full Audit Session

# Step 1: Import the module
Import-Module .\UserAudit.psm1 -Force

# Step 2: Run audit commands
Get-UserAudit
Get-LocalAdmins
Get-UserLastLogon


⸻

🧩 Extend or Customize

To extend functionality, simply:
	1.	Add new functions inside UserAudit.psm1.
	2.	Update the FunctionsToExport list in UserAudit.psd1.
	3.	Increment the version number before committing.

Example new function:
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

⸻

🧾 Version & Metadata

Property	Value
Module Name	UserAudit
Version	1.0.0
Author	Gabriel Dakinah Vincent
Compatible PowerShell	5.1, Core 7+
License	MIT
Project URI	https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises


⸻

🧑‍💻 Author

Gabriel Dakinah Vincent
Cybersecurity Intern • Developer • Project Maintainer
📦 Bash-Exercises Repository

© 2025 Gabriel Dakinah Vincent. All rights reserved.

⸻
