BeforeAll {
}

AfterAll {
}

Describe 'Test-Winget-Package-Exists' {
    $Packages = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\winget_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in winget' -ForEach $Packages {
        winget search --exact --id $_ > $null
        $? | Should -Be $true
    }
}
