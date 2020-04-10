#!/bin/bash
# handle multiple clients w/ --link arg and dry run options

LINK_STR=
SITE_STR=
DRY_RUN=
HELP_FLAG=

function display_help
{
    echo "Sync data for multiple clients using copy_org."
    echo "All the usual copy_org options apply."
    echo "Example: pull data to master, then link f3 to master all while in an altogether different repo:"
    echo "   \$ sync_client_data --site alr jhs uhs epsg"
    echo "   \$ sync_client_data --link alr --site alr-f3 jhs uhs epsg"
}

if [[ $# == 0 ]] ; then
    HELP_FLAG=1
else
    while  [[ $# != 0 ]] ; do
        case "${1}" in
            -l | --link)
                LINK_STR="--link $2"
                shift 2
                ;;
            -s | --site)
                SITE_STR="--site $2"
                shift 2
                ;;
            -h | --help)
                HELP_FLAG=1
                break
                ;;
            -n | --dry-run)
                DRY_RUN=1
                shift
                ;;
            -*)
                echo "Error: Unknown option: $1"
                echo ""
                HELP_FLAG=1
                break
                ;;
            *)
                ORGS+=($1)
                shift
                ;;
        esac
    done
fi

if [[ ${#ORGS[@]} -gt 0 && ! $HELP_FLAG ]] ; then
    for ORG in ${ORGS[@]}
    do
        if [[ $DRY_RUN ]] ; then
            echo "DRY RUN: copy_org $ORG $LINK_STR $SITE_STR"
        else
            copy_org $ORG $LINK_STR $SITE_STR
        fi
    done
else
    display_help
fi
