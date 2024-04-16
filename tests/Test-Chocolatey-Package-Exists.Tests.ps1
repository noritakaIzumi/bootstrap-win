#Requires -RunAsAdministrator

$UseEnhancedExitCodesFeatureDisabled = [string](choco feature get useEnhancedExitCodes).Contains("Disabled")

BeforeAll {
    if ($UseEnhancedExitCodesFeatureDisabled)
    {
        choco feature enable --name="'useEnhancedExitCodes'"
    }
}

AfterAll {
    if ($UseEnhancedExitCodesFeatureDisabled)
    {
        choco feature disable --name="'useEnhancedExitCodes'"
    }
}

Describe 'Test-Chocolatey-Package-Exists' {
    $Packages = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\choco_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in chocolatey' -ForEach $Packages {
        choco search --exact $_ > $null
        $? | Should -Be $true
    }
}
