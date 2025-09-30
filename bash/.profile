# Put environment variables and other non-bash variables here.
# If you had any .profile.d/ scripts to run, you'd do that here as well.

HISTTIMEFORMAT="%F %T "
export HISTTIMEFORMAT
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTCONTROL=ignoreboth
# immediately log commands to history so they're recorded in case of a crash:
PROMPT_COMMAND='history -a'
# append to the history file, don't overwrite it
shopt -s histappend

#=========================================
# KNOW YR PATHWAYS
#=========================================

STANDARD_PKGS="${OSTYPE%%[-0-9]*} user shell term man options"

for PKG in $STANDARD_PKGS ; do
	if [ -r "/etc/profile.d/$PKG.sh" ] ; then
		. "/etc/profile.d/$PKG.sh"
	fi
	if [ -r "$HOME/.profile.d/$PKG.sh" ] ; then
		. "$HOME/.profile.d/$PKG.sh"
	fi
done

## I don't think this block is necessary -- all the paths are already in $PATH
# echo "Path starts as $PATH"
# BASE_PATH="/usr/bin:/bin" # same as default $PATH
# LOCAL_PATH="/usr/local/bin"
# PATH="$PATH:$LOCAL_PATH:$BASE_PATH:$HOME/bin"

# TODO: wow this is awful, sort this out
if [[ $OSTYPE =~ "darwin" ]] ; then

	CYGDRIVE=""
	SYSTEM=""
	GIT=""
	POSTGRES=""
	DOTNET="/usr/local/share/dotnet/"
	SQLSERVE=""
	MSBUILD=""
	DOCKER=""
	INETSRV=""

	NODE=""
	CODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
	VSBIN=""

elif [[ $OSTYPE == "cygwin" ]] ; then

	CYGDRIVE="/cygdrive/c"
	SYSTEM="$SYSTEMROOT/System32/"
	GIT="$CYGDRIVE/Program Files/Git/bin/"
	POSTGRES="$PROGRAMFILES/PostgreSQL/16/bin/"
	DOTNET="$PROGRAMFILES/dotnet/"
	SQLSERVE="$CYGDRIVE/Program Files (x86)/Microsoft SQL Server/140/DAC/bin/"
	MSBUILD="$SYSTEMROOT/Microsoft.NET/Framework/v4.0.30319/"
	DOCKER="$PROGRAMFILES/Docker/Docker/resources/bin/"
	INETSRV="$SYSTEM/inetsrv/" #get appcmd.exe to manage iis stuff

	# default location:
	NODE=""
	# NODE="$CYGDRIVE/Program Files/nodejs/:$CYGDRIVE/Program Files/nodejs/node_modules/:$APPDATA/npm/"
	# but add in this custom location to avoid having to use admin for everything
	# NODE="$CYGDRIVE/Programs/nvm/:$CYGDRIVE/Programs/nodejs/"
	CODE="$LOCALAPPDATA/Programs/Microsoft Vs Code/"

	if [ "${WORK_ENV}" ] ; then
		VSBIN="$CYGDRIVE/Program Files/Microsoft Visual Studio/2022/Professional/Common7/IDE/"
	else
		VSBIN="$SYSTEMROOT/Microsoft.NET/Framework/v2.0.50727/"
	fi

	# load additional tools
	for d in $CYGDRIVE/tools/*/; do
		PATH="$PATH:$d"
	done

elif [[ $OSTYPE == "linux-gnu" ]] ; then
	DOTNET="/root/.dotnet/tools"
	CODE="/mnt/c/Users/pangolin/AppData/Local/Programs/Microsoft VS Code/bin"
fi

PATH="$PATH:$SYSTEMROOT:$SYSTEM:$GIT:$NODE:$POSTGRES:$DOTNET:$VSBIN:$MSBUILD:$SQLSERVE:$CODE:$DOCKER:$INETSRV"
unset SYSTEM GIT NODE POSTGRES DOTNET VSBIN MSBUILD SQLSERVE CODE DOCKER INETSRV

export PATH
