<#
.SYNOPSIS
 User account auditing functions for Windows.
#>

function Get-UserAudit {
    <#
        .SYNOPSIS
        Displays summary info about local users on this system.
    #>
    Write-Host "`n[+] Collecting user account information..." -ForegroundColor Cyan

    try {
        $users = Get-LocalUser | Select-Object Name, Enabled, LastLogon
        if ($users) {
            $users | Format-Table Name, Enabled, LastLogon -AutoSize
        }
        else {
            Write-Host "No local users found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error fetching local users: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Get-LocalAdmins {
    <#
        .SYNOPSIS
        Lists all members of the local Administrators group.
    #>
    Write-Host "`n[+] Enumerating local administrators..." -ForegroundColor Cyan
    try {
        $admins = Get-LocalGroupMember -Group "Administrators" | Select-Object Name, ObjectClass
        if ($admins) {
            $admins | Format-Table Name, ObjectClass -AutoSize
        } else {
            Write-Host "No administrators found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error retrieving administrators: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Get-UserLastLogon {
    <#
        .SYNOPSIS
        Shows the last logon timestamp for each local user.
    #>
    Write-Host "`n[+] Gathering last logon data..." -ForegroundColor Cyan
    try {
        Get-LocalUser | ForEach-Object {
            [PSCustomObject]@{
                UserName  = $_.Name
                LastLogon = $_.LastLogon
            }
        } | Format-Table UserName, LastLogon -AutoSize
    }
    catch {
        Write-Host "Error retrieving last logon times: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-UserAuditHelp {
    <#
        .SYNOPSIS
        Displays help information for the UserAudit module.
    #>
    Write-Host "`n=== UserAudit Module Help ===" -ForegroundColor Magenta
    Write-Host "Version: 1.0.0" -ForegroundColor Yellow
    Write-Host "Description: A PowerShell module to audit users and user accounts." -ForegroundColor Cyan

    Write-Host "`nAvailable Commands:`n" -ForegroundColor Green
    Write-Host "  Get-UserAudit      - Displays local user summary"
    Write-Host "  Get-LocalAdmins    - Lists members of the Administrators group"
    Write-Host "  Get-UserLastLogon  - Shows last logon timestamp for each local user"
    Write-Host "  Show-UserAuditHelp - Displays this help menu"

    Write-Host "`nUsage Examples:" -ForegroundColor Yellow
    Write-Host "  Get-Help Get-UserAudit -Detailed"
    Write-Host "  Show-UserAuditHelp"
}

Export-ModuleMember -Function Get-UserAudit, Get-LocalAdmins, Get-UserLastLogon, Show-UserAuditHelp