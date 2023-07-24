# Config Your Way To A Happy Command Line Environment

## Assorted dotfiles including the following:
* scripts to set up command line environment
* my old bash config as well as some powershell which I'm slowly adopting
* vim config because even though I use VSCode now, I'm sentimental
* global `.gitconfig`
* step-by-step list and instructions for installing some apps and other dependencies you might want to have on a fresh OS install before you even configure your env, such as pwsh, choco/brew, and git

# Setup

## Part I: Applications and Packages
* step-by-step guide for how to set things up on a new machine
* maybe script this if it makes sense someday but it probably won't

### Terminal
* **Windows**: use Terminal
* **MacOS**: [install iTerm2](https://iterm2.com/)

### Package Manager
* **Windows**: install Chocolatey
	- **requires admin**
	- see `powershell/setup/Install-Choco.psm1`
	```pwsh
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	```
* **MacOS**: install [homebrew](https://brew.sh/)
	```pwsh
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```

### VSCode
* [install VSCode](https://code.visualstudio.com/download#)

### Powershell
* if you already have powershell 5, this will install powershell 7 (with pwsh) side-by-side
* [installing powershell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
* [powershell 5 vs 7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7?view=powershell-7.3#using-powershell-7-side-by-side-with-windows-powershell-51)
* **Windows**
	```pwsh
	winget install --id Microsoft.PowerShell -s winget
	```
* **MacOS**
	```pwsh
	brew install --cask powershell
	# update powershell
	brew update
	brew upgrade powershell --cask
	```

### Oh My Posh!
* [reference](https://ohmyposh.dev/docs/installation/windows)
* see `powershell/setup/Install-OhMyPosh.psm1`
* after installing, you will need to [modify your profile to use oh-my-posh](https://ohmyposh.dev/docs/installation/prompt)
* **Windows**
	```pwsh
	winget install JanDeDobbeleer.OhMyPosh -s winget
	```
* **MacOS**
	```pwsh
	brew install jandedobbeleer/oh-my-posh/oh-my-posh
	```

### Fonts
* [reference](https://www.nerdfonts.com/font-downloads)
* once downloaded, settings in the terminal must be updated to use the font
* fonts downloaded in this manner are available across the system like any other font
* ligatured fonts I like: jetbrainsmono, firacode, operatormono
* **Windows**
	- **requires admin**
	```pwsh
	oh-my-posh font install
	```
* **MacOS**
	```pwsh
	# tap the fonts repo; only do this once
	brew tap homebrew/cask-fonts
	# search for/view all fonts
	brew search nerd-font
	# install a font
	brew install --cask font-fira-code-nerd-font
	```

### Git
* **Windows**
	- **requires admin**
	```pwsh
	choco install git.install
	```
* **MacOS**
	- you likely already have git installed and just need to update. `brew install` will work either way: it will install if needed and update to latest
	```pwsh
	brew install git
	```

### Posh-Git
* [reference](https://github.om/dahlbyk/posh-git)
* git add-on: provides git data in powershell prompt and tab completion for git commands and remote names and branches
* install posh-git:
	```pwsh
	# install
	PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
	# update
	PowerShellGet\Update-Module posh-git
	```
* then add to profile:
	```
	Import-Module posh-git
	```

### Node Stuff™️
* use [nvm](https://github.com/nvm-sh/nvm) to install and manage npm/node
* **Windows**
	- **requires admin**
	- **TODO** use nvm again
	```pwsh
	choco install nodejs.install
	choco install yarn
	```
* **MacOS**
	- `nvm`: **DON'T** install via brew, use curl as specified in the documentation
	```pwsh
	# after nvm is installed, install latest LTS node:
	nvm install --lts
	```

### LaTeX
* configure LaTeX development in VSCode
* [download texLive](https://www.tug.org/texlive/windows.html) **NOTE**: this takes a *very long* time
* install LaTeX Workshop VSCode extension
* configure your VSCode `settings.json`
* [reference](https://github.com/James-Yu/LaTeX-Workshop/wiki)

### Bonus Round I: More Dev Stuff
* Rider
* Docker
* [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)/Azure Data Studio
* [Redgate Search for ADS](https://www.red-gate.com/products/sql-search/sql-search-for-azure-data-studio)
* Solarwinds Plan Explorer for SSMS or ADS equivalent?
* pgadmin/postgres
* [dotnet SDKs](https://dotnet.microsoft.com/en-us/download/dotnet)/[dotnet cli](https://learn.microsoft.com/en-us/dotnet/core/install/macos)
* Postman
* LICEcap
* teensy
* [stackify prefix](https://stackify.com/prefix/)

### Bonus Round II: Even More Not-So-Dev Stuff
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

### MacOS: Do How PC Do
* disable voiceover and other conflicting shortcuts in Settings > Keyboard > Accessibility/Applications
* Rectangle: aero snap behavior
	- **TODO** add shortcuts
* install [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
	```pwsh
	brew install --cask karabiner-elements
	```
* [altTab](https://alt-tab-macos.netlify.app/): in iOS, app switching is cmd-tab -- change it to the more comfortable alt-tab
* [Witch](https://manytricks.com/witch/): switch individual tabs
* set up Synergy modifier keys for mac client

![Synergy modifier keys](</img/Synergy MacOS Modifier keys.png>)

## Part II: Customize Your Environment (the actual dotfiles part)
* run setup/clone_all_the_repos
* everything in `/config` needs to be in `$HOME` -- instead of manually copy/pasting them to `$HOME`, run the setup script:
	- run `./setup` to create symlinks to the actual version-controlled files here in the repo
	- run `./setup work` to set the work env flag and enable work paths/scripts
	- that's it!
* to remove run `./teardown`

## TODO
* **version control/symlink your VS keybindings already**
* organize your setup scripts -- maybe call everything from `setup.ps1`, or make one "global setup" script
	- `clone_all_the_repos.sh`
	- `Setup.ps1` -- handles powershell and calls bash `setup.sh`
	- `bash/setup.sh`
* copy basic bash functionality to pwsh
* can i store [colors](https://i.stack.imgur.com/QOSgM.png) as variables? if not, go through and customize/make all colors consistent
* maybe separate out the "how to set up a computer" part to another repo and keep the dotfiles pure
* keep working on powershell
	- copy bash functionality to pwsh
	- [how to source functions](https://stackoverflow.com/a/6040725/7898566)
	- [do more with modules](https://learn.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7.3)
* bring in c/tools/ and other external powershell scripts or include them here if it makes sense
* global install:
	* vue
	* vue cli
