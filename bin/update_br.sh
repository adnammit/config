#!/bin/bash

if [ "${1}" == "-n" ] ; then
    ARG_STR=${1}
fi

TRUNK=master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_ROOT=$(git rev-parse --show-toplevel)
DIVERGE_REV=$(git merge-base $BRANCH $TRUNK)
TREE_DIRTY=$(git status --porcelain)
SUCCESS=0
PARSE_RESULT="parse_rcp_result.sh"

if [ "$TREE_DIRTY" ]; then
    echo ">> ${BRANCH} is dirty ಠ_ಠ"
    echo ">> Stash or commit before pulling."
else
    if [ "${ARG_STR}" ] ; then
        echo ">> DRY_RUN: not really rebasing"
    else
        git rebase ${TRUNK}
    fi

    echo ">> Rolling changes since ${DIVERGE_REV}"
    SUCCESS=$($PARSE_RESULT "${2}")   #$(roll_changed_pkgs --porcelain --revs $DIVERGE_REV HEAD)
    # parse_rcp_result "${2}" #$(roll_changed_pkgs --porcelain --revs $DIVERGE_REV HEAD)

    # SUCCESS=$?
fi

echo $SUCCESS
# return ${SUCCESS}
