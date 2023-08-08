function Test-Chocolatey {
	if (Get-Command "choco" -ErrorAction SilentlyContinue) {
		return $true
	}
	return $false
}

function Install-Chocolatey {
	Write-Host "Installing Chocolatey..." -ForegroundColor "Magenta"

	if (Get-Command "choco" -ErrorAction SilentlyContinue) {
		Write-Host "Chocolately is already installed" -ForegroundColor "Green"
		return
	}

	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
	Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	# iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

	Write-Host "Chocolatey Installed" -ForegroundColor "Green"
}
