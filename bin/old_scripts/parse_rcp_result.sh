#!/bin/bash

#### HELPER FUNC FOR UPDATE FUNCS
#### roll_changed_pkgs --porcelain returns one of the following:
# * `Error: <error>` on errors with exit 1 status
# * `none`: if no packages are to be rolled
# * a list of packages readable by build/roll_out

SUCCESS=-1
RESULT="$@"
RESULT_STR=""

for RES in $RESULT
do
    if [[ $RES =~ [^\#*] ]] ; then
        RESULT_STR=$RESULT_STR$RES" "
    else
        break
    fi
done

# echo ">> RESULT_STR: $RESULT_STR"

TMP=$(echo $RESULT | head -n1 | sed -e 's/ *\([a-zA-Z]*\).*/\1/')

if [[ $TMP == "Error" ]] ; then
    echo "Unsuccessful update ಠ╭╮ಠ"
elif [[ $TMP == "none" ]] ; then
    SUCCESS=0
    echo "Nothing to roll out ¯\_(ツ)_/¯"
else
    SUCCESS=0
    echo ">> Successful update! ~(˘▾˘~)"
fi

# if [[ $SUCCESS == 1 ]] ; then
#     exit 0
# else
#
# fi
echo $SUCCESS
exit $?
