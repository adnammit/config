# .bash_profile
# Load .profile and .bashrc if they exist. That's all, folks!

if [ -f ~/.work_env ] ; then
    WORK_ENV=1
fi

if [ -f "$HOME/.profile" ]; then
. "$HOME/.profile"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi

    if [[ $OSTYPE =~ "darwin" ]] ; then
        if [ -f "$HOME/.bashrc.darwin" ]; then
            . "$HOME/.bashrc.darwin"
        fi
    fi
fi

