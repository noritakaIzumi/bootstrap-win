$global:ScoopSearchInstalled = $null -ne (scoop list "^scoop-search$" | Select-Object -ExpandProperty Name)

BeforeAll {
    if (!$ScoopSearchInstalled)
    {
        scoop install scoop-search
    }
    Invoke-Expression (&scoop-search --hook)

    function Test-Scoop-Package-Exists([string]$Package)
    {
        $null -ne (scoop search ${Package} | Select-String -Raw "\s${Package}\s")
    }
}

AfterAll {
    if (!$ScoopSearchInstalled)
    {
        scoop uninstall scoop-search --purge
        scoop cache rm scoop-search
    }
}

$global:KnownBuckets = scoop bucket known

Describe 'Test-Config-Scoop' {
    $Buckets = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\scoop_buckets.txt | Select-Object)
    It 'The bucket "<_>" exists in scoop' -ForEach $Buckets {
        $_ | Should -BeIn $KnownBuckets
    }
    $expectedDependencies = [string[]](Get-Content -Path ${PSScriptRoot}\..\config\scoop_dependencies.txt | Select-Object)
    It 'The Package "<_>" exists in scoop' -ForEach $expectedDependencies {
        Test-Scoop-Package-Exists $_ | Should -Be $true
    }
}
