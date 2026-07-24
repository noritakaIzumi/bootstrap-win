function FindPowerShellExecutable
{
    Get-Command pwsh -ErrorAction SilentlyContinue > $null
    if ($?)
    {
        "pwsh.exe"
        return
    }

    Get-Command powershell -ErrorAction SilentlyContinue > $null
    if ($?)
    {
        "powershell.exe"
        return
    }

    Write-Error "PowerShell executable not found!!"
    exit 1
}

function IsAdmin
{
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")
}

function RunAsAdmin
{
    param([string]$File, [string]$_Args = "")

    Start-Process (FindPowerShellExecutable) "-File `"$File`" $_Args" -Verb RunAs -Wait
}

function Main
{
    if (-not (IsAdmin))
    {
        RunAsAdmin -File $PSCommandPath
        exit
    }

    # Install chocolatey
    if (!(Get-Command choco -ErrorAction SilentlyContinue))
    {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # Install scoop
    if (!(Get-Command scoop -ErrorAction SilentlyContinue))
    {
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    }

    # End
    Read-Host "Press enter key..."
    exit
}

Main
