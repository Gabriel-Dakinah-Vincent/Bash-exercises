@{
    # Module manifest for Mitigate module
    RootModule = 'Mitigate.psm1'
    ModuleVersion = '1.0.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'Gabriel Dakinah Vincent'
    CompanyName = ''
    Copyright = '(c) 2025 Gabriel Dakinah Vincent. All rights reserved.'
    Description = 'Security mitigation module that removes detected threats by reusing Audit module functions'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()
    
    # Functions to export from this module
    FunctionsToExport = @(
        'Remove-RegistryPersistence',
        'Remove-ScheduledTaskAbuse', 
        'Remove-ServiceHijacking',
        'Remove-WMIEventSubscription',
        'Remove-ProfilePersistence',
        'Remove-LocalAdmins',
        'Remove-AllThreats',
        'Backup-SystemState',
        'Restore-SystemState',
        'Test-Impact',
        'Invoke-Mitigate',
        'Show-MitigateHelp'
    )
    
    # Cmdlets to export from this module
    CmdletsToExport = @()
    
    # Variables to export from this module
    VariablesToExport = @()
    
    # Aliases to export from this module
    AliasesToExport = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            Tags = @('Security', 'Mitigation', 'Windows', 'Audit', 'Scriptman')
            LicenseUri = ''
            ProjectUri = 'https://github.com/Gabriel-Dakinah-Vincent/Bash-exercises'
            ReleaseNotes = 'Initial release of Mitigate module for Scriptman framework'
        }
    }
}