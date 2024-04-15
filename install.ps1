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
