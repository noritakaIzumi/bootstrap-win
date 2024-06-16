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
