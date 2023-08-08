# Bash, I just can't quit you
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }
function less { Get-Content $args }
function env {	Get-ChildItem -Path Env: }
# ls is an alias to Get-ChildItem but does not support -la out of the box. make it so
function ls { Get-ChildItem -Force }
function sudo {
	Start-Process PowerShell -Verb RunAs -Wait -ArgumentList "-NoExit -noProfile -Command $args"
}

# Teleportation
function cpf {
	Set-Location $env:ProgramFiles
}
function ccode {
	Set-Location $HOME\code
}
function cnotes {
	Set-Location $HOME\notes
}
function cconfig {
	Set-Location $HOME\config
}
function cerp {
	Set-Location $HOME\code\erp
}

# Reloading Stuff and Module Management
function modls {
	get-module
}
function modla {
	get-module -listavailable
}
function modr {
	Import-Module Functions -Force
}
function prof {
	. $PROFILE
}

# function Run-AsAdmin($command) {
# 	# https://stackoverflow.com/questions/66362383/how-do-i-run-a-powershell-script-as-administrator-using-a-shortcut

# 	Start-Process PowerShell -Verb RunAs -Wait -ArgumentList "-NoExit -Wait -noProfile -Command $command"

# 	# powershell.exe -NoExit -Command "& {$wd = Get-Location; Start-Process powershell.exe -Verb RunAs -ArgumentList \"-ExecutionPolicy ByPass -NoExit -Command Set-Location $wd; C:\project\test.ps1\"}"
# }

function giff() {

	$Params = @()

	foreach ($arg in $args) {
		Switch ($arg) {
			"ns" {
				$Params += "--name-status"
			}
			"hh" {
				$Params += "HEAD~..HEAD"
			}
			"mh" {
				$Params += "main..HEAD"
			}
			"mah" {
				$Params += "master..HEAD"
			}
			default {
				# pass anything else literally
				$Params += $arg
			}
		}
	}

	& git diff -B -w $Params

}

function whichDotnet {

	Write-Host "`nNET Runtimes:"
	Write-Host ">>--------------------->"
	dotnet --list-runtimes

	Write-Host "`nNET SDKs:"
	Write-Host ">>--------------------->"
	dotnet --list-sdks

	Write-Host "`nNET SDK Check:"
	Write-Host ">>--------------------->"
	dotnet sdk check

	Write-Host "`nNET Framework:"
	Write-Host ">>--------------------->"
	Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where-Object { $_.PSChildName -Match '^(?!S)\p{L}' } | Select-Object PSChildName, version

}
