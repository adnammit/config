# .profile
# Put environment variables and other non-bash variables here.
# If you had any .profile.d/ scripts to run, you'd do that here as well.

HISTTIMEFORMAT="%F %T "
export HISTTIMEFORMAT
HISTFILESIZE=1000000
HISTSIZE=1000000
# immediately log commands to history so they're recorded in case of a crash:
PROMPT_COMMAND='history -a'

#=========================================
# KNOW YR PATHWAYS
#=========================================

# FOR ALL ENVS:
STANDARD_PKGS="${OSTYPE%%[-0-9]*} user shell term man options"
BASE_PATH="/usr/bin:/bin" # same as default $PATH
LOCAL_PATH="/usr/local/bin"
TEMP_VARS="TEMP_VARS STANDARD_PKGS BASE_PATH LOCAL_PATH"

for PKG in $STANDARD_PKGS ; do
    if [ -r "/etc/profile.d/$PKG.sh" ] ; then
        . "/etc/profile.d/$PKG.sh"
    fi
    if [ -r "$HOME/.profile.d/$PKG.sh" ] ; then
    	. "$HOME/.profile.d/$PKG.sh"
    fi
done

PATH="$LOCAL_PATH:$BASE_PATH:$HOME/bin"

unset $TEMP_VARS

TMPDIR="/tmp/"

# SPECIFIC ENVS:
if [[ "$OSTYPE" =~ "darwin" ]]; then
    export HOMEBREW_GITHUB_API_TOKEN="10033859e446c1f9ebcc3d74e4334b78eda7ca88"
    export ANDROID_HOME=/user/local/opt/android-sdk
    export CLICOLOR=1

    #screen helping:
    case $TERM in
	screen*)
	    SCREENTITLE='\[\ek\e\\\]\[\ek\W\e\\\]'
	    ;;
	*)
	    SCREENTITLE=''
	    ;;
    esac

elif [[ "$OSTYPE" == "cygwin" ]]; then

    SYSTEM="$SYSTEMROOT/System32/"
    GIT="/cygdrive/c/Program Files/Git/bin/"
    NODE="/cygdrive/c/Program Files/nodejs/:/cygdrive/c/Program Files/nodejs/node_modules/:$APPDATA/npm/"
    NVM="$APPDATA/nvm/"
    POSTGRES="$PROGRAMFILES/PostgreSQL/pg10/bin/"
    DOTNET="$PROGRAMFILES/dotnet/"
    SQLSERVE="/cygdrive/c/Program Files (x86)/Microsoft SQL Server/140/DAC/bin/"
    VSBIN="$SYSTEMROOT/Microsoft.NET/Framework/v2.0.50727/"
    MSBUILD="$SYSTEMROOT/Microsoft.NET/Framework/v4.0.30319/"
    DOCKER="$PROGRAMFILES/Docker/Docker/resources/bin/"
    HEROKU="/cygdrive/c/Program Files/heroku/bin/"

    if [ "${WORK_ENV}" ] ; then
        CODE="/cygdrive/c/Program Files/Microsoft VS Code/bin"
    else
        CODE="/cygdrive/c/Users/tardigrade/AppData/Local/Programs/Microsoft Vs Code/bin"
    fi

    PATH="$PATH:$SYSTEMROOT:$SYSTEM:$GIT:$NODE:$NVM:$POSTGRES:$DOTNET:$VSBIN:$MSBUILD:$SQLSERVE:$CODE:$DOCKER"
    unset SYSTEM GIT NODE NVM POSTGRES DOTNET VSBIN MSBUILD SQLSERVE VSIDE CODE DOCKER

    PATH="$PATH:$SYSTEMROOT:$SYSTEM:$GIT:$NODE:$NVM:$POSTGRES:$DOTNET:$VSBIN:$MSBUILD:$SQLSERVE:$CODE:$DOCKER:$HEROKU"
    unset SYSTEM GIT NODE NVM POSTGRES DOTNET VSBIN MSBUILD SQLSERVE VSIDE CODE DOCKER HEROKU

fi

export PATH
export TMPDIR
