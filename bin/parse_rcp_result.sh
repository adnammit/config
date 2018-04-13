#!/bin/bash

SUCCESS=0
RESULT="${1}"

TMP=$(echo $RESULT | head -n1 | sed -e 's/ *\([a-zA-Z]*\).*/\1/')

if [ "$TMP" == "Error" ] ; then
    echo "$RESULT"
    echo "Unsuccessful update ಠ╭╮ಠ"
elif [ "$TMP" == "none" ] ; then
    SUCCESS=1
    echo "$RESULT"
    echo "Nothing to roll out ¯\_(ツ)_/¯"
else
    SUCCESS=1
    echo "$RESULT"
    echo "Successful update! ~(˘▾˘~)"
fi

echo $SUCCESS
# return $SUCCESS
