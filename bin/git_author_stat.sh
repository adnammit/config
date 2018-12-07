#!/bin/bash
# I wrote this to justify spending 6 months on a project... did I write
#   a quantity of code (if not quality) comparable to my peers during
#   that time?

if [[ $1 == "-h" ]] ; then
    echo ""
    echo "Get stats on a particular author."
    echo "First arg is for the author, second arg for any additional args."
    echo "For example, try: "
    echo "   \$ git_author_stat.sh \"Amanda Ryman\" '--since=6.months --first-parent master' "
    echo ""

else

    if [[ $1 ]] ; then
        AUTHOR=${1}
    else
        AUTHOR="Amanda Ryman"
    fi
    if [[ $2 ]] ; then
        EXTRA_ARGS=${2}
    fi

    echo "Git stats for $AUTHOR are:"
    git log --author="$AUTHOR" $EXTRA_ARGS --pretty=tformat: --numstat | awk '{inserted+=$1; deleted+=$2; delta+=$1-$2; ratio=deleted/inserted} END {printf "Commit stats:\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n", inserted, deleted, delta, ratio }' -

fi
