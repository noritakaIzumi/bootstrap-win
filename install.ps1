function Log($message)
{
    Write-Output "`n${message}`n"
}

function IsAdmin
{
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")
}

function RunAsAdmin
{
    param([string]$File, [string]$_Args = "")

    Start-Process pwsh.exe "-File `"$File`" $_Args" -Verb RunAs -Wait
}

function InstallChocoDependencies
{
    param([string]$File)

    Log "Install choco dependencies: START"

    $dependencies = [string[]](Get-Content -Path $File | Select-Object)
    foreach ($dependency in $dependencies)
    {
        Log "Searching ${dependency} from the installed..."
        if (choco list --limit-output --exact $dependency)
        {
            Log "Upgrading ${dependency}..."
            choco upgrade -y $dependency
        }
        else
        {
            Log "Installing ${dependency}..."
            choco install -y $dependency
        }
    }

    Log "Install choco dependencies: END"
}

function InstallWingetDependencies
{
    param([string]$File)

    Log "Install winget dependencies: START"

    $dependencies = [string[]](Get-Content -Path $File | Select-Object)
    $source = "winget"
    foreach ($dependency in $dependencies)
    {
        Log "Searching ${dependency} from the installed..."
        if ($Env:CI)
        {
            winget list --exact --id $dependency --source $source --accept-source-agreements
        }
        else
        {
            winget list --exact --id $dependency --source $source
        }

        if ($?)
        {
            Log "Upgrading ${dependency}..."
            if ($Env:CI)
            {
                winget upgrade --exact --id $dependency --source $source --accept-package-agreements --accept-source-agreements
            }
            else
            {
                winget upgrade --exact --id $dependency --source $source
            }
        }
        else
        {
            Log "Installing ${dependency}..."
            if ($Env:CI)
            {
                winget install --exact --id $dependency --source $source --accept-package-agreements --accept-source-agreements
            }
            else
            {
                winget install --exact --id $dependency --source $source
            }
        }
    }

    Log "Install winget dependencies: END"
}

function InstallScoopDependencies
{
    param([string]$BucketsFile, [string]$DependenciesFile)

    Log "Install scoop dependencies: START"

    scoop update

    $expectedBuckets = [string[]](Get-Content -Path $BucketsFile | Select-Object)
    $actualBuckets = scoop bucket list | Select-Object -ExpandProperty name
    foreach ($bucket in $expectedBuckets)
    {
        if ($bucket -notin $actualBuckets)
        {
            scoop bucket add $bucket
        }
    }

    $expectedDependencies = [string[]](Get-Content -Path $DependenciesFile | Select-Object)
    $actualDependencies = scoop list | Select-Object -ExpandProperty name
    foreach ($dependency in $expectedDependencies)
    {
        if ($dependency -in $actualDependencies)
        {
            Log "Upgrading ${dependency}..."
            scoop update $dependency
        }
        else
        {
            Log "Installing ${dependency}..."
            scoop install $dependency
        }
    }

    Log "Install scoop dependencies: END"
}

function Main
{
    if (-not (IsAdmin))
    {
        RunAsAdmin -File $PSCommandPath
        exit
    }

    $ConfigDir = "${PSScriptRoot}\config"

    InstallChocoDependencies -File ${ConfigDir}\choco_dependencies.txt
    InstallWingetDependencies -File ${ConfigDir}\winget_dependencies.txt
    InstallScoopDependencies -BucketsFile ${ConfigDir}\scoop_buckets.txt -DependenciesFile ${ConfigDir}\scoop_dependencies.txt

    # End
    Read-Host "Press enter key..."
    exit
}

Main
