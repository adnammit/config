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

    if [ "${WORK_ENV}" ] ; then

        PATH="$PATH:/c/UserData/ryman.amanda/dev/build/"
        PATH="$PATH:/c/UserData/ryman.amanda/atom/bin"
        # PATH="$PATH:~/AppData/Local/atom/bin"
    else

        WINDOWS="/cygdrive/c/"
        PROGRAM_FILES="${WINDOWS}Program Files/"
        TARDIGRADE="${WINDOWS}Users/tardigrade/"
        APP_DATA="${TARDIGRADE}AppData/"
        ATOM="${APP_DATA}Local/atom/bin"
        SYSTEM="${WINDOWS}Windows/System32/"
        NODE="${PROGRAM_FILES}nodejs/:${APP_DATA}Roaming/npm/"

        PATH="$PATH:${ATOM}:${NODE}:${SYSTEM}"
        ###i don't think you need tardigrade...
        # PATH="$PATH:${TARDIGRADE}:${ATOM}:${NODE}"
        # PATH="$PATH/usr/lib/postgresql/9.3/bin"

        unset WINDOWS PROGRAM_FILES TARDIGRADE APP_DATA ATOM SYSTEM NODE
    fi
fi

export PATH
export TMPDIR

#=========================================
# SET TELEPORTATION VARIABLES
#=========================================

if [ "${WORK_ENV}" ] ; then

    MASTER='alr/'
    F1='alr-f1/'
    F2='alr-f2/'
    F3='alr-f3/'
    F4='alr-f4/'
    F5='alr-f5/'
    CLIENT='__client__/'

    if [[ "$OSTYPE" == "cygwin" ]]; then
        DEV='//dev-lnx/sites/dev.perflogic.com/'
        TEST='//dev-lnx/sites/test.perflogic.com/'
        STAGE='//dev-lnx/sites/stage.perflogic.com/'
        REPO='//dev-lnx/repo_sites/'
        RLOG='//dev-lnx/home/ryman.amanda/repo_logs/'
        LOCAL_REP='/c/UserData/ryman.amanda/'
    elif [[ "$OSTYPE" == "linux-gnu" ]]; then
        DEV='/var/www/sites/dev.perflogic.com/'
        TEST='/var/www/sites/test.perflogic.com/'
        STAGE='/var/www/sites/stage.perflogic.com/'
        REPO='/var/www/repo_sites/'
        RLOG='/var/www/repo_logs/'
    fi

    PROC='__app__/proc/'
    CAB='__web__/subscriber/plugin/'
    LOG='__log__/'
    FORMS='__web__/forms/'
    LIB='__lib__/dat/'

fi
