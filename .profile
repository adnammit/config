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
#STANDARD_PKGS="${OSTYPE%%[-0-9]*} user shell term lang man options" #for some reason, 'lang' throws cd error
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

TARDIGRADE="/mnt/c/Users/tardigrade/"

# PATH="$PATH://server/Users/shared/dev_tools:/c/UserData/ryman.amanda/dev/build/:~/AppData/Local/atom/bin:${TARDIGRADE}AppData/Local/atom"
PATH="$PATH:/c/UserData/ryman.amanda/dev/build/:~/AppData/Local/atom/bin:${TARDIGRADE}AppData/Local/atom"
#":/usr/lib/postgresql/9.3/bin"

unset $TEMP_VARS

TMPDIR="/tmp/"

# FOR PLAY PLAY:
if [[ "$OSTYPE" == "darwin15" ]]; then
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
fi

#export GIT_EDITOR=vim
export PATH
export TMPDIR

#=========================================
# SET TELEPORTATION VARIABLES
#=========================================

MASTER='alr'
F1='alr-f1'
F2='alr-f2'
F3='alr-f3'
F4='alr-f4'

if [[ "$OSTYPE" == "cygwin" ]]; then
    DEV='//dev-lnx/sites/dev.perflogic.com/'
    TEST='//dev-lnx/sites/test.perflogic.com/'
    STAGE='//dev-lnx/sites/stage.perflogic.com/'
    REPO='//dev-lnx/repo_sites/'
    RLOG='//dev-lnx/home/ryman.amanda/repo_logs/'
    LOCAL_REP='/c/UserData/ryman.amanda/'
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    DEV='/var/www/sites/dev.perflogic.com/'
    TEST='/var/www/sites/test.perflogic.com/'
    STAGE='/var/www/sites/stage.perflogic.com/'
    REPO='/var/www/repo_sites/'
    RLOG='/var/www/repo_logs/'
fi

if [[ "$OSTYPE" != "darwin15" ]]; then
    PROC='__app__/proc/'
    CAB='__web__/subscriber/plugin/'
    LOG='__log__/'
    FORMS='__web__/forms/'
    LIB='__lib__/dat/'
fi
