#!/bin/bash
# Kind of like git blame, but for filenames rather than line numbers

FILES=$(find . -name "$@")

for FILE in $FILES
do
    HASH=$(git rev-list HEAD "$FILE" | tail -n 1)
    DATE=$(git show -s --format="%cd" --date=short $HASH --)
    AUTHOR=$(git --no-pager show -s --format='%an' $HASH)
    echo $(basename "$FILE")
    echo "> $AUTHOR, $DATE"
    echo ""
done
