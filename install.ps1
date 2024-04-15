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

    Start-Process powershell.exe "-File `"$File`" $_Args" -Verb RunAs -Wait
}

function InstallChocoDependencies
{
    param([string]$Config)

    # Install chocolatey
    if (!(Get-Command choco -ErrorAction SilentlyContinue))
    {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    choco install "${Config}" -y
}

function InstallWingetDependencies
{
    param([string]$File)

    $dependencies = [string[]](Get-Content -Path $File | Select-Object)
    $source = "winget"
    foreach ($dependency in $dependencies)
    {
        Log "Searching ${dependency} from the installed..."
        winget list --exact --id $dependency --source $source
        if ($?)
        {
            Log "Upgrading ${dependency}..."
            winget upgrade --exact --id $dependency --source $source
        }
        else
        {
            Log "Installing ${dependency}..."
            winget install --exact --id $dependency --source $source
        }
    }
}

function Main
{
    if (-not (IsAdmin))
    {
        RunAsAdmin -File $PSCommandPath
        exit
    }

    $ConfigDir = "${PSScriptRoot}\config"

    InstallChocoDependencies -Config ${ConfigDir}\choco.config
    InstallWingetDependencies -File ${ConfigDir}\winget_dependencies.txt

    # End
    Read-Host "Press enter key..."
    exit
}

Main
