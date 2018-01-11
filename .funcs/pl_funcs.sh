
#=========================================
# FUN WITH FUNCTIONS
#
# These functions are aliased here rather
#  than in the .aliases dir
#=========================================

function mnt()
{
    #mintty -t hello -e /bin/bash - &
    mintty -i /Cygwin-Terminal.ico - &
}

# GET ALL OUR MINTTY WINDOWS SET UP
function hello()
{
    a=$PWD
    #mintty -ha -t sidecar bash &
    mintty -i /Cygwin-Terminal.ico - &

    i=0
    while [ "$i" -lt 3 ]
    do
    	ssh_devlnx
    	let "i+=1"
    done

    ### TO DO
    ### - place windows on screen
    ### - sync_config
    ### - backup thing like denny does

    unset a
}

function ssh_devlnx()
{
    mintty -t dev-lnx -e /bin/bash -c 'read -pusername\($USERNAME\):\  SSHUSER; export DISPLAY=:$((UID%10000)).0; exec /usr/bin/ssh -XY ${SSHUSER:-$USERNAME}@dev-lnx.portland.perflogic.com' -hold &
}

# #roll out packages on roll branch
# alias ro='roll_to_roll'
# function roll_to_roll()
# {
#     if [ ${#} -gt 0 ]; then
#         a=$PWD
#         cd ~/dev
#         CURR_REPO=`git symbolic-ref --short HEAD`
#         git co roll
#         roll_out "$@"
#         git co ${CURR_REPO}
#         cd $a
#         unset a CURR_REPO
#     else
#         echo gimme some packages to roll, yo
#     fi
# }

# LOOK THROUGH TXT FILES IN DOCS
function sdocs()
{
    if [ $# -gt 0 ] ; then
	cd ~/docs
        stxt $@
        #find . -name "*.txt" | xargs grep -n --color -i "$@"
	cd -
    fi
}

# LOOK THROUGH ALL .DAT FILES FOR A CASE-INSENSITIVE REGEX
function sdat()
{
    if [ $# -gt 0 ] ; then
	#grep -ni --color "$@" *.dat
        find .  -name "*.dat" | xargs grep -n --color -i "$@"
    fi
}

# LOOK THROUGH ALL .DAT FILES FOR A CASE-SENSITIVE REGEX
function Sdat()
{
    if [ $# -gt 0 ] ; then
	#grep -n --color "$@" *.dat
        find . -name "*.dat" | xargs grep -n --color "$@"
    fi
}

# LOOK THROUGH LOG FILES
function sapp()
{
    if [ $# -gt 0 ] ; then
	grep -ln --color "$@" *app_log
    fi
}

# SYNC CONFIG FILES WITH //DEV-LNX
function sync_config()
{
    DST_BASE="//dev-lnx/home/ryman.amanda/"
    DST_DIR="config"
    FILES=".aliases .bash_profile .bashrc bin .emacs .emacs.d .funcs .profile .xemacs"

    a=$PWD
    cd ${DST_BASE}
    if [ ! -e ${DST_DIR} ]; then
        echo "making ${DST_DIR}"
        mkdir ${DST_DIR}
    else
        echo "already have ${DST_DIR}"
    fi

    DST_PATH=${DST_BASE}${DST_DIR}"/"

    echo "using ${DST_PATH}"

    cd ~/config

    for FILE in $FILES
    do
        echo "syncing file $FILE"
        if [ -d $FILE ]; then
            cp -r $FILE $DST_PATH
        elif [ -f $FILE ]; then
            cp $FILE $DST_PATH
        fi
    done

    cd ${a}
    unset a FILE FILES DST_BASE DST_DIR DST_PATH
}
