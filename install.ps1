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

$ScriptDir = "${PSScriptRoot}\script"
$ConfigDir = "${PSScriptRoot}\config"

. ${ScriptDir}\choco.ps1 -Config ${ConfigDir}\choco.config
. ${ScriptDir}\winget.ps1 -File ${ConfigDir}\winget_dependencies.txt

# End
Read-Host "Press enter key..."
