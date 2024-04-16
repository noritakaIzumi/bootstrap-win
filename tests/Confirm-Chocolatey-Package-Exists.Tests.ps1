#Requires -RunAsAdministrator


BeforeAll {
    $UseEnhancedExitCodesFeatureDisabled = [string](choco feature get useEnhancedExitCodes).Contains("Disabled")
    if ($UseEnhancedExitCodesFeatureDisabled)
    {
        choco feature enable --name="'useEnhancedExitCodes'"
    }

    function Confirm-Chocolatey-Package-Exists([string]$Package)
    {
        choco search --exact $Package > $null

        $?
    }
}

AfterAll {
    if ($UseEnhancedExitCodesFeatureDisabled)
    {
        choco feature disable --name="'useEnhancedExitCodes'"
    }
}

Describe 'Confirm-Chocolatey-Package-Exists' {
    $Packages = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\choco_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in chocolatey' -ForEach $Packages {
        Confirm-Chocolatey-Package-Exists $_ | Should -Be $true
    }
}
