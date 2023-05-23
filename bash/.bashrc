
#==================================================================================
# BASHRC
#==================================================================================

if [ -f ~/.git-completion ]; then
    . ~/.git-completion
fi

bind -s 'set completion-ignore-case on'

#=========================================
# FUN WITH STYLING AND COLOR
#=========================================

BLACKONYELLOW='\[\e[43;30m\]'
BOLDBLUEONYELLOW='\[\e[43;34;1m\]'
BOLDBLUEONGREEN='\[\e[42;34;1m\]'
BLUEONYELLOW='\[\e[43;34m\]'
BOLDYELLOWONGREEN='\[\e[42;33;1m\]'
BOLDYELLOWONBLUE='\[\e[44;33;1m\]'
BOLDWHITEONGREEN='\[\e[42;37;1m\]'
BOLDPURPLEONGREEN='\[\e[42;35;1m\]'
BLUEONGREEN='\[\e[42;34m\]'
RED='\[\e[0;31m\]'
LRED='\[\e[1;31m\]'
GREEN='\[\e[0;32m\]'
PURPLE='\[\e[0;35m\]'
WHITE='\[\e[0;37m\]'
YELLOW='\[\e[0;33m\]'
LYELLOW='\[\033[1;33m\]'
CYAN='\[\033[0;36m\]'
LCYAN='\[\033[1;36m\]'
LBLUE='\[\033[1;34m\]'
BLUE='\[\033[0;34m\]'
MAGENTA='\[\e[0;95m\]'
LMAGENTA='\[\e[1;95m\]'
NC='\[\e[0m\]' #no color / reset to normal

C1=$LCYAN
C2=$LYELLOW
C3=$MAGENTA
export PS1="${C1}>>-${C2}[${C3}\w${C2}]${C1}-->${NC} "

BG1="#6d4856"
BG2="#42595e"
BG3="#636363"
BG4="#18253d"

#=========================================
# GET THE GOODIES
#=========================================

if [ -d ~/.aliases ]; then
    for FILE in ~/.aliases/*; do
        . "$FILE"
    done
fi
unset FILE

if [ -d ~/.funcs ]; then
    for FILE in ~/.funcs/*; do
	. "$FILE"
    done
fi
unset FILE

# Load nvm
export NVM_DIR="/home/tardigrade/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

shopt -s histverify
