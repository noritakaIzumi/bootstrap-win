BeforeAll {
}

AfterAll {
}

Describe 'Test-Config-Chocolatey' {
    $Packages = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\choco_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in chocolatey' -ForEach $Packages {
        choco search --exact $_ | Select-String -Raw "^${_}\s" | Should -Not -BeNullOrEmpty
    }
}
