# Install chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue))
{
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

## Su admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators"))
{
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Install dependencies via choco
$config_path = (Get-Item $PSCommandPath).DirectoryName + '\choco.config'
cinst $config_path -y

Read-Host "Press enter key..."
