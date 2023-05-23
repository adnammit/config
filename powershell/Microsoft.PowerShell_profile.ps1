$ps_script_dir = "$HOME\Documents\PowerShell\Scripts"
Set-Alias bso $ps_script_dir\BuildSOandNotify.ps1
Set-Alias papercut "C:\Program Files (x86)\Changemaker Studios\Papercut SMTP\Papercut.Service.exe"
Set-Alias showEnv "Get-ChildItem -Path Env:"


function GetDotnetInfo {

	Write-Host ">>NET Runtimes:"
	dotnet --list-runtimes

	Write-Host ">>list NET SDKs:"
	dotnet --list-runtimes

	Write-Host ">>check NET SDKs:"
	dotnet sdk check

	Write-Host ">>NET Framework:"
	Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}' } | Select-Object PSChildName, version
}

Set-Alias which-dotnet GetDotnetInfo

# OH MY POSHNESS
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/montys.omp.json' | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

# TODO make this foreach subdir in Tools
$env:PATH += ";C:\Tools\azcopy_windows_amd64_10.18.0\"
$env:PATH += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"
