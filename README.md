# Scriptman  
**Current Version:** 1.5.0  
**Author:** Gabriel Dakinah Vincent  
**License:** MIT  

---

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20WSL-lightgrey)
![Bash](https://img.shields.io/badge/Bash-4.0+-green)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207+-blue)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

## Table of Contents
- [Overview](#overview)
- [Project Structure](#project-structure)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Modules](#modules)
- [Quick Start - Get Help](#quick-start---get-help)
- [Usage](#usage)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)
- [Changelog](#changelog)

---

## Overview

**Scriptman** is a unified multi-environment automation framework for Bash, PowerShell, and CMD. It provides a modular CLI interface to execute scripts and utilities locally or remotely from GitHub, supporting:

- **Bash** (Linux / WSL)
- **PowerShell** (Windows & PowerShell Core)
- **CMD** (Windows Command Prompt)

The project includes three launcher scripts that orchestrate modular features and a full PowerShell auditing toolkit.

---

## Project Structure

```
Scriptmanem/
├── Scriptman              # Bash launcher (main entry point)
├── Scriptman.ps1          # PowerShell launcher
├── Scriptman.cmd          # CMD launcher (Windows)
├── core/
│   └── psm-manifest.json  # Module registry for PowerShell
├── Modules/
│   ├── Linmod/            # Linux/Bash modules
│   │   └── Bash/
│   │       ├── b6se/                    # Secure CLI utility
│   │       ├── extract-aliases/         # Shell alias extractor
│   │       └── recovery-passwords/      # Password recovery (WIP)
│   └── Winmod/            # Windows modules
│       ├── PowerShell/
│       │   ├── Audit/               # Windows account auditing
│       │   └── Mitigate/            # Security threat mitigation
│       └── Cmd/
├── tests/
│   └── test_project.sh    # Project test suite
├── assets/
│   └── .gif/              # Demo GIFs
├── CHEATSHEET.md          # Complete command reference
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

---

## Features

### Core Capabilities

- 🧩 **Modular Execution** – Run supported scripts locally or remotely
- 🌐 **Remote Testing Ready** – Works with `curl | bash` or `irm | iex` for CI/CD pipelines
- 🔄 **Cross-Platform** – Unified interface across Bash, PowerShell, and CMD
- 📦 **Zero-Config** – Works out of the box with sensible defaults
- 🔐 **Security-Focused** – Built-in encryption, authentication, and auditing

---

## Installation

### Make Scriptman Permanent (Linux/WSL)

```bash
sudo curl -s -o /usr/local/bin/Scriptman https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman
sudo chmod +x /usr/local/bin/Scriptman
```

### Clone for Development

```bash
git clone https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem.git
cd Scriptmanem
```

---

## Quick Start

### Bash (Linux/WSL)

```bash
# Extract shell aliases
bash Scriptman ea -q -o aliases.md

# Run b6se CLI utility
bash Scriptman b6se --help
bash Scriptman b6se -c myfolder
bash Scriptman b6se -x archive.tar.gz

# Remote execution (no clone needed)
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman | bash -s -- ea -q -o aliases.md
```

### PowerShell (Windows)

```powershell
# Remote execution
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | iex; Scriptman Audit"

# Local import
Import-Module .\Modules\Winmod\PowerShell\Audit\Audit.psm1 -Force
Get-Audit
```

---

## Modules

### 🔹 b6se — Secure CLI Utility

Multi-format compression, encoding, encryption, and secure file sharing.

**Features:**
- Multi-format compression (.tar.gz, .zip, .7z) with auto-detection
- Base64 encoding/decoding
- AES encryption/decryption
- Secure HTTP file serving with authentication
- Configurable defaults via `config.ini`
- Log rotation and offline help

**Documentation:** [b6se README](Modules/Linmod/Bash/b6se/README.md)

---

### 🔹 Extract Aliases

Extracts shell aliases and outputs in Markdown, CSV, or HTML format.

**Features:**
- Automatic shell detection (Bash, Zsh, Fish, etc.)
- Multiple output formats
- Custom output filenames
- Quiet mode option

**Documentation:** [Extract Aliases README](Modules/Linmod/Bash/extract-aliases/README.md)

---

### 🔹 Recovery Passwords

Password recovery feature (currently under development).

---

### ⭐ Audit — Windows Account Auditing Toolkit

Comprehensive PowerShell module for auditing local user accounts and Windows security.

**Features:**
- List all local users with account states
- Display Administrators group members
- Show last logon timestamps
- List active user sessions
- Detect Windows Defender & security services
- Basic EDR/AV detection
- Display password and lockout policies

**Core Commands:**
```powershell
Get-Audit                  # List all local users
Get-LocalAdmins            # Show Administrators
Get-LastLogon              # Last logon timestamps
Get-Sessions               # Active sessions
Get-DefensiveServices      # Security services
Get-EDRSolutions           # EDR/AV detection
Get-PasswordPolicy         # Password policies
Get-RegistryPersistence    # Registry-based persistence
Get-ScheduledTaskAbuse     # Suspicious scheduled tasks
Get-ServiceHijacking       # Service hijacking detection
Get-DLLSideloading         # DLL sideloading indicators
Get-WMIEventSubscription   # WMI event subscriptions
Get-ProfilePersistence     # PowerShell profile persistence
Invoke-Audit               # Full audit summary
```

**Enhanced Detection:**
- PowerSploit persistence techniques
- Registry Run keys with stealth payloads
- WMI CommandLineEventConsumer abuse
- PowerShell profile modifications
- Scheduled task persistence patterns
- LSA Security Support Provider DLLs

**Documentation:** [Audit README](Modules/Winmod/PowerShell/README.md)

---

### ⭐ Mitigate — Security Threat Mitigation Module

Comprehensive PowerShell module for removing detected security threats with granular control and backup capabilities.

**Features:**
- Individual confirmation for each threat removal
- System backup and restore capabilities
- Preview mode (dry-run) to see impact before changes
- Bulk threat removal with Remove-AllThreats
- Reuses Audit module functions for threat detection
- Professional output formatting

**Core Commands:**
```powershell
Remove-RegistryPersistence    # Remove suspicious registry entries
Remove-ScheduledTaskAbuse     # Remove suspicious scheduled tasks
Remove-ServiceHijacking       # Stop suspicious services
Remove-WMIEventSubscription   # Remove malicious WMI subscriptions
Remove-ProfilePersistence     # Clean suspicious PowerShell profiles
Remove-LocalAdmins            # Remove unauthorized administrators
Remove-AllThreats             # Run all mitigation functions
Test-Impact                   # Preview changes (dry-run mode)
Backup-SystemState            # Create system backup
Restore-SystemState           # Restore from backup
```

**Safety Features:**
- Individual threat confirmation prompts
- System restore point creation
- Registry key backups
- Preview mode for impact assessment
- Comprehensive error handling

**Documentation:** [Mitigate README](Modules/Winmod/PowerShell/Mitigate/README.md)

---

### ⭐ Remote Modules — External PowerShell Modules

Scriptman supports loading PowerShell modules directly from external GitHub repositories without local installation.

**Available Remote Modules:**
- **PowerView** - Network situational awareness for Windows domains
- **PSWriteColor** - Colorful console output utility

**Usage:**
```powershell
# Load and execute remote module functions
Scriptman PowerView:Get-NetDomain
Scriptman PSWriteColor:Write-Color -Text "Hello" -Color Green

# Get help for remote modules
Scriptman PowerView
Get-Command -Name *-Net*
Get-Help Get-NetDomain

# Use array parameters (load module first)
Scriptman PSWriteColor
Write-Color -Text "Pass","Warn","Fail" -Color Green,Yellow,Red
```

**Adding Custom Remote Modules:**

Edit `core/psm-manifest.json`:
```json
{
  "YourModule": {
    "description": "Module description",
    "type": "remote",
    "url": "https://raw.githubusercontent.com/user/repo/branch/module.ps1",
    "version": "1.0",
    "author": "Author Name"
  }
}
```

**Documentation:** [Remote Modules Guide](Modules/Winmod/PowerShell/README.md#remote-module-support)

---

## Quick Start - Get Help

### Bash Scripts

| Description | Command |
|---|---|
| Show Scriptman help | <details><summary>📋 Copy Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- --help`</details> |
| Show Extract Aliases help | <details><summary>📋 Copy Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- ea -h`</details> |
| Show b6se help | <details><summary>📋 Copy Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman \| bash -s -- b6se --help`</details> |

### PowerShell Scripts

| Description | Command |
|---|---|
| Show Scriptman help | <details><summary>📋 Copy Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman"`</details> |
| Show Audit help | <details><summary>📋 Copy Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Audit:Show-AuditHelp"`</details> |
| Show Mitigate help | <details><summary>📋 Copy Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate"`</details> |
| Preview Mitigation Impact | <details><summary>📋 Copy Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Test-Impact"`</details> |
| Remove Registry Persistence | <details><summary>📋 Copy Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-RegistryPersistence"`</details> |
| Remove All Threats | <details><summary>📋 Copy Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 \| iex; Scriptman Mitigate:Remove-AllThreats"`</details> |

**For complete command reference, see [CHEATSHEET.md](CHEATSHEET.md)**

---

## Usage

### Direct Execution (No Installation)

**Bash:**
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/b6se_/Scriptman | bash -s -- --help
```

**PowerShell:**
```powershell
irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/b6se_/Scriptman.ps1 | iex; Scriptman
```

### Local Execution

**Bash:**
```bash
bash Scriptman --help
```

**PowerShell:**
```powershell
Import-Module .\Modules\Winmod\PowerShell\Audit\Audit.psm1 -Force
Show-AuditHelp
```

---

## FAQ

**Q: What Bash version is required?**  
A: Bash 4.0 or higher.

**Q: What if I get a "Permission denied" error?**  
A: Run with a writable path (like ~/Documents) or use `sudo`.

**Q: Does it work without cloning?**  
A: Yes — all commands work remotely via `curl | bash` or `irm | iex`.

**Q: Can I customize config values?**  
A: Yes — edit `Modules/Linmod/Bash/b6se/config/config.ini` after the first run.

**Q: Which compression formats are supported?**  
A: `.tar.gz`, `.zip`, and `.7z` (auto-detected, no extra flags required).

**Q: Can I run Audit without admin privileges?**  
A: Some functions require administrator rights. Run PowerShell as Administrator for full functionality.

**Q: How do I extend the modules?**  
A: Add new functions to the module files and update the manifest or export lists accordingly.

**Q: Can I use modules from other GitHub repositories?**  
A: Yes! Add them to `core/psm-manifest.json` as `type: "remote"` with the raw GitHub URL.

**Q: Do remote modules require installation?**  
A: No — remote modules are fetched and loaded automatically when called.

---

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes and test thoroughly
4. Commit: `git commit -m "Add my feature"`
5. Push: `git push origin feature/my-feature`
6. Open a pull request

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for full details.

---

## Acknowledgments

- Thanks to the open-source community for continuous support
- Inspired by real-world Bash automation and DevSecOps practices
- Built as part of the Cybersecurity Awareness CLI Initiative at Elevation Institute of Technology, Monrovia

---

## Contact

For questions or support:
- 📧 Open an Issue or join the Discussions tab on GitHub
- 🧠 Author: Gabriel Dakinah Vincent
- 🔗 Repository: https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem

---

## Changelog

### Version 1.5.0 — Remote Module Support
- Added remote module support via manifest registry
- Modules can be loaded directly from external GitHub repositories
- No local installation required for remote modules
- Added PowerView and PSWriteColor as example remote modules
- Unified `Scriptman Module:Function` syntax for all modules
- Enhanced manifest with module type detection (local/remote)

### Version 1.4.0 — Security Mitigation Module
- Added Mitigate PowerShell module for threat removal
- Individual confirmation prompts for granular control
- System backup and restore capabilities
- Preview mode (Test-Impact) for dry-run operations
- Bulk threat removal with Remove-AllThreats
- Professional output formatting matching Audit module

### Version 1.3.0 — Multi-Format Compression Update
- Added support for `.tar.gz`, `.zip`, and `.7z` archives
- Introduced automatic format detection
- Improved error handling and graceful fallback for missing tools
- Enhanced compatibility for Linux and WSL environments
- Fully integrated with Scriptman CLI for both local and remote execution

### Version 1.2.0 — PowerShell Module Integration
- Added Audit PowerShell module for Windows account auditing
- Implemented Scriptman.ps1 launcher with manifest-based module loading
- Added remote module fallback support

### Version 1.1.0 — Extract Aliases Enhancement
- Added CSV and HTML output formats
- Improved shell detection
- Added quiet mode option

### Version 1.0.0 — Initial Release
- Core Scriptman launcher
- b6se CLI utility
- Extract Aliases module
- Basic documentation

---

**Last Updated:** 2025  
**Maintained by:** Gabriel Dakinah Vincent

