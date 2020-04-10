#!/bin/bash

#======================================================================================================
# A generic script to update any ol' git branch that uses dev as the primary development branch
#======================================================================================================

###### TO DO
# - add arg for opening project (code vs exp *.sln)
# - add arg for alternate branch?


# OPEN_PROJECT=$2
STASH_RES=""
SKIP_APPLY=
REB_RES=""
APPLY_RES=""

echo "---> UPDATING DEV"

STASH_RES=$(git stash -u)
git checkout dev && git pull && git co -

if [[ $STASH_RES =~ "No local changes to save" ]] ; then
    SKIP_APPLY=1
fi

# Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
REB_RES=$(git rebase dev)
echo "===== REBASE RES IS"
echo "$REB_RES"

# if rebase was not successful, rewind
if [[ $REB_RES =~ "Patch failed" ]] || [[ $REB_RES =~ "Failed to merge" ]] ; then
    echo "!!! REBASE FAILED"
    echo " >>> Resolve conflict manually and then pop your stash"
else
    if [[ ! $SKIP_APPLY ]] ; then
        APPLY_RES=$(git stash apply)

        # if stash could not be applied, reset and warn that changes are still in stash
        if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
            echo "!!! STASH APPLY CONFLICT"
            echo "$APPLY_RES"
            echo " >>> Resolve conflict manually and then drop your stash"
            git reset --hard
        else
            git stash drop
        fi
    fi
fi

# if [[ $OPEN_PROJECT == 1 ]] ; then
#     code .
# elif [[ $OPEN_PROJECT == 2 ]] ; then 
#     explorer.exe *.sln
# fi
