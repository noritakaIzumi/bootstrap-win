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
            winget search --exact --id $Package --accept-source-agreements > $null
        }
        else
        {
            winget search --exact --id $Package > $null
        }

        return $?
    }
}

AfterAll {
}

Describe 'Test-Config-Winget' {
    $Packages = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\winget_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in winget' -ForEach $Packages {
        $package = $_ -replace "^#\s+", ""
        Search-Winget-Package $package | Should -Be $true
    }
}
