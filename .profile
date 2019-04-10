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
if [[ "$OSTYPE" == "darwin17" ]]; then
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

    ATOM="$LOCALAPPDATA/atom/bin/"
    SYSTEM="$SYSTEMROOT/System32/"
    NODE="/cygdrive/c/Program Files/nodejs/:/cygdrive/c/Program Files/nodejs/node_modules/:$APPDATA/npm/"
    # NODE="$PROGRAMFILES/nodejs/:$PROGRAMFILES/nodejs/node_modules:$APPDATA/npm/"
    NVM="$APPDATA/nvm/"
    # POSTGRES="/usr/local/pgsql/bin/"
    POSTGRES="$PROGRAMFILES/PostgreSQL/pg10/bin/"
    DOTNET="$PROGRAMFILES/dotnet/"
    VSBIN="$SYSTEMROOT/Microsoft.NET/Framework/v2.0.50727/"
     #wtf why do neither of these work? suspect it has something to do with spaces in the pathname
    # VSIDE="$SYSTEMDRIVE/Program Files (x86)/Microsoft Visual Studio/2017/Professional/Common7/IDE/"
    # CODE="$LOCALAPPDATA/Programs/Microsoft Vs Code/bin/"
    # VSIDE="/cygdrive/c/Program Files (x86)/Microsoft Visual Studio/2017/Professional/Common7/IDE/"
    CODE="/cygdrive/c/Users/amanda.ryman/AppData/Local/Programs/Microsoft Vs Code/bin"

    PATH="$PATH:$SYSTEMROOT:$ATOM:$SYSTEM:$NODE:$NVM:$POSTGRES:$DOTNET:$VSBIN:$VSIDE:$CODE"
    unset ATOM SYSTEM NODE NVM POSTGRES DOTNET VSBIN VSIDE CODE

fi

export PATH
export TMPDIR
