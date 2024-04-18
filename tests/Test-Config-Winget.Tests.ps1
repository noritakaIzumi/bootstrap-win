BeforeDiscovery {
    if (!(Get-Command winget))
    {
        Set-ItResult -Skipped -Because "Winget is not installed"
    }
}

BeforeAll {
    function Search-Winget-Package([string]$Package)
    {
        if ($Env:CI)
        {
            winget search --exact --id $Package --accept-source-agreements
        }
        else
        {
            winget search --exact --id $Package
        }
    }
}

AfterAll {
}

Describe 'Test-Config-Winget' {
    $Packages = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\winget_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in winget' -ForEach $Packages {
        Search-Winget-Package $_
        $? | Should -Be $true
    }
}
