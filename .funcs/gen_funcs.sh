
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
#         xterm -bg ${BG4} -e bash -c "exec bash" -hold &
#     else
#         for p in "$@"
#         do
#             xterm -e bash -c "$p; exec bash" -hold &
#         done
#     fi
# #    xterm -geometry 80x50+50+0 -e bash -c "exec bash" -hold &  #-- make pop open quarter-screen sized -- doesn't work
# }

# # LOOK THROUGH MANY TYPES OF FILES FOR A CASE-INSENSITIVE REGEX
# function ssome()
# {
#     if [ $# -gt 0 ] ; then
#         find . -name "*.txt" | xargs grep -n --color -i "$@"
#         find . -name "*.doc" | xargs grep -n --color -i "$@"
#         find . -name "*.docx" | xargs grep -n --color -i "$@"
#         find . -name "*.dat" | xargs grep -n --color -i "$@"
#         find . -name "*.pls" | xargs grep -n --color -i "$@"
#         find . -name "*.pg" | xargs grep -n --color -i "$@"
#     fi
# }

alias diws='ignore_ws_comments'
function ignore_ws_comments()
{
    local CHAR="//"
    local FILES
    local MODE="normal"

    function display_help
    {
        echo "Diffs two files while ignoring whitespace and newlines."
        echo "Also ignores commented lines. Default comment character is \"//\""
        echo "Specify a different comment character with: "
        echo "     $ ignore_ws_comments -c \# foo bar"
    }

    function print_files
    {
        echo "File size is: ${#}"
        for FILE in ${@}
        do
            echo ${FILE}
        done
    }

    if [ "${#}" == 0 ] ; then
        MODE="help"
        display_help
    else
        while  [ "${#}" != 0 ]
        do
            case "${1}" in
                  -c | --character)
                      CHAR="${2}"   # You may want to check validity of $2
                      echo CHAR is ${CHAR}
                      shift 2
                      ;;
                  -h | --help)
                      display_help
                      MODE="help"
                      break
                      ;;
                  -*)
                      echo "Error: Unknown option: $1"
                      display_help
                      MODE="help"
                      break
                      ;;
                  *)
                      FILES+=(${1})
                      shift
                      ;;
            esac
        done
    fi

    # echo "MODE is ${MODE}, CHAR is ${CHAR} and files are:"
    # print_files "${FILES[@]}"

    if [ ${MODE} == "normal" ] ; then
        if [ ${#FILES[@]} == 2 ] ; then
            echo "--------------------------------------------------------"
            # grep each file for non-matching lines (-v) against regular expression
            # ^\s*(${CHAR}|$) ("match comment char and empty lines")
            # show exended expressions (E)
            # 'command' removes my aliased -I option
            diff -Bw <(command grep -vE "^\s*(${CHAR}|$)" "${FILES[0]}")  <(command grep -vE "^\s*(${CHAR}|$)" "${FILES[1]}")
        else
            echo "Please enter two files (we have ${#FILES[@]} files)"
        fi
    fi
}

# LOOK THROUGH ALL TEXT FILES FOR A CASE-INSENSITIVE REGEX
function stxt()
{
    if [ $# -gt 0 ] ; then
        find . -name "*.txt" | xargs grep -n --color -i "$@"
        find . -name "*.doc" | xargs grep -n --color -i "$@"
        find . -name "*.docx" | xargs grep -n --color -i "$@"
        find . -name "*.md" | xargs grep -n --color -i "$@"
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

# function cdd()
# {
#     STR='cd ..'
#     i=1
#
#     while [ "$i" -lt "$1" ]
#     do
#         STR="${STR}/.."
#         let "i+=1"
#     done
#
#     $STR
#
#     unset STR i
# }


#####nawwwww just use $ sed 's/foo/bar/' input.txt > output.txt
# # STRIP EXPRESSIONS FROM A FILE
# function strip_file()
# {
#     FILE=$1

#     if [[ -f "$FILE" ]] ; then


#         #if [ $# -gt 1 ] ; then
#         if [ $# -gt 0 ] ; then

#             while read LINE ; do

#                 echo "removing from: ${LINE}"

#                 STR=sed



#                 # for p in "$@"
#                 # do

#                 # done


#             done <"${FILE}"

#         else
#             echo "Enter some text to remove from ${FILE}"
#         fi

#     else
#         echo "File ${FILE} does not exist"
#     fi

#     ###unset FILE

# }
