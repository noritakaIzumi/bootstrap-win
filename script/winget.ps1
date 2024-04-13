param($File)

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
