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
# TODO: make sure this works for windows too as opposed to above
# module location: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7.3#module-and-dsc-resource-locations-and-psmodulepath
if ($IsMacOS) {
	$PowershellModulesPath = Join-Path $Home \.local\share\powershell\Modules
}
else {
	$PowershellModulesPath = Join-Path $Home \Documents\PowerShell\Modules
}

# Symlink Global Stuff
CreateSymlink $SourcePath\global-gitconfig $Home\.gitconfig
CreateSymlink $PowershellSourcePath\Microsoft.PowerShell_profile.ps1 $profile.CurrentUserCurrentHost

# Symlink Modules
if (-Not(Test-Path $PowershellModulesPath)) {
	New-Item -ItemType Directory -Path $PowershellModulesPath
}

$Modules = Get-ChildItem $PowershellSourcePath\modules

foreach ($Module in $Modules) {
	$destModule = Join-Path $PowershellModulesPath $Module.Name
	CreateSymlink $Module.FullName $destModule
}
