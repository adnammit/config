

# POP OPEN A NEW SHELL WINDOW
function pop() 
{
    a='Using "$@" string: '
    if [ $# == 0 ]; then
	xterm -bg ${BG4} -e bash -c "exec bash" -hold &
    else
	for p in "$@"
	do
	    xterm -e bash -c "$p; exec bash" -hold &
	done
    fi
#    xterm -geometry 80x50+50+0 -e bash -c "exec bash" -hold &  #-- make pop open quarter-screen sized -- doesn't work
}

# RUN RUPDATE AND OPEN SUPPORT DOCS
function hi()
{
    a=$PWD
    xterm -bg ${BG3} -e bash -c "cd ~/dev; rupdate -r; exec bash" -hold &
    cd ~/docs
    emacs *.txt &
    cd $a
}

# RUPDATE ALL OF /DAT RECURSIVELY
function rup()
{
    a=$PWD
    cd ~/dev/dat
    rupdate -r
    cd $a
}

# LOOK THROUGH ALL .DAT FILES FOR A CASE-INSENSITIVE REGEX
function sdat()
{
    if [ $# -gt 0 ] ; then
	
        find .  -name "*.dat" | xargs grep -n --color -i "$@"
    fi
}

# LOOK THROUGH ALL .DAT FILES FOR A CASE-SENSITIVE REGEX
function Sdat()
{
    if [ $# -gt 0 ] ; then
	
        find . -name "*.dat" | xargs grep -n --color "$@"
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

    for p in "$@";
    do
	inc_version $p
	roll_out $p DEV -t amanda
    done

    cd $a
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
}

# SYNC CONFIG FILES WITH //DEV-LNX
function sync_config()
{
    a=$PWD
    cd
    cp -r config/. ryman.amanda/config/
    cd $a
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
}
