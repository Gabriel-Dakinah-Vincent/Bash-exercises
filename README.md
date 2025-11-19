# Scriptman  
**Current Version:** 1.3.0  
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
- [Command Reference](#command-reference)
- [Usage](#usage)
- [Examples](#examples)
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
Bash-exercises/
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
│       │   └── UserAudit/               # Windows account auditing
│       └── Cmd/
├── tests/
│   └── test_project.sh    # Project test suite
├── assets/
│   └── .gif/              # Demo GIFs
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
sudo curl -s -o /usr/local/bin/Scriptman https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman
sudo chmod +x /usr/local/bin/Scriptman
```

### Clone for Development

```bash
git clone https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises.git
cd Bash-exercises
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
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman | bash -s -- ea -q -o aliases.md
```

### PowerShell (Windows)

```powershell
# Remote execution
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | iex; Scriptman UserAudit"

# Local import
Import-Module .\Modules\Winmod\PowerShell\UserAudit\UserAudit.psm1 -Force
Get-UserAudit
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

### ⭐ UserAudit — Windows Account Auditing Toolkit

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
Get-UserAudit              # List all local users
Get-LocalAdmins            # Show Administrators
Get-UserLastLogon          # Last logon timestamps
Get-UserSessions           # Active sessions
Get-DefensiveServices      # Security services
Get-EDRSolutions           # EDR/AV detection
Get-PasswordPolicy         # Password policies
Invoke-UserAudit           # Full audit summary
```

**Documentation:** [UserAudit README](Modules/Winmod/PowerShell/README.md)

---

## Command Reference

### Bash Scripts

| **Description** | **Command** |
|-----------------|-------------|
| Displays Scriptman help and usage | <details><summary>Show Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- --help`</details> |
| Run Extract Aliases | <details><summary>Show Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- ea -q -o aliases.html`</details> |
| Display CLI Utility help and usage | <details><summary>Show Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se --help`</details> |
| Serve file via HTTP | <details><summary>Show Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| sudo bash -s -- b6se --serve`</details> |
| Compress directory | <details><summary>Show Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- b6se -c myfolder`</details> |
| Decompress archive | <details><summary>Show Command</summary>`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman \| bash -s -- b6se -x archive.tar.gz`</details> |

### PowerShell Scripts

| **Description** | **Command** |
|-----------------|-------------|
| Module for auditing Windows users | <details><summary>Show Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit"`</details> |
| Show UserAudit help | <details><summary>Show Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Show-UserAuditHelp"`</details> |
| Get all local users | <details><summary>Show Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-UserAudit"`</details> |
| Get local administrators | <details><summary>Show Command</summary>`powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 \| iex; Scriptman UserAudit:Get-LocalAdmins"`</details> |

---

## Usage

### Direct Execution (No Installation)

**Bash:**
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman | bash -s -- ea -h
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Scriptman | bash -s -- b6se --help
```

**PowerShell:**
```powershell
irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | iex; Scriptman UserAudit
```

### Local Execution

**Bash:**
```bash
bash Scriptman ea -q -o aliases.md
bash Scriptman b6se -c myfolder
bash Scriptman b6se -x archive.zip
bash Scriptman b6se --password mySecret123 -E file.txt
```

**PowerShell:**
```powershell
Import-Module .\Modules\Winmod\PowerShell\UserAudit\UserAudit.psm1 -Force
Get-UserAudit
Get-LocalAdmins
Invoke-UserAudit
```

---

## Examples

### Example 1: Extract Aliases to HTML

```bash
bash Scriptman ea -q -o my_aliases.html
```

Output: Creates `my_aliases.html` with all shell aliases in a formatted table.

---

### Example 2: Compress and Encrypt a Folder

```bash
bash Scriptman b6se -c ~/Documents
bash Scriptman b6se --password mySecret123 -E Documents.tar.gz
```

Output: Creates encrypted `Documents.tar.gz.enc` file.

---

### Example 3: Serve a File Securely

```bash
bash Scriptman b6se -s ~/report.pdf
```

Output:
```
[INFO] Starting HTTP server for ~/report.pdf on port 8080
[INFO] Server started (PID 3495)
Press Ctrl+C to stop
```

---

### Example 4: Full Windows Audit

```powershell
Import-Module .\Modules\Winmod\PowerShell\UserAudit\UserAudit.psm1 -Force
Invoke-UserAudit
```

Output: Comprehensive audit report including users, admins, sessions, security services, and policies.

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

**Q: Can I run UserAudit without admin privileges?**  
A: Some functions require administrator rights. Run PowerShell as Administrator for full functionality.

**Q: How do I extend the modules?**  
A: Add new functions to the module files and update the manifest or export lists accordingly.

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
- 🔗 Repository: https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises

---

## Changelog

### Version 1.3.0 — Multi-Format Compression Update
- Added support for `.tar.gz`, `.zip`, and `.7z` archives
- Introduced automatic format detection
- Improved error handling and graceful fallback for missing tools
- Enhanced compatibility for Linux and WSL environments
- Fully integrated with Scriptman CLI for both local and remote execution

### Version 1.2.0 — PowerShell Module Integration
- Added UserAudit PowerShell module for Windows account auditing
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
