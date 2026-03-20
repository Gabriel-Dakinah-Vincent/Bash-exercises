# Startup Animation Module

**Version:** 1.0.0  
**Author:** Gabriel Dakinah Vincent  
**License:** MIT  

---

## Overview

Simple module to install/uninstall startup animations with typewriter effects that run at system login.

**Smart Features:**
- ✅ Automatically detects admin privileges
- ✅ Uses All-Users folder if admin (runs for all users)
- ✅ Falls back to Current User folder if non-admin (runs for current user only)
- ✅ Works seamlessly for both admin and standard users
- ✅ No manual configuration needed

---

## Functions

### Install-Animation
Install animation to run at next login.

```powershell
Install-Animation [-Message <string>]
```

**Behavior:**
- If running as **Admin**: Installs to All-Users startup folder (runs for all users)
- If running as **Standard User**: Installs to Current User startup folder (runs only for current user)

**Parameters:**
- `-Message` - Custom startup message (optional, default: "INITIALIZING EADMIRAL CORE... ACCESS GRANTED. WELCOME BACK, OPERATOR.")

**Examples:**
```powershell
Scriptman Startup:Install-Animation
Scriptman Startup:Install-Animation -Message "WELCOME TO MY SYSTEM"
```

---

### Uninstall-Animation
Remove animation from startup.

```powershell
Uninstall-Animation
```

**Behavior:**
- Removes from appropriate folder based on current privileges
- Cleans up both shortcut and script files

**Example:**
```powershell
Scriptman Startup:Uninstall-Animation
```

---

## Privilege Handling

### Admin User
```
Installation Scope: All-Users
Script Location: C:\Users\<username>\AppData\Roaming\Scriptmanem\Startup\Animation.ps1
Shortcut Location: C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Animation.lnk
Animation runs for: All users on the system
```

### Standard User
```
Installation Scope: Current User
Script Location: C:\Users\<username>\AppData\Roaming\Scriptmanem\Startup\Animation.ps1
Shortcut Location: C:\Users\<username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Animation.lnk
Animation runs for: Current user only
```

---

## File Locations

### Admin Installation
| Component | Location |
|-----------|----------|
| Animation Script | `%APPDATA%\Scriptmanem\Startup\Animation.ps1` |
| Startup Shortcut | `%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\Animation.lnk` |

### Standard User Installation
| Component | Location |
|-----------|----------|
| Animation Script | `%APPDATA%\Scriptmanem\Startup\Animation.ps1` |
| Startup Shortcut | `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Animation.lnk` |

---

## Quick Start

1. Install animation:
   ```powershell
   Scriptman Startup:Install-Animation
   ```

2. Reboot to see animation at login

3. To uninstall:
   ```powershell
   Scriptman Startup:Uninstall-Animation
   ```

---

## Usage Examples

### Example 1: Standard User Installation
```powershell
Scriptman Startup:Install-Animation
# Animation will run for current user only at next login
```

### Example 2: Admin Installation for All Users
```powershell
# Run PowerShell as Administrator
Scriptman Startup:Install-Animation
# Animation will run for all users at next login
```

### Example 3: Custom Message
```powershell
Scriptman Startup:Install-Animation -Message "SYSTEM ONLINE"
# Animation displays: SYSTEM ONLINE
```

### Example 4: Uninstall
```powershell
Scriptman Startup:Uninstall-Animation
```

---

## Animation Details

### Default Message
```
INITIALIZING EADMIRAL CORE... ACCESS GRANTED. WELCOME BACK, OPERATOR.
```

### Animation Sequence
1. **Clear Screen** - Clears the console
2. **Typewriter Effect** - Displays message character-by-character (40ms per character)
3. **Blinking Cursor** - Shows animated cursor (4 blinks, 300ms each)
4. **Ready Message** - Displays "SYSTEM READY." in white
5. **Pause** - Waits 2 seconds before continuing

### Customization
Edit the animation script directly:
```powershell
notepad "$env:APPDATA\Scriptmanem\Startup\Animation.ps1"
```

You can modify:
- Message text
- Colors (Green, Cyan, White, etc.)
- Timing (milliseconds)
- Cursor blinks

---

## Troubleshooting

### Animation doesn't run at startup
1. Verify shortcut exists in correct startup folder:
   - Admin: `%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp\`
   - Standard: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\`

2. Check file permissions in the startup folder

### Permission denied error
- Ensure write access to `%APPDATA%`
- For All-Users installation, run PowerShell as Administrator

### Script not found error
- Reinstall the animation:
  ```powershell
  Scriptman Startup:Install-Animation
  ```

### Want to install for all users
- Run PowerShell as Administrator
- Then run:
  ```powershell
  Scriptman Startup:Install-Animation
  ```

### Want to change the message
- Reinstall with new message:
  ```powershell
  Scriptman Startup:Install-Animation -Message "NEW MESSAGE"
  ```

---

## Behavior Matrix

| User Type | Privilege | Startup Folder | Scope | Animation Runs For |
|-----------|-----------|-----------------|-------|-------------------|
| Admin | Yes | `%ProgramData%\...` | All-Users | All users |
| Standard | No | `%APPDATA%\...` | Current User | Current user only |

---

## Key Features

✅ **No Admin Required** - Works for standard users without elevation  
✅ **Admin Support** - Can install for all users if running as admin  
✅ **Automatic Detection** - No manual configuration needed  
✅ **Smart Fallback** - Gracefully handles permission issues  
✅ **Simple** - Only 2 essential functions  
✅ **Error Handling** - Comprehensive error messages  

---

## Module Statistics

| Metric | Value |
|--------|-------|
| Code Lines | ~120 |
| Functions Exported | 2 |
| Helper Functions | 3 |
| Error Handling | Yes |
| Admin Detection | Yes |
| Privilege Handling | Yes |

---

## Integration with Scriptmanem

The Startup module is fully integrated with the Scriptmanem framework:

```powershell
# Install animation
Scriptman Startup:Install-Animation

# With custom message
Scriptman Startup:Install-Animation -Message "CUSTOM MESSAGE"

# Uninstall
Scriptman Startup:Uninstall-Animation
```

---

## Security Notes

✅ **No Privilege Escalation** - Doesn't request admin rights  
✅ **User-Scoped** - Standard users can only affect their own startup  
✅ **Admin-Scoped** - Admins can affect all users  
✅ **Safe Fallback** - Always uses writable location  
✅ **No System Directories** - Avoids system-level modifications  

---

## License

MIT License - See LICENSE file for details

---

## Support

For issues or questions:
1. Check the Troubleshooting section above
2. Check file permissions in the startup folder
3. Verify the animation script exists in `%APPDATA%\Scriptmanem\Startup\`

---

## Version History

### v1.0.0 (2025)
- Initial release
- Typewriter animation with cursor effect
- Install/uninstall functionality
- Admin privilege detection
- Dual startup folder support (All-Users and Current User)
- Works for both admin and standard users

---

**Created:** 2025  
**Module Version:** 1.0.0  
**Author:** Gabriel Dakinah Vincent  
**Status:** ✅ Production Ready
