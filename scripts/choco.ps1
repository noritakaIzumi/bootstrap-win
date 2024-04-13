param($Config)

# Install chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue))
{
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco install "${Config}" -y
