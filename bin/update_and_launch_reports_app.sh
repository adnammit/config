#!/bin/bash

# TO DO     
# - can we make an update_branch function? tricky cos we are returning multiple success flags for each project, but we can return a string and parse it at the end

OPEN_APP=
OPEN_SERVICE=
OPEN_INTEGRATION=
OPEN_DATABASE=
OPEN_ETL=
SKIP_VOLUME_TEARDOWN=
HELP_FLAG=

function display_help
{
    echo ""
    echo "The ultimate Refresh All The DSS Things script."
    echo "Performs all the following:"
    echo "* Restarts docker-compose with a fresh volume (YOU WILL LOSE LOCALHOST DATA)"
    echo "* Pulls dev and rebases all DSS-related branches"
    echo "* Restarts docker"
    echo "* Publishes database"
    echo ""
    echo "OPTIONS:"
    echo "      -h : print usage"
    echo "      -a : open the app project in vs code"
    echo "      -s : open the service project in vs code"
    echo "      -i : open the integration project in vs code"
    echo "      -d : open the database project in vs"
    echo "      -e : open the etl project in vs"
    echo "      -k : skip volume tear-down"
    echo ""
}

while [[ $# != 0 ]] ; do
    case "${1}" in
        -h |--help)
            HELP_FLAG=1
            shift
            ;;
        -a | --open-app)
            OPEN_APP=1
            shift
            ;;
        -s | --open-service)
            OPEN_SERVICE=1
            break
            ;;
        -i | --open-integration)
            OPEN_INTEGRATION=1
            shift
            ;;
        -d | --open-database)
            OPEN_DATABASE=1
            shift
            ;;
        -e | --open-etl)
            OPEN_ETL=1
            shift
            ;;
        -k | --skip-teardown)
            SKIP_VOLUME_TEARDOWN=1
            shift
            ;;
        -*)
            echo "Error: Unknown option: $1"
            HELP_FLAG=1
            break
            ;;
        *)
            break
            ;;
    esac
done

if [[ $HELP_FLAG ]] ; then
    display_help
