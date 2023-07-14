# Run as admin

# TODO execute bash/teardown.sh

function RemoveSymlink ([string]$path) {
	if (-Not(Test-Path $path)) {
		Write-Host "Could not remove link, $path does not exist" -ForegroundColor Yellow
		return
	}

	if (-Not((Get-Item $path -Force).LinkType -eq "SymbolicLink")) {
		Write-Host "Could not remove link, $path is not a symlink" -ForegroundColor Magenta
		return
	}

	Remove-Item -Path $path -Force
}

$PowershellDestPath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) \PowerShell
# TODO: make sure this works for windows too as opposed to above
# module location: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7.3#module-and-dsc-resource-locations-and-psmodulepath
if ($IsMacOS) {
	$PowershellModulesPath = Join-Path $Home \.local\share\powershell\Modules
}
else {
	$PowershellModulesPath = Join-Path $Home \Documents\PowerShell\Modules
}

# Remove Global Symlinks
RemoveSymlink $Home\.gitconfig
RemoveSymlink $profile.CurrentUserCurrentHost

# Remove Module Symlinks
if (-Not(Test-Path $PowershellModulesPath)) {
	Write-Host "No Module symlink cleanup to perform, \Modules does not exist" -ForegroundColor Yellow
}
else {
	$Modules = Get-ChildItem $PowershellModulesPath

	# TODO: foreach, or be explicit? this just removes symlinks so it's probably safe
	foreach ($Module in $Modules) {
		RemoveSymlink $Module.FullName
	}
}
