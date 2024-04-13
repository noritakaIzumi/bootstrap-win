function Log($message)
{
    Write-Output "`n${message}`n"
}

function IsAdmin
{
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")
}

function RunAsAdmin()
{
    param([string]$File)

    Start-Process powershell.exe "-File `"$File`"" -Verb RunAs
}

function Main
{
    if (-not (IsAdmin))
    {
        RunAsAdmin -File $PSCommandPath
        exit
    }

    $ScriptDir = "${PSScriptRoot}\script"
    $ConfigDir = "${PSScriptRoot}\config"

    . ${ScriptDir}\choco.ps1 -Config ${ConfigDir}\choco.config
    . ${ScriptDir}\winget.ps1 -File ${ConfigDir}\winget_dependencies.txt

    # End
    Read-Host "Press enter key..."
    exit
}

Main
