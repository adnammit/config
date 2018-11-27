#!/bin/bash
# Invoke while on master or on a feature branch to rebase changes from master and roll associated packages

echo ">> UPDATING DEV"

TRUNK=master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH_DIRTY=$(git status --porcelain)
MSUCCESS=0
BSUCCESS=0

if [[ $1 == "-b" || $1 == "--branch-only" ]] ; then
    BRANCH_ONLY=1
fi

#### HELPER FUNC FOR UPDATE FUNCS
#### roll_changed_pkgs --porcelain returns one of the following:
# * `Error: <error>` on errors with exit 1 status
# * `none`: if no packages are to be rolled
# * a list of packages readable by build/roll_out
function parse_rcp_result()
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

    TMP=$(echo $RESULT | head -n1 | sed -e 's/ *\([a-zA-Z]*\).*/\1/')

    if [[ $TMP == "Error" ]] ; then
        echo "!! Unsuccessful update ಠ╭╮ಠ"
    elif [[ $TMP == "none" ]] ; then
        SUCCESS=1
        echo "?? Nothing to roll out ¯\_(ツ)_/¯"
    else
        SUCCESS=1
        echo ">> Successful update! ~(˘▾˘~)"
    fi

    return $SUCCESS
}

if [[ $BRANCH_DIRTY ]] ; then
    echo "!! $BRANCH is dirty ಠ╭╮ಠ"
    echo "!! Stash or commit before pulling."
else
    # WE'RE ON MASTER -- JUST UPDATE IT
    if [[ $BRANCH == $TRUNK ]] ; then
        OLD_HASH=$(git rev-parse $TRUNK)
        git pull
        echo ">> Rolling changes to master since $OLD_HASH"
        parse_rcp_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
        MSUCCESS=$?
        BSUCCESS=1
    else
        # WE'RE ON A FEATURE AND NEED TO UPDATE MASTER FIRST
        if [[ $BRANCH_ONLY == 1 ]] ; then
            MSUCCESS=1
        else
            git co $TRUNK
            OLD_HASH=$(git rev-parse $TRUNK)
            echo ">> $TRUNK is currently at $OLD_HASH"
            # would love to check for an error here but pull appears to always return '0'
            git pull
            # echo ">> pull result is $?"
            echo ">> Rolling changes to master since $OLD_HASH"
            parse_rcp_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
            MSUCCESS=$?
            git co $BRANCH
        fi
        # IF WE HAD NO ERROR ON MASTER OR ARE JUST DOING BRANCH, UPDATE BRANCH
        if [[ $MSUCCESS == 1 ]] ; then
            OLD_HASH=$(git merge-base $BRANCH $TRUNK)
            REBASE=$(git rebase $TRUNK)
            echo ">> rebase result is $REBASE"
            if [[ $REBASE == 0 ]] ; then
                echo ">> Rolling changes to $BRANCH since $OLD_HASH:"
                parse_rcp_result $(roll_changed_pkgs --porcelain --revs $OLD_HASH HEAD)
                BSUCCESS=$?
            else
                if [[ $REBASE =~ "up to date" ]] ; then
                    echo "?? No rebase -- $BRANCH is already up to date ¯\_(ツ)_/¯"
                    BSUCCESS=1
                else
                    echo "!!! unsuccessful rebase of $TRUNK to master"
                fi
            fi
        else
            echo "!! Update to $BRANCH was skipped -- error in updating master"
        fi
    fi
fi

echo "Branch Success: $BSUCCESS and Master Success: $MSUCCESS"

if [[ $BSUCCESS -eq 1 && $MSUCCESS -eq 1 ]] ; then
    echo 1
else
    echo 0
fi
