#!/bin/bash

# UPDATE MASTER, CURRENT FEATURE BRANCH AND ROLL ALL RELEVANT PACKAGES
echo ">> UPDATING DEV"
cd ~/dev/

TRUNK=master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH_DIRTY=$(git status --porcelain)

if [ ${BRANCH} == ${TRUNK} ] ; then
    if [ "${BRANCH_DIRTY}" ] ; then
        echo ">> ${TRUNK} is dirty ಠ_ಠ"
        echo ">> Stash or commit before pulling."
    else
        OLD_HASH=$(git rev-parse ${TRUNK})
        git pull
        echo ">> ROLLING CHANGES: "
        roll_changed_pkgs --revs $OLD_HASH HEAD
    fi
else
    git co ${TRUNK}

    TRUNK_DIRTY=$(git status --porcelain)

    if [[ "${BRANCH_DIRTY}" || "${TRUNK_DIRTY}" ]]; then
        echo ">> ${TRUNK} or ${BRANCH} is dirty ಠ_ಠ"
        echo ">> Stash or commit before pulling."
    else
        OLD_HASH=$(git rev-parse ${TRUNK})
        git pull
        echo ">> ROLLING CHANGES: "
        roll_changed_pkgs --revs $OLD_HASH HEAD -n

        git co ${BRANCH}
        OLD_HASH=$(git merge-base $BRANCH $TRUNK)
        echo ">> sleeping (∪｡∪)｡｡｡zzz"
        sleep 2
        git rebase master
        echo ">> ROLLING CHANGES: "
        roll_changed_pkgs --revs $OLD_HASH HEAD -n
    fi
fi
cd -
