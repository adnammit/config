# .bash_profile
# Load .profile and .bashrc if they exist. That's all, folks!

if [ -f ~/.profile ]; then
    . ~/.profile
fi

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi


