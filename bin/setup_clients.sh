#!/bin/bash

a=$PWD
ORGS=
LINK_STR=
SITE_STR=
DRY_RUN=
HELP_FLAG=
DO_COMMON=
SKIP_DATA=
CLIENT_PKGS="abington advocate advocate_demo ashland barrett bayhealth bbtrails bswqa cadence cfhp cmc contracosta covenanthealth demo demo2 fintrack forrestgeneral grmc healthquest hendry htpn jhs leadership lifebridge mercy mhs northvalley northwell nshs om om-qvp oumc oums parkland perflogic rcrmc riverside rounding sanantonio scvmc sfgh sg sharp sickkids skf ski ski2 sni solutions supplychain teletracking texas texasrhp14 texasrhp15 texasrhp3 texasrhp6 texasrhp7 tha thr tjuh tpc tracer transformation uhs umhs va-eoc vaco vcu visn10 visn22 visn4 visn9 wellmont wellspan"

function display_help
{
    echo "SETUP_CLIENTS:"
    echo ""
    echo "Sync data and roll out any packages listed in Additional Modules and"
    echo "Search Modules."
    echo ""
    echo "------------------------------------------------------------------------"
    echo "OPTIONS:"
    echo "Link synced data to another repo using '--link'. This will pull data to"
    echo "the repo being linked to. This might be broken when trying to link to"
    echo "non-master repos (if you have a branch repo linked to another branch repo)."
    echo ""
    echo "    \$ setup_client jhs uhs epsg --link alr"
    echo ""
    echo "If you think your data is reasonably up to date, use '--skip' to just "
    echo "roll packages and skip pulling down data."
    echo ""
    echo "Take note that you might not get an accurate package list with '--dry-run' "
    echo "unless there is some accurate client data already pulled down. ¯\_(ツ)_/¯"
    echo ""
    echo "Use '--common' to include common in the packages being rolled out."
    echo ""
    echo "------------------------------------------------------------------------"
    echo "NOTE:"
    echo "This script creates a ~/temp/ directory in which to store the client"
    echo "data for parsing. If you don't like it, change it."
    echo ""
    echo "The list of CLIENT_PKGS will need to be manually updated when new "
    echo "clients are added, so that's annoying."
    # echo "Use the '--all' flag to run setup for all clients."
    echo "Current list of client packages is: "
    echo ""
    echo $@
}

if [[ $# == 0 ]] ; then
    HELP_FLAG=1
else
    while  [ "${#}" != 0 ] ; do
        case "${1}" in
            -k | --skip)
                SKIP_DATA=1
                shift
                ;;
            -l | --link)
                LINK_STR="--link $2"
                SITE_STR="--site $2"
                shift 2
                ;;
            # -a | --all
            #     ORGS=$CLIENT_PKGS
            #     shift
            #     ;;
            -c | --common)
                DO_COMMON=1
                break
                ;;
            -h | --help)
                HELP_FLAG=1
                break
                ;;
            -n | --dry-run)
                DRY_RUN="-n"
                shift
                ;;
            -*)
                echo "Error: Unknown option: $1"
                display_help
                break
                ;;
            *)
                ORGS=$ORGS$1" "
                shift
                ;;
        esac
    done
fi

if [[ $HELP_FLAG || ! $ORGS ]] ; then
    display_help $CLIENT_PKGS
elif [[ $ORGS ]] ; then

    cd ~/dev/

    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    TMP_DIR="temp"
    PKGS=
    FILENAME=
    VERSION=
    MAX=
    MAXFILE=
    BZFILE=
    LINEARR=
    LINE=

    if [[ $BRANCH == "master" ]] ; then
        CLIENT_DIR="//dev-lnx/repo_sites/alr/__client__/"
    else
        CLIENT_DIR="//dev-lnx/repo_sites/alr-$BRANCH/__client__/"
    fi

    cd ~

    if [[ ! -d $TMP_DIR ]] ; then
        mkdir $TMP_DIR
    fi

    if [[ ! $SKIP_DATA ]] ; then
        # If we're linking to another site, make sure that site's data is up to date first
        if [[ $LINK_STR ]] ; then
            sync_client_data.sh $SITE_STR $DRY_RUN $ORGS
        fi
        sync_client_data.sh $LINK_STR $DRY_RUN $ORGS
    else
        echo "Skipping data"
    fi

    for ORG in ${ORGS}
    do
        MAX=0
        MAXFILE=

        # If the client has its own package, add it to the roll list
        if [[ $CLIENT_PKGS =~ "$ORG" ]] ; then
            PKGS=$PKGS$ORG" "
        else
            echo "WARN: $ORG was not added to package list"
        fi

        # Copy all the org.dat* files to temp/ and then look for the most recent one
        rsync -ta --delete-excluded --exclude='*.lock' --include='org.dat*' --exclude='*' $CLIENT_DIR$ORG/ $TMP_DIR/

        for FILE in ${TMP_DIR}/* ; do
            FILENAME=$(basename ${FILE})
            VERSION="${FILENAME: -2}"

            # Check for annoying files ending in org.dat.2 instead of org.dat.02
            if [[ $VERSION =~ "." ]] ; then
                VERSION="${VERSION: -1}"
            fi

            if [ $VERSION -gt $MAX ] ; then
                MAX=$VERSION
                MAXFILE=$FILENAME
            fi
        done

        # Unzip the file if needed
        if [[ "$MAXFILE" =~ "bz2" ]] ; then
            BZFILE=$MAXFILE".out"
            bzip2 -dfq $TMP_DIR/$MAXFILE > $TMP_DIR/$BZFILE
            MAXFILE=$BZFILE
        fi

        # Store the file lines in an array so we can iterate through them in a weird-ass way:
        mapfile -t LINEARR < $TMP_DIR/$MAXFILE

        for ((i=0; i<${#LINEARR[*]}; i++)) ; do
            LINE=${LINEARR[i]}

            # If we find Additional or Search Modules, walk through the subsequent lines
            #   until we come to the closing Val_list tag looking for anything that doesn't
            #   start with a tag opener '<' and isn't fake package 'it_pmo'
            if [[ $LINE =~ "additional_modules" || $LINE =~ "search_modules" ]] ; then
                while [[ $LINE ]]; do
                    LINE=${LINEARR[i]}
                    if [[ $LINE =~ "</Val_list>" ]] ; then
                        LINE=
                    else
                        if [[ ${LINE:0:1} != "<" && $LINE != "it_pmo" ]] ; then
                            PKGS=$PKGS$LINE" "
                        fi
                    fi
                    ((i++))
                done
            fi
        done
    done

    # Create a unique list of packages to roll:
    if [[ $DO_COMMON ]] ; then
        PKGS=$PKGS"common"
    fi
    PKGS=$(echo "$PKGS" | tr ' ' '\n' | sort -u | tr '\n' ' ')
    # PKGS=$(echo $PKGS | sort | uniq) # y u no work??

    if [[ ! $DRY_RUN ]] ; then
        roll_out $PKGS
    fi

    echo "ROLLED: $PKGS"

fi

cd $a
