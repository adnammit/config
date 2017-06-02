
#=========================================
# FUN WITH FUNCTIONS
#
# These functions are aliased here rather
#  than in the .aliases dir
#========================================= 


# POP OPEN A NEW SHELL WINDOW. OPTIONAL: OPEN ONE WINDOW PER COMMAND STRING:
#    $ pop 'cd ../config' 'ls' 'cd ~/dev/dat; rupdate -r'
function pop() 
{
    a='Using "$@" string: '
    if [ $# == 0 ]; then
	xterm -bg ${BG4} -e bash -c "exec bash" -hold &
    else
	NUM=$1
	for p in "$@" 
	do

	    xterm -e bash -c "$p; exec bash" -hold &
	done

	# # you could also take the second arg as the # of windows to open:
	# NUM=$1
	# for j in `seq 1 ${NUM}`
	# do
	#     xterm -bg ${BG4} -e bash -c "exec bash" -hold &
	# done

    fi
    unset a NUM p
#    xterm -geometry 80x50+50+0 -e bash -c "exec bash" -hold &  #-- make pop open quarter-screen sized -- doesn't work
}

function mnt()
{
    mintty -t hello -e /bin/bash - &
}



# FOR MINTTY
# GET ALL OUR WINDOWS SET UP, RUPDATE AND CHECK FOR FILES WE NEED
function hello()
{
    a=$PWD
    mintty -t sidecar -e /bin/bash - &
    #mintty.exe -i /Cygwin-Terminal.ico - &
    #xterm -bg ${BG3} -e bash -c "cd ~/test; rupdate -r; cd ~/dev; rupdate -r; exec bash" -hold &

    i=0
    while [ "$i" -lt 3 ]
    do
    	ssh_devlnx
    	let "i+=1"
    done
    
    cd ~/docs
    emacs *.txt &
    check_files
    cd $a
    unset a
}



# FOR XTERM
# GET ALL OUR WINDOWS SET UP, RUPDATE AND CHECK FOR FILES WE NEED
function hi()
{
    a=$PWD
    xterm -bg ${BG3} -e bash -c "cd ~/test; rupdate -r; cd ~/dev; rupdate -r; exec bash" -hold &

    i=0
    while [ "$i" -lt 3 ]
    do
    	ssh_devlnx
    	let "i+=1"
    done
    
    cd ~/docs
    emacs *.txt &
    check_files
    cd $a
    unset a
}

# RUPDATE ALL OF /DAT RECURSIVELY
function rup()
{
    a=$PWD
    cd ~/dev/
    rupdate -r
    cd ~/test/
    rupdate -r
    cd $a
    unset a
}

function ssh_devlnx()
{
    mintty -t dev-lnx -e /bin/bash -c 'read -pusername\($USERNAME\):\  SSHUSER; export DISPLAY=:$((UID%10000)).0; exec /usr/bin/ssh -XY ${SSHUSER:-$USERNAME}@dev-lnx.portland.perflogic.com' -hold &
}

# Reads through a text document and checks to see if any files in the document are available to check out.
# If they're not, the RCS data is displayed.
function check_files()
{
    b=$PWD
    cd //dev-lnx/sites/dev.perflogic.com/__lib__/dat
    
    TARGET_FILE=~/docs/check_files.txt
    if [[ "$OSTYPE" == "darwin15" ]]; then
	SMILE="ʕ•ᴥ•ʔ"
	FROWN="ಠ_ಠ"
	SHRUG="¯\_(ツ)_/¯"
    else
	SMILE="^__^"
	FROWN="-__-"
	SHRUG="o__O"
    fi
    FILL=">  "

    echo "Let's find us some files to check out...."    
    
    while read FILE; do

	# check to see if the line is a comment or whitespace: 
	TMP=${FILE:0:2}
	
	if [ "${TMP}" != "//" ] && [ "${FILE}" != "" ]; then
	    
	    if [ -f ${FILE} ]; then

		RESULT=$(rlog -L -R ${FILE})

		if [[ -z "${RESULT// }" ]] ; then
		    echo "${FILL} ${SMILE} can haz ${FILE}" #echo "${FILL} [${FILE}] is available ${SMILE}"
		else
		    #rlog -N -h -l ${FILE}
		    echo "${FILL} ${FROWN} no can haz ${FILE}" #echo "${FILL} [${FILE}] is checked out by someone ${FROWN}"
		fi
	    else
		echo "${FILL} ${SHRUG} what can be ${FILE}" #echo "${FILL} [${FILE}] could not be found ${SHRUG}"

	    fi
	fi
	
    done <${TARGET_FILE}
    
    cd $b

    unset b TARGET_FILE SMILE FROWN SHRUG FILL FILE TMP RESULT
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

# INC, ROLL PACKAGES TO DEV
# to do: add bot, do in separate window
alias rod='roll_out_dev'
function roll_out_dev()
{
    a=$PWD
    cd ~/dev/build

    for p in "$@";
    do
	inc_version $p
	roll_out $p DEV 
    done

    cd $a

    unset a
}

# INC, ROLL PACKAGES TO TEST
alias rot='roll_out_test'
function roll_out_test()
{
    a=$PWD
    cd ~/dev/build

    for p in "$@";
    do
	inc_version $p
	roll_out $p TEST
    done

    cd $a
}

# ROLL PACKAGES TO DEV WITH MY TAG
alias rodme='roll_out_dev_me'
function roll_out_dev_me()
{
    a=$PWD
    cd ~/dev/build

    if [ "${1}" == "-n" ]; then
	NO_STRIP="--no-strip"
	DIR="${2}"
    else
	DIR="${1}"
    fi

    inc_version $DIR
    roll_out $DIR -t amanda $NO_STRIP

    ### Option for handling multiple packages:
    # for p in "$@";
    # do
    # 	inc_version $p
    # 	roll_out $p DEV -t amanda
    # done

    cd $a

    unset a NO_STRIP DIR
}

# ROLL PACKAGES TO TEST WITH MY TAG
alias rotme='roll_out_test_me'
function roll_out_test_me()
{
    a=$PWD
    cd ~/dev/build


    for p in "$@";
    do
	inc_version $p
	roll_out $p TEST -t amanda
    done

    cd $a
    unset a
}

# SYNC CONFIG FILES WITH //DEV-LNX
function sync_config()
{
    # to do: check for config/ dir and make if not there
    a=$PWD
    cd
    cp -r config/. ryman.amanda/config/
    cd $a
    unset a
}

# CHECK FOR MY LOCKS 
function slocks()
{
    rlocks -r | grep "ryman.amanda"
}

# CHECK FOR NEW FILES THAT AREN'T CHECKED IN
function snew()
{
    #    find . -user ryman.amanda -name '*.dat' -or -name '*.cpp' -or -name '*.h' -or -name '*.pls' | xargs ls -la --color=auto
    find . -perm /u+w -name '*.dat' -or -name '*.cpp' -or -name '*.h' | xargs ls -la --color=auto
}

# INC A PACKAGE (not super useful)
function inc()
{
    a=$PWD
    cd ~/dev/build
    inc_version $1
    cd $a
    unset a
}
