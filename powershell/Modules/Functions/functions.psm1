# Bash, I just can't quit you
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }
function less() { Get-Content $args }
function env {	Get-ChildItem -Path Env: }
# ls is an alias to Get-ChildItem but does not support -la out of the box. make it so
function ls { Get-ChildItem -Force }
function sudo() {
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

# function Run-AsAdmin($command) {
# 	# https://stackoverflow.com/questions/66362383/how-do-i-run-a-powershell-script-as-administrator-using-a-shortcut

# 	Start-Process PowerShell -Verb RunAs -Wait -ArgumentList "-NoExit -Wait -noProfile -Command $command"

# 	# powershell.exe -NoExit -Command "& {$wd = Get-Location; Start-Process powershell.exe -Verb RunAs -ArgumentList \"-ExecutionPolicy ByPass -NoExit -Command Set-Location $wd; C:\project\test.ps1\"}"
# }

# TODO: fix this -- i think quotes are messing it up?
function giff() {

	$Params = $null

	foreach ($arg in $args) {
		# Write-Host $item
		# Write-Host "$($Params) $($item)"
		Switch ($arg) {
			"ns" {
				$Params = "$($Params) --name-status"
			}
			"hh" {
				$Params = "$($Params) HEAD~..HEAD"
			}
			"mh" {
				$Params = "$($Params) main..HEAD"
			}
			"mah" {
				$Params = "$($Params) master..HEAD"
			}
			default {
				# pass anything else literally
				$Params = "$($Params) $($arg)"
			}
		}
	}

	Write-Host "git params are `"$Params`""

	cmd /c echo $Params
	# git diff $Params
	git diff -B -w "$Params"
	# git diff "$($Params)"

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
