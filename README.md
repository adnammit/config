# Config Your Way To A Happy Command Line Environment

## Assorted dotfiles including the following:
* scripts to set up command line environment
* my old bash config as well as some powershell which I'm slowly adopting
* vim config because even though I use VSCode now, I'm sentimental
* global `.gitconfig`
* step-by-step list and instructions for installing some apps and other dependencies like pwsh, choco, and git on a fresh OS install

## Config package does NOT include:
* `.ssh` and other private-y stuff

# Setup

## Part I: Applications and Packages
* step-by-step guide for how to set things up on a new machine
* maybe script this if it makes sense someday but it probably won't

### VSCode
* [install VSCode](https://code.visualstudio.com/download#)

### Powershell
* if you already have powershell 5, this will install powershell 7 (with pwsh) side-by-side
* [installing powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
* [powershell 5 vs 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.3#using-powershell-7-side-by-side-with-windows-powershell-51)
```pwsh
winget install --id Microsoft.PowerShell -s winget
```

### Oh My Posh!
* [reference](https://ohmyposh.dev/docs/installation/windows)
```pwsh
winget install JanDeDobbeleer.OhMyPosh -s winget
```

### Fonts
* **requires admin**
* fonts downloaded in this manner are available across the system like any other font
* once downloaded, settings in Powershell/Terminal must be updated to use the font
* [reference](https://www.nerdfonts.com/font-downloads)
* fonts I like, which have ligatures: jetbrainsmono, firacode, operatormono
```pwsh
oh-my-posh font install
```

### Chocolatey
* **requires admin**
* see `powershell/setup/Install-Choco.psm1`
```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Git
* **requires admin**
```pwsh
choco install git.install
```

### Posh-Git (optional)
* git add-on: provides git data in powershell prompt, and tab completion for git commands and remote names and branches
* [reference](https://github.com/dahlbyk/posh-git)
```pwsh
choco install poshgit
```

### Node Stuff™️
* **requires admin**
```pwsh
choco install nodejs.install
choco install yarn
```

* **TODO:** global install:
	* vue
	* vue cli
	* typescript -- eh, i think this should be installed locally

### LaTeX
* configure LaTeX development in VSCode
* [download texLive](https://www.tug.org/texlive/windows.html) **NOTE**: this takes a *very long* time
* install LaTeX Workshop VSCode extension
* configure your VSCode `settings.json`
* [reference](https://github.com/James-Yu/LaTeX-Workshop/wiki)

### Bonus Round I: More Dev Stuff
* Rider
* Docker
* SSMS
* pgadmin/postgres
* dotnet SDKs
* Postman
* LICEcap
* teensy
* [stackify prefix](https://stackify.com/prefix/)

### Bonus Round II: Even More Stuff
* PowerToys: includes a lot of neat stuff like FancyZones (install via MS app store)
* [Synergy](https://symless.com/synergy) -- or logitech flow, or mouse without borders
* Slack
* Signal
* f.lux
* Spotify
* Dropbox
* steam (look up what dirs to copy)
* some hardware monitor
* garmin express/basecamp?
* VLC
* NordVPN

## Part II: Customize Your Environment (the actual dotfiles part)
* run setup/clone_all_the_repos
* everything in `/config` needs to be in `$HOME` -- instead of manually copy/pasting them to `$HOME`, run the setup script:
	- run `./setup` to create symlinks to the actual version-controlled files here in the repo
	- run `./setup work` to set the work env flag and enable work paths/scripts
	- that's it!
* to remove run `./teardown`

## TODO
**START HERE**
	- copy basic bash functionality to pwsh
* maybe separate out the "how to set up a computer" part to another repo and keep the dotfiles pure
* keep working on powershell
	- copy bash functionality to pwsh
	- move powershell stuff to config repo -- rn your working copy of powershell stuff is here: C:\Users\pangolin\Documents\Powershell
	- [how to source functions](https://stackoverflow.com/a/6040725/7898566)
	- [do more with modules](https://learn.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7.3)
* combine these two into one:
	- clone_all_the_repos.sh
	- setup.sh
* convert `setup.sh` to `setup.bat`. yeah this is no longer OS-agnostic
* completely strip out old stuff
* bring in c/tools/ and other external powershell scripts or include them here if it makes sense
