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

# Install chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue))
{
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

SuAdmin

# Install dependencies via choco
$config_path = (Get-Item $PSCommandPath).DirectoryName + '\choco.config'
choco install $config_path -y

. ${PSScriptRoot}\scripts\winget.ps1 -File ${PSScriptRoot}\winget_dependencies.txt

# End
Read-Host "Press enter key..."
