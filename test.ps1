Import-Module Pester -PassThru
Invoke-Pester -Output Detailed $PSScriptRoot\tests
