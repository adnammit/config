# Run as admin

# TODO execute bash/teardown.sh

function RemoveSymlink ([string]$path) {
	if (-Not(Test-Path $path)) {
		Write-Host "Could not remove link, $path does not exist" -ForegroundColor Yellow
		return
	}

	if (-Not((Get-Item $path).LinkType -eq "SymbolicLink")) {
		Write-Host "Could not remove link, $path is not a symlink" -ForegroundColor Magenta
		return
	}

	Remove-Item -Path $path -Force
}

$PowershellDestPath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) \PowerShell
$PowershellModulesPath = Join-Path $PowershellDestPath \Modules

# Remove Global Symlinks
RemoveSymlink $Home\.gitconfig

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
