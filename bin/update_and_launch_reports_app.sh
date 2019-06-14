#!/bin/bash

# TO DO 
# - we're just updating dev, but if we have WIP, that won't be updated
#  - really the algorithm for each branch should be: 
#       * git stash -u
#       * git checkout dev && PULL_RES=$(git pull)
#       * if (updated) then set flag
#       * reset PULL_RES
#       * 
# - getting false positives win PULL_RES -- if [[ $PULL_RES =~ "files changed" ]] evaluates as true
#   even when it only updates branch data (no files changed in dev). trying resetting PULL_RES between operations

a=$PWD
REP_DIR='/cygdrive/c/dev/git/impact-reports'

# vars to store git command results
# PULL_RES=""
REB_RES=""
APPLY_RES=""
# CURR_CHANGES=""

# flags for success/failure
APP_UPDATED=0 #rebase did/not fail
# APP_FAILED=0 #could not check out dev b/c curr changes
APP_STASH=0 #stash could not be reapplied 

SERVICE_UPDATED=0
SERVICE_FAILED=0

INT_UPDATED=0
INT_FAILED=0

DB_UPDATED=0
DB_FAILED=0



echo "---> UPDATING REPORTS APP"
cd "$REP_DIR/reports-app"

git stash -u && git checkout dev && git pull && git co -

# Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
REB_RES=$(git rebase dev)
echo ">> Rebase result is"
echo "$REB_RES"

# if rebase was not successful, rewind
if [[ $REB_RES =~ "failed to merge" ]] ; then
    git rebase --abort
else
    APP_UPDATED=1

    APPLY_RES=$(git stash apply)
    echo ">> APPLY_RES is $APPLY_RES"

    # if stash could not be applied, reset and warn that changes are still in stash
    if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
        git reset --hard
        APP_STASH=1
    else
        # git stash drop # this is dangerous, let's not do it quite yet
        echo ">> Successful apply, you can drop stash in reports-app"
    fi
fi

REB_RES=""
APPLY_RES=""

# open sesame
code .

# echo "---> UPDATING REPORTS APP"
# cd "$REP_DIR/reports-app"
# CURR_CHANGES=$(git status -s)
# if [[ $CURR_CHANGES ]] ; then 
#     APP_FAILED=1
# else
#     git checkout dev && PULL_RES=$(git pull) && echo "PULL RES IS: $PULL_RES" && git co -
#     if [[ $PULL_RES =~ "files changed" ]] ; then
#         APP_UPDATED=1
#     fi
#     PULL_RES=""
# fi

# # open sesame
# code .

# echo "---> UPDATING REPORTS SERVICE"
# cd "$REP_DIR/reports-service"
# CURR_CHANGES=$(git status -s)
# if [[ $CURR_CHANGES ]] ; then 
#     SERVICE_FAILED=1
# else
#     git checkout dev && PULL_RES=$(git pull) && echo "PULL RES IS: $PULL_RES" && git co -
#     if [[ $PULL_RES =~ "files changed" ]] ; then
#         SERVICE_UPDATED=1
#     fi
#     PULL_RES=""
# fi
# # open sesame
# code .

# echo "---> UPDATING INTEGRATION"
# cd "$REP_DIR/integration"
# CURR_CHANGES=$(git status -s)
# if [[ $CURR_CHANGES ]] ; then 
#     INT_FAILED=1
# else
#     git checkout dev && PULL_RES=$(git pull) && echo "PULL RES IS: $PULL_RES" && git co -
#     if [[ $PULL_RES =~ "files changed" ]] ; then
#         INT_UPDATED=1
#     fi
#     PULL_RES=""
# fi

# echo "---> UPDATING DATABASE"
# cd "$REP_DIR/database"
# CURR_CHANGES=$(git status -s)
# if [[ $CURR_CHANGES ]] ; then 
#     DB_FAILED=1
# else
#     git checkout dev && PULL_RES=$(git pull) && echo "PULL RES IS: $PULL_RES" && git co -
#     if [[ $PULL_RES =~ "files changed" ]] ; then
#         DB_UPDATED=1
#     fi
#     PULL_RES=""
# fi

# if [ $APP_FAILED -eq 1 ] || [ $SERVICE_FAILED -eq 1 ] || [ $INT_FAILED -eq 1 ] || [ $DB_FAILED -eq 1 ]
# then 
#     if [ $APP_FAILED -eq 1 ] ; then 
#         echo "!!! Failed updating report-app"
#     fi
#     if [ $SERVICE_FAILED -eq 1 ] ; then 
#         echo "!!! Failed updating report-service"
#     fi
#     if [ $INT_FAILED -eq 1 ] ; then 
#         echo "!!! Failed updating integration"
#     fi
#     if [ $DB_FAILED -eq 1 ] ; then 
#         echo "!!! Failed updating database"
#     fi
# else
#     if [ $APP_UPDATED -eq 1 ] ; then 
#         echo ">>> Updates needed for report app"
#     fi

#     if [ $DB_UPDATED -eq 1 ] ; then 
#         # if there are updates, open solution for publishing step and destroy the local volume
#         cd "$REP_DIR/database"
#         explorer.exe *.sln
#         cd "$REP_DIR/integration"
#         docker-compose down -v
#         echo "--> Updates were made to the database -- re-publish the database"
#     fi
    
#     if [ $SERVICE_UPDATED -eq 1 ] || [ $INT_UPDATED -eq 1 ] || [ $DB_UPDATED -eq 1 ]
#     then 
#         echo "!!! Updates required before launching docker"
#         if [ $SERVICE_UPDATED -eq 1 ] ; then 
#             echo "--> Updates needed for report service"
#         fi
#         if [ $INT_UPDATED -eq 1 ] ; then 
#             echo "--> Updates needed for integration"
#         fi
#     else
#         cd "$REP_DIR/integration"
        
#         docker-compose up --build # don't always need to build but i'm being lazy
#     fi
# fi

cd $a