#!/bin/bash
# Because my jerb has a bunch of custom async git stuff that derails
#   cherry-picking by range, here is a script to cherry pick one commit
#   at a time.

if [[ $# == 2 ]] ; then
    START=$1
    NUM_COMMITS=$2
else
    HELP_FLAG=1
fi

if [[ $HELP_FLAG == 1 ]] ; then
    echo ""
    echo "Requires two args:"
    echo "1: the most recent commit in the range you'd like cherry picked"
    echo "2: the total number of commits you'd like picked (including the most recent commit)"
    echo ""
    echo "Remember: check twice, run once, reflog if you done fucked it up anyway."
    echo ""
else

    if [[ $START != "" ]] ; then
        while [[ NUM_COMMITS -gt 0 ]] ; do
            ((NUM_COMMITS--))
            HASH=$(git rev-parse $START~$NUM_COMMITS)
            HASHES=$HASHES$HASH" "
        done
    fi

    for HASH in $HASHES
    do
        echo ">> cherry-picking "$HASH
        git cherry-pick $HASH
    done

fi