else

    a=$PWD
    REP_DIR='/cygdrive/c/dev/git/impact-reports'

    # vars to store git command results
    STASH_RES=""
    REB_RES=""
    APPLY_RES=""
    SKIP_APPLY=

    # flags for success/failure
    APP_UPDATED= # rebase did (not) fail
    APP_STASH= # stash could (not) be applied
    SERVICE_UPDATED=
    SERVICE_STASH=
    INT_UPDATED=
    INT_STASH=
    DB_UPDATED=
    DB_STASH=
    ETL_UPDATED=
    ETL_STASH=

    # #-------------------------------------------------------------------------------------------------------
    # # TEAR-DOWN
    # #-------------------------------------------------------------------------------------------------------
    # if [[ ! $SKIP_VOLUME_TEARDOWN ]] ; then
    #     echo "---> REMOVING DOCKER VOLUME"
    #     cd "$REP_DIR/integration"
    #     docker-compose down -v
    # fi

    #-------------------------------------------------------------------------------------------------------
    # APP
    #-------------------------------------------------------------------------------------------------------
    echo "---> UPDATING REPORTS APP"
    cd "$REP_DIR/reports-app"

    STASH_RES=$(git stash -u)
    git checkout dev && git pull && git co -

    if [[ $STASH_RES != *"No local changes to save"* ]] ; then
        SKIP_APPLY=1
    fi

    # Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
    REB_RES=$(git rebase dev)
    echo ">> Rebase result is"
    echo "$REB_RES"

    # if rebase was not successful, rewind
    if [[ $REB_RES =~ "failed to merge" ]] ; then
        git rebase --abort
    else
        APP_UPDATED=1

        if [[ ! $SKIP_APPLY ]] ; then
            APPLY_RES=$(git stash apply)
            echo ">> APPLY_RES is $APPLY_RES"

            # if stash could not be applied, reset and warn that changes are still in stash
            if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
                git reset --hard
                APP_STASH=1
            else
                git stash drop
            fi
        fi
    fi

    STASH_RES=""
    REB_RES=""
    APPLY_RES=""
    SKIP_APPLY=

    if [[ $OPEN_APP ]] ; then
        code .
    fi

    #-------------------------------------------------------------------------------------------------------
    # SERVICE
    #-------------------------------------------------------------------------------------------------------
    echo "---> UPDATING REPORTS SERVICE"
    cd "$REP_DIR/reports-service"

    STASH_RES=$(git stash -u)
    git checkout dev && git pull && git co -

    if [[ $STASH_RES != *"No local changes to save"* ]] ; then
        SKIP_APPLY=1
    fi

    # Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
    REB_RES=$(git rebase dev)
    echo ">> Rebase result is"
    echo "$REB_RES"

    # if rebase was not successful, rewind
    if [[ $REB_RES =~ "failed to merge" ]] ; then
        git rebase --abort
    else
        SERVICE_UPDATED=1

        if [[ ! $SKIP_APPLY ]] ; then
            APPLY_RES=$(git stash apply)
            echo ">> APPLY_RES is $APPLY_RES"

            # if stash could not be applied, reset and warn that changes are still in stash
            if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
                git reset --hard
                SERVICE_STASH=1
            else
                git stash drop
            fi
        fi
    fi

    STASH_RES=""
    REB_RES=""
    APPLY_RES=""
    SKIP_APPLY=

    if [[ $OPEN_SERVICE ]] ; then
        code .
    fi

    #-------------------------------------------------------------------------------------------------------
    # INTEGRATION
    #-------------------------------------------------------------------------------------------------------
    echo "---> UPDATING INTEGRATION"
    cd "$REP_DIR/integration"

    STASH_RES=$(git stash -u)
    git checkout dev && git pull && git co -

    if [[ $STASH_RES != *"No local changes to save"* ]] ; then
        SKIP_APPLY=1
    fi

    # Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
    REB_RES=$(git rebase dev)
    echo ">> Rebase result is"
    echo "$REB_RES"

    # if rebase was not successful, rewind
    if [[ $REB_RES =~ "failed to merge" ]] ; then
        git rebase --abort
    else
        INT_UPDATED=1

        if [[ ! $SKIP_APPLY ]] ; then
            APPLY_RES=$(git stash apply)
            echo ">> APPLY_RES is $APPLY_RES"

            # if stash could not be applied, reset and warn that changes are still in stash
            if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
                git reset --hard
                INT_STASH=1
            else
                git stash drop
            fi
        fi
    fi

    STASH_RES=""
    REB_RES=""
    APPLY_RES=""
    SKIP_APPLY=
      
    if [[ $OPEN_INTEGRATION ]] ; then
        code .
    fi

    #-------------------------------------------------------------------------------------------------------
    # DATABASE
    #-------------------------------------------------------------------------------------------------------
    echo "---> UPDATING DATABASE"
    cd "$REP_DIR/database"

    STASH_RES=$(git stash -u)
    git checkout dev && git pull && git co -

    if [[ $STASH_RES != *"No local changes to save"* ]] ; then
        SKIP_APPLY=1
    fi

    # Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
    REB_RES=$(git rebase dev)
    echo ">> Rebase result is"
    echo "$REB_RES"

    # if rebase was not successful, rewind
    if [[ $REB_RES =~ "failed to merge" ]] ; then
        git rebase --abort
    else
        DB_UPDATED=1

        if [[ ! $SKIP_APPLY ]] ; then
            APPLY_RES=$(git stash apply)
            echo ">> APPLY_RES is $APPLY_RES"

            # if stash could not be applied, reset and warn that changes are still in stash
            if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
                git reset --hard
                DB_STASH=1
            else
                git stash drop
            fi
        fi
    fi

    STASH_RES=""
    REB_RES=""
    APPLY_RES=""
    SKIP_APPLY=

    if [[ $OPEN_DATABASE ]] ; then
        explorer.exe *.sln
    fi

    #-------------------------------------------------------------------------------------------------------
    # ETL ENGINE
    #-------------------------------------------------------------------------------------------------------
    echo "---> UPDATING ETL ENGINE"
    cd "$REP_DIR/etl-engine"

    git checkout dev && git pull && git co -

    if [[ $STASH_RES != *"No local changes to save"* ]] ; then
        SKIP_APPLY=1
    fi

    # Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
    REB_RES=$(git rebase dev)
    echo ">> Rebase result is"
    echo "$REB_RES"

    # if rebase was not successful, rewind
    if [[ $REB_RES =~ "failed to merge" ]] ; then
        git rebase --abort
    else
        ETL_UPDATED=1

        if [[ ! $SKIP_APPLY ]] ; then
            APPLY_RES=$(git stash apply)
            echo ">> APPLY_RES is $APPLY_RES"

            # if stash could not be applied, reset and warn that changes are still in stash
            if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
                git reset --hard
                ETL_STASH=1
            else
                git stash drop
            fi
        fi
    fi

    STASH_RES=""
    REB_RES=""
    APPLY_RES=""
    SKIP_APPLY=

    if [[ $OPEN_ETL ]] ; then
        explorer.exe *.sln
    fi

    #-------------------------------------------------------------------------------------------------------
    # REPORT RESULTS
    #-------------------------------------------------------------------------------------------------------
    SUCCESS=1

    if [[ $APP_STASH ]] ; then 
        echo "!!! Stash could not be applied to report-app"
        SUCCESS=0
    fi
    if [[ $SERVICE_STASH ]] ; then 
        echo "!!! Stash could not be applied to report-service"
        SUCCESS=0
    fi
    if [[ $INT_STASH ]] ; then 
        echo "!!! Stash could not be applied to integration"
        SUCCESS=0
    fi
    if [[ $DB_STASH ]] ; then 
        echo "!!! Stash could not be applied to database"
    fi
    if [[ $ETL_STASH ]] ; then 
        echo "!!! Stash could not be applied to etl-engine"
        SUCCESS=0
    fi

    if [[ ! $APP_UPDATED ]] ; then 
        echo "!!! Error updating report-app"
        SUCCESS=0
    fi
    if [[ ! $SERVICE_UPDATED ]] ; then 
        echo "!!! Error updating report-service"
        SUCCESS=0
    fi
    if [[ ! $INT_UPDATED ]] ; then 
        echo "!!! Error updating integration"
        SUCCESS=0
    fi
    if [[ ! $DB_UPDATED ]] ; then 
        echo "!!! Error updating database"
        SUCCESS=0
    fi
    if [[ ! $ETL_UPDATED ]] ; then 
        echo "!!! Error updating etl-engine"
        SUCCESS=0
    fi

    # If all projects are successfully updated, we can re-launch docker-compose and buld our db
    if [ $SUCCESS -eq 1 ] ; then
        echo "*********************************"
        echo "All projects successfully updated"
        echo "*********************************"
        #######
        # call a second script to: 
        # tear down volume
        # up docker build
        # publish db

    fi

    cd $a

fi