#!/bin/bash

# UPDATE MASTER AND CURRENT FEATURE BRANCH AND ROLL ALL RELEVANT PACKAGES
echo ">> UPDATING DEV"
cd ~/dev/

TRUNK=master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH_DIRTY=$(git status --porcelain)
OLD_HASH
MSUCCESS=0
BSUCCESS=0

if [ "$BRANCH_DIRTY" ] ; then
    echo ">> $BRANCH is dirty ಠ_ಠ"
    echo ">> Stash or commit before pulling."
else
    if [ $BRANCH == $TRUNK ] ; then
        OLD_HASH=$(git rev-parse $TRUNK)
        git pull

        echo ">> Rolling changes to master since $OLD_HASH"
        parse_rcp_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
        MSUCCESS=$?
        BSUCCESS=1
        # RESULT=$(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
    else
        git co $TRUNK

        TRUNK_DIRTY=$(git status --porcelain)

        if [ "$TRUNK_DIRTY" ]; then
            echo ">> $TRUNK is dirty ಠ_ಠ"
            echo ">> Stash or commit before pulling."
        else
            OLD_HASH=$(git rev-parse $TRUNK)
            git pull

            echo ">> Rolling changes to master since $OLD_HASH"
            parse_rcp_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
            MSUCCESS=$?

            git co ${BRANCH}
            OLD_HASH=$(git merge-base $BRANCH $TRUNK)
            echo ">> 10x sleeping (∪｡∪)｡｡｡zzz"
            sleep 10
            git rebase master

            echo ">> Rolling changes to ${BRANCH} since ${OLD_HASH}"
            parse_rcp_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
            BSUCCESS=$?
        fi
    fi
fi
cd -

echo "Branch Success: $BSUCCESS and Master Success: $MSUCCESS"

if [[ $BSUCCESS -eq 1 && $MSUCCESS -eq 1 ]] ; then
    return 1
else
    return 0
fi
