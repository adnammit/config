#!/bin/bash

# Invoke while on a feature branch to rebase in changes from master and roll associated packages

TRUNK=master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_ROOT=$(git rev-parse --show-toplevel)
DIVERGE_REV=$(git merge-base $BRANCH $TRUNK)
TREE_DIRTY=$(git status --porcelain)
SUCCESS=0
# PARSE_RESULT=parse_rcp_result.sh

#### HELPER FUNC FOR UPDATE FUNCS
#### roll_changed_pkgs --porcelain returns one of the following:
# * `Error: <error>` on errors with exit 1 status
# * `none`: if no packages are to be rolled
# * a list of packages readable by build/roll_out
function parse_result()
{
    local SUCCESS=0
    local RESULT="$@"
    local RESULT_STR=""

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
        SUCCESS=1
        echo "Nothing to roll out ¯\_(ツ)_/¯"
    else
        SUCCESS=1
        echo ">> Successful update! ~(˘▾˘~)"
    fi

    return $SUCCESS
}

if [[ $TREE_DIRTY ]]; then
    echo ">> $BRANCH is dirty ಠ_ಠ"
    echo ">> Stash or commit before pulling."
else
    git rebase $TRUNK
    echo ">> Rolling changes since $DIVERGE_REV"
    parse_result $(roll_changed_pkgs --porcelain --revs $DIVERGE_REV HEAD)
fi
