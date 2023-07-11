function Install-OhMyPosh {
	Write-Host "Installing Oh My Posh..." -ForegroundColor "Magenta"

	if (Get-Command "oh-my-posh" -ErrorAction SilentlyContinue) {
		Write-Host "Oh My Posh is already installed, updating Oh My Posh" -ForegroundColor "Green"
		winget upgrade JanDeDobbeleer.OhMyPosh -s winget
		return
	}

	winget install JanDeDobbeleer.OhMyPosh -s winget
	Write-Host "Oh My Posh Installed" -ForegroundColor "Green"
}
