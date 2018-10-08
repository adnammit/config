#!/bin/bash

# Invoke while on master or on a feature branch to rebase changes from master and roll associated packages

echo ">> UPDATING DEV"

cd ~/dev/

TRUNK=master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH_DIRTY=$(git status --porcelain)
MSUCCESS=0
BSUCCESS=0
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

if [[ $BRANCH_DIRTY ]] ; then
    echo ">> $BRANCH is dirty ಠ_ಠ"
    echo ">> Stash or commit before pulling."
else
    if [ $BRANCH == $TRUNK ] ; then
        OLD_HASH=$(git rev-parse $TRUNK)
        git pull
        echo ">> Rolling changes to master since $OLD_HASH"

        parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
        MSUCCESS=$?
        BSUCCESS=1
    else
        git co $TRUNK

        TRUNK_DIRTY=$(git status --porcelain)

        if [[ $TRUNK_DIRTY ]] ; then
            echo ">> $TRUNK is dirty ಠ_ಠ"
            echo ">> Stash or commit before pulling."
        else
            OLD_HASH=$(git rev-parse $TRUNK)
            # would love to check for an error here but pull appears to always return '0'
            git pull
            echo ">> pull result is $?"
            echo ">> Rolling changes to master since $OLD_HASH"
            parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
            MSUCCESS=$?

            # if there was no error on master, continue
            if [[ $MSUCCESS == 1 ]] ; then
                git co ${BRANCH}
                OLD_HASH=$(git merge-base $BRANCH $TRUNK)
                # would love to check for an error here but rebase appears to always return '0'
                git rebase master
                echo ">> rebase result is $?"
                echo ">> Rolling changes to $BRANCH since $OLD_HASH:"
                parse_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
                BSUCCESS=$?
            else
                echo ">> No updates to master, skipping updates to $BRANCH"
            fi
        fi
    fi
fi
cd -

echo "Branch Success: $BSUCCESS and Master Success: $MSUCCESS"

if [[ $BSUCCESS -eq 1 && $MSUCCESS -eq 1 ]] ; then
    echo 1
else
    echo 0
fi
