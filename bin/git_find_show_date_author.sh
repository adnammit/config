#!/bin/bash
# GIT_ROOT=$(git rev-parse --show-toplevel)
# FILES=$(find $GIT_ROOT -name "$@")
FILES=$(find . -name "$@")
# FILES=$(git ls-files "*/$@")

for FILE in $FILES
do
    HASH=$(git rev-list HEAD "$FILE" | tail -n 1)
    DATE=$(git show -s --format="%cd" --date=short $HASH --)
    AUTHOR=$(git --no-pager show -s --format='%an' $HASH)
    echo $(basename "$FILE")
    echo "> $AUTHOR, $DATE"
    echo ""
done
