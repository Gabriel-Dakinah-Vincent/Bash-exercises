# Mitigate Module

**Version:** 1.0.0  
**Author:** Gabriel Dakinah Vincent  
**License:** MIT  

## Overview

The **Mitigate** module is a security mitigation framework that removes detected threats by reusing Audit module functions. It provides granular control over threat removal with individual confirmation prompts and comprehensive backup capabilities.

## Features

- 🔍 **Reuses Audit Functions** - Leverages existing audit capabilities for threat detection
- ⚡ **Individual Confirmation** - Prompts for each threat before removal
- 💾 **Backup & Restore** - Creates system restore points and registry backups
- 👁️ **Preview Mode** - Test-Impact shows what would be removed without making changes
- 🔄 **Bulk Operations** - Remove-AllThreats handles multiple threat types
- 📊 **Professional Output** - Consistent formatting with Audit module style

## Installation

The Mitigate module is automatically available through Scriptman and requires the Audit module as a dependency.

## Quick Start

### Basic Usage
```powershell
# Show help and available functions
Scriptman Mitigate

# Preview what would be removed (dry-run)
Scriptman Mitigate:Test-Impact

# Remove specific threat types
Scriptman Mitigate:Remove-RegistryPersistence
Scriptman Mitigate:Remove-LocalAdmins

# Create backup before mitigation
Scriptman Mitigate:Backup-SystemState

# Remove all detected threats
Scriptman Mitigate:Remove-AllThreats
```

### Remote Execution
```powershell
# Remote execution without cloning
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/b6se_/Scriptman.ps1 | iex; Scriptman Mitigate:Test-Impact"
```

## Available Functions

### Core Mitigation Functions
- `Remove-RegistryPersistence` - Remove suspicious registry persistence entries
- `Remove-ScheduledTaskAbuse` - Remove suspicious scheduled tasks  
- `Remove-ServiceHijacking` - Stop suspicious services
- `Remove-WMIEventSubscription` - Remove malicious WMI subscriptions
- `Remove-ProfilePersistence` - Clean suspicious PowerShell profiles
- `Remove-LocalAdmins` - Remove unauthorized administrators

### Utility Functions
- `Remove-AllThreats` - Run all mitigation functions with backup option
- `Test-Impact` - Preview mitigation impact (dry-run mode)
- `Backup-SystemState` - Create system backup before mitigation
- `Restore-SystemState` - Restore from backup
- `Invoke-Mitigate` - Default entry point (shows help)
- `Show-MitigateHelp` - Display help menu

## Usage Examples

### Individual Threat Removal
```powershell
# Remove registry persistence with individual confirmations
Scriptman Mitigate:Remove-RegistryPersistence

# Remove unauthorized administrators
Scriptman Mitigate:Remove-LocalAdmins
```

### Preview Mode
```powershell
# Preview all changes
Scriptman Mitigate:Test-Impact

# Preview specific categories
Scriptman Mitigate:Test-Impact -Function Registry
Scriptman Mitigate:Test-Impact -Function Tasks
Scriptman Mitigate:Test-Impact -Function Admins
Scriptman Mitigate:Test-Impact -Function Services
```

### Backup & Restore
```powershell
# Create backup
Scriptman Mitigate:Backup-SystemState

# Restore from backup
Scriptman Mitigate:Restore-SystemState -BackupPath "C:\Temp\ScriptmanBackup_20250101_120000"
```

### Bulk Operations
```powershell
# Remove all threats with backup
Scriptman Mitigate:Remove-AllThreats
# This will:
# 1. Prompt to create backup
# 2. Prompt to confirm bulk operation
# 3. Run all mitigation functions
# 4. Show individual confirmations for each threat
```

## Safety Features

### Individual Confirmations
Each mitigation function prompts for individual threat confirmation:
```
[?] Remove 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\SuspiciousApp' (C:\temp\malware.exe)? (Y/N):
```

### Backup System
- **System Restore Points** - Windows system restore capability
- **Registry Exports** - Backup of Run/RunOnce keys
- **Task Lists** - Scheduled task inventory
- **Admin Groups** - Administrator membership backup

### Preview Mode
Test-Impact shows exactly what would be affected:
```
[+] Impact preview - no changes will be made...

[+] Registry persistence entries...
Entry Name    Registry Key                           Value
----------    ------------                           -----
MyApp         HKEY_LOCAL_MACHINE\...\Run            C:\Program Files\MyApp\app.exe

[i] Preview completed. Total items: 1
```

## Architecture

The Mitigate module follows these design principles:

1. **Dependency on Audit** - Reuses Audit functions for threat detection
2. **Individual Control** - Each threat requires separate confirmation
3. **Safety First** - Backup capabilities and preview mode
4. **Consistent UI** - Matches Audit module output style
5. **Scriptman Integration** - Full compatibility with Scriptman framework

## Requirements

- **PowerShell 5.1+** or **PowerShell Core**
- **Audit Module** (automatically loaded)
- **Administrator Privileges** (for most functions)
- **Windows System** (Windows 10/11, Windows Server)

## Contributing

Contributions are welcome! Please follow the existing code style and ensure all functions:
- Use individual confirmation prompts
- Follow the `[+]`, `[i]`, `[!]` output format
- Include proper error handling
- Maintain compatibility with Scriptman framework

## License

This project is licensed under the MIT License.

## Support

For questions or issues:
- Open an issue on GitHub
- Check the main Scriptman documentation
- Review the CHEATSHEET.md for quick reference