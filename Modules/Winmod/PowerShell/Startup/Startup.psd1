@{
    RootModule            = 'Startup.psm1'
    ModuleVersion         = '1.0.0'
    GUID                  = '12345678-1234-1234-1234-123456789012'
    Author                = 'Gabriel Dakinah Vincent'
    CompanyName           = 'Scriptmanem'
    Description           = 'Startup animation module for system login/reboot with typewriter effect'
    PowerShellVersion     = '5.1'
    FunctionsToExport     = @(
        'Install-Animation',
        'Uninstall-Animation'
    )
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @()
    PrivateData           = @{
        PSData = @{
            Tags       = @('Startup', 'Animation', 'Login', 'Typewriter')
            ProjectUri = 'https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem'
            LicenseUri = 'https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem/blob/main/LICENSE'
        }
    }
}
