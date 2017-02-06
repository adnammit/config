
#=========================================
# FUN WITH FUNCTIONS
#
# These functions are aliased here rather
#  than in the .aliases dir
#========================================= 


# MOVE THINGS TO TRASH!
function trash()
{
    mv $@ ~/.Trash
}

# # make a mac version of this:

# # pop open a separate shell window
# function pop() 
# {
#     a='Using "$@" string: '
#     if [ $# == 0 ]; then
# 	xterm -bg ${BG4} -e bash -c "exec bash" -hold &
#     else
# 	for p in "$@"
# 	do
# 	    xterm -e bash -c "$p; exec bash" -hold &
# 	done
#     fi
# #    xterm -geometry 80x50+50+0 -e bash -c "exec bash" -hold &  #-- make pop open quarter-screen sized -- doesn't work
# }

# LOOK THROUGH MANY TYPES OF FILES FOR A CASE-INSENSITIVE REGEX 
function ssome()
{
    if [ $# -gt 0 ] ; then 
	find . -name "*.txt" | xargs grep -n --color -i "$@"
	find . -name "*.doc" | xargs grep -n --color -i "$@"
	find . -name "*.docx" | xargs grep -n --color -i "$@"
	find . -name "*.dat" | xargs grep -n --color -i "$@"
	find . -name "*.pls" | xargs grep -n --color -i "$@"
	find . -name "*.pg" | xargs grep -n --color -i "$@"	
    fi
}

# LOOK THROUGH ALL TEXT FILES FOR A CASE-INSENSITIVE REGEX
function stxt()
{
    if [ $# -gt 0 ] ; then
        find . -name "*.txt" | xargs grep -n --color -i "$@"
        find . -name "*.doc" | xargs grep -n --color -i "$@"
        find . -name "*.docx" | xargs grep -n --color -i "$@"
    fi
}

# LOOK THROUGH ALL .H AND .CPP FILES FOR A CASE-INSENSITIVE REGEX
function sch()
{
    if [ $# -gt 0 ] ; then
        find . -name "*.h" | xargs grep -n --color -i "$@"
        find . -name "*.cpp" | xargs grep -n --color -i "$@"
    fi
}

# GREP FILES FOR UP TO 4 DIFFERENT EXPRESSIONS
function sall()
{
    echo "searching for $# strings in the same file"
    if [ $# -gt 0 ] ; then
	if [ $# == 1 ] ; then
	    grep -ril --color "$1"
	elif [ $# == 2 ] ; then
	    grep -ril --color "$1" | xargs grep -il --color "$2"
	elif [ $# == 3 ] ; then
	    grep -ril --color "$1" | xargs grep -il --color "$2" | xargs grep -il --color "$3"
	elif [ $# == 4 ] ; then
	    grep -ril --color "$1" | xargs grep -il --color "$2" | xargs grep -il --color "$3" | xargs grep -il --color "$4"
	fi
    fi
}

# MAKE A BACKUP FILE FOR ONE OR MORE FILES
function bak()
{
    if [ $# -gt 0 ] ; then
	for p in "$@"
	do
	    cp "$p" "$p".bak
	done	
    fi
}

function cdd()
{
    STR='cd ..'
    i=1

    while [ "$i" -lt "$1" ]
    do
	STR="${STR}/.."
	let "i+=1"
    done

    $STR
    
    unset STR
    unset i
}
