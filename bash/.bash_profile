# .bash_profile
# Load .profile and .bashrc if they exist. That's all, folks!

if [ -f ~/.work_env ] ; then
    WORK_ENV=1
fi

if [ -f ~/.profile ]; then
    . ~/.profile
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
