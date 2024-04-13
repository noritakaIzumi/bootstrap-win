function Log($message)
{
    Write-Output "`n${message}`n"
}

function SuAdmin()
{
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators"))
    {
        Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

SuAdmin

. ${PSScriptRoot}\scripts\choco.ps1 -Config ${PSScriptRoot}\choco.config
. ${PSScriptRoot}\scripts\winget.ps1 -File ${PSScriptRoot}\winget_dependencies.txt

# End
Read-Host "Press enter key..."
