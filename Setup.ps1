# Run as admin

# TODO execute bash/setup.sh

function CreateSymlink ([string]$source, [string]$dest) {
	if (-Not(Test-Path $dest)) {
		New-Item -ItemType SymbolicLink -Path $dest -Target $source
	}
	else {
		Write-Host "Could not create link, $dest already exists!" -ForegroundColor Magenta
	}
}

$SourcePath = $PWD.Path
$PowershellSourcePath = Join-Path $PWD.Path \powershell
$PowershellDestPath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) \PowerShell
$PowershellModulesPath = Join-Path $PowershellDestPath \Modules

# Symlink Global Stuff
CreateSymlink $SourcePath\global-gitconfig $Home\.gitconfig

# Symlink Modules
if (-Not(Test-Path $PowershellModulesPath)) {
	New-Item -ItemType Directory -Path $PowershellModulesPath
}

$Modules = Get-ChildItem $PowershellSourcePath\modules

foreach ($Module in $Modules) {
	$destModule = Join-Path $PowershellModulesPath $Module.Name
	CreateSymlink $Module.FullName $destModule
}
