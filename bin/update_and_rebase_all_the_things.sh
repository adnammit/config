#!/bin/bash

SKIP_DOCKER_REFRESH=
HELP_FLAG=

function display_help
{
    echo
    echo "The ultimate Refresh All The Things script."
    echo
    echo "Performs all the following:"
    echo "* Pulls dev and rebases all Employee Management-related things including Auth, Integration and ETL Engine"
    echo "* Restarts docker-compose with a fresh volume (YOU WILL LOSE LOCALHOST DATA)"
    echo "* Restarts docker"
    echo "* Publishes database"
    echo
    echo "OPTIONS:"
    echo "      -h : print usage"
    echo "      -k : skip volume tear-down and docker build/re-publish"
    echo
}

while [[ $# != 0 ]] ; do
    case "${1}" in
        -h |--help)
            HELP_FLAG=1
            shift
            ;;
        -k | --skip-teardown)
            SKIP_DOCKER_REFRESH=1
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

    # reusable vars to return results from update_branch()
    UPDATED= # rebase did (not) fail
    STASHED= # stash could (not) be applied

    # flags for individual success/failure
    APP_UPDATED=
    APP_STASH=
    SERVICE_UPDATED=
    SERVICE_STASH=
    INT_UPDATED=
    INT_STASH=
    DB_UPDATED=
    DB_STASH=
    ETL_UPDATED=
    ETL_STASH=
    AUTH_UPDATED=
    AUTH_STASH=
    AUTH_SERVICE_UPDATED=
    AUTH_SERVICE_STASH=
    REPAIR_UPDATED=
    REPAIR_STASH=
    REPAIR_SERVICE_UPDATED=
    REPAIR_SERVICE_STASH=
    TRACKING_SERVICE_UPDATED=
    TRACKING_SERVICE_STASH=
    AT_APP_UPDATED=
    AT_APP_STASH=
    AT_API_UPDATED=
    AT_API_STASH=

    function update_branch()
    {
        local PROJECT_DIR=$1
        local STASH_RES=""
        local REB_RES=""
        local APPLY_RES=""
        local SKIP_APPLY=

        echo
        echo ">>--> UPDATING $PROJECT_DIR"
        cd "/cygdrive/c/dev/$PROJECT_DIR"

        STASH_RES=$(git stash -u)
        git checkout dev && git pull && git co -

        if [[ $STASH_RES =~ "No local changes to save" ]] ; then
            SKIP_APPLY=1
        fi

        # Regardless of whether there were changes or not we can be lazy and just rebase on our clean tree
        REB_RES=$(git rebase dev)
        echo
        echo "===== REBASE RES IS"
        echo "$REB_RES"

        # if rebase was not successful, rewind
        if [[ $REB_RES =~ "Failed to merge" ]] || [[ $REB_RES =~ "Patch failed" ]] ; then
            echo "!!! FAILED TO REBASE, ABORTING"
            # echo "$REB_RES"
            git rebase --abort
        else
            UPDATED=1

            if [[ ! $SKIP_APPLY ]] ; then
                APPLY_RES=$(git stash apply)

                # if stash could not be applied, reset and warn that changes are still in stash
                if [[ $APPLY_RES =~ "CONFLICT" ]] ; then
                    echo "!!! STASH APPLY CONFLICT"
                    echo "$APPLY_RES"
                    git reset --hard
                    STASHED=1
                else
                    git stash drop
                fi
            fi
        fi
    }

    #--------------------------------------------------------------------------------------
    # APP
    #--------------------------------------------------------------------------------------
    update_branch "impactReports/reports-app"
    APP_UPDATED=$UPDATED
    APP_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # SERVICE
    #--------------------------------------------------------------------------------------
    update_branch "impactReports/reports-service"
    SERVICE_UPDATED=$UPDATED
    SERVICE_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # INTEGRATION
    #--------------------------------------------------------------------------------------
    update_branch "impactReports/integration"
    INT_UPDATED=$UPDATED
    INT_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # DATABASE
    #--------------------------------------------------------------------------------------
    update_branch "impactReports/database"
    DB_UPDATED=$UPDATED
    DB_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # ETL-ENGINE
    #--------------------------------------------------------------------------------------
    update_branch "impactReports/etl-engine"
    ETL_UPDATED=$UPDATED
    ETL_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # AUTH APP
    #--------------------------------------------------------------------------------------
    update_branch "authorization-app"
    AUTH_UPDATED=$UPDATED
    AUTH_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # AUTH SERVICE
    #--------------------------------------------------------------------------------------
    update_branch "authorization-service"
    AUTH_SERVICE_UPDATED=$UPDATED
    AUTH_SERVICE_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # REPAIR APP
    #--------------------------------------------------------------------------------------
    update_branch "repair-app"
    REPAIR_UPDATED=$UPDATED
    REPAIR_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # REPAIR SERVICE
    #--------------------------------------------------------------------------------------
    update_branch "repair-service"
    REPAIR_SERVICE_UPDATED=$UPDATED
    REPAIR_SERVICE_STASH=$STASHED
    UPDATED=
    STASHED=


    #--------------------------------------------------------------------------------------
    # TRACKING SERVICE
    #--------------------------------------------------------------------------------------
    update_branch "tracking-service"
    TRACKING_SERVICE_UPDATED=$UPDATED
    TRACKING_SERVICE_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # ATTENDANCE TRACKER APP
    #--------------------------------------------------------------------------------------
    update_branch "attendanceTracker"
    AT_APP_UPDATED=$UPDATED
    AT_APP_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # ATTENDANCE TRACKER API
    #--------------------------------------------------------------------------------------
    update_branch "attendanceTrackerApi"
    AT_API_UPDATED=$UPDATED
    AT_API_STASH=$STASHED
    UPDATED=
    STASHED=

    #--------------------------------------------------------------------------------------
    # REPORT RESULTS
    #--------------------------------------------------------------------------------------
    SUCCESS=1
    echo ""
    echo "RESULTS:"

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
        SUCCESS=0
    fi
    if [[ $ETL_STASH ]] ; then 
        echo "!!! Stash could not be applied to etl-engine"
        SUCCESS=0
    fi
    if [[ $AUTH_STASH ]] ; then 
        echo "!!! Stash could not be applied to authorization-app"
        SUCCESS=0
    fi
    if [[ $AUTH_SERVICE_STASH ]] ; then 
        echo "!!! Stash could not be applied to authorization-service"
        SUCCESS=0
    fi
    if [[ $REPAIR_STASH ]] ; then 
        echo "!!! Stash could not be applied to repair-app"
        SUCCESS=0
    fi
    if [[ $REPAIR_SERVICE_STASH ]] ; then 
        echo "!!! Stash could not be applied to repair-service"
        SUCCESS=0
    fi
    if [[ $TRACKING_SERVICE_STASH ]] ; then 
        echo "!!! Stash could not be applied to tracking-service"
        SUCCESS=0
    fi
    if [[ $AT_APP_STASH ]] ; then 
        echo "!!! Stash could not be applied to attendanceTracker"
        SUCCESS=0
    fi
    if [[ $AT_API_STASH ]] ; then 
        echo "!!! Stash could not be applied to attendanceTrackerApi"
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
    if [[ ! $AUTH_UPDATED ]] ; then 
        echo "!!! Error updating authorization-app"
        SUCCESS=0
    fi
    if [[ ! $AUTH_SERVICE_UPDATED ]] ; then 
        echo "!!! Error updating authorization-service"
        SUCCESS=0
    fi
    if [[ ! $REPAIR_UPDATED ]] ; then 
        echo "!!! Error updating repair-app"
        SUCCESS=0
    fi
    if [[ ! $REPAIR_SERVICE_UPDATED ]] ; then 
        echo "!!! Error updating repair-service"
        SUCCESS=0
    fi
    if [[ ! $TRACKING_SERVICE_UPDATED ]] ; then 
        echo "!!! Error updating tracking-service"
        SUCCESS=0
    fi
    if [[ ! $AT_APP_UPDATED ]] ; then 
        echo "!!! Error updating attendanceTracker"
        SUCCESS=0
    fi
    if [[ ! $AT_API_UPDATED ]] ; then 
        echo "!!! Error updating attendanceTrackerApi"
        SUCCESS=0
    fi

    # If all projects are successfully updated, we can re-launch docker-compose and build our db
    if [ $SUCCESS -eq 1 ] ; then
        echo "*********************************"
        echo "All projects successfully updated"
        echo "*********************************"

        # if [[ ! $SKIP_DOCKER_REFRESH ]] ; then
        #     docker_build_and_publish.sh
        # else
        #     echo "Skipping docker refresh"
        # fi
    fi

    cd $a

fi