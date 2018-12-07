#!/bin/bash

CLIENTS=$(find_pf_clients.sh)
OPTS_STR=
HELP_FLAG=

function display_help
{
    echo "Call to sync client data for all process_flow clients."
    echo "Cues off of a search for the process_flow_request.pls script for generating process flows."
    echo "Options include '--link <repo>' and '--dry-run'."
    echo "Sync client data for all process_flow clients by linking to master repo site:"
    echo "  \$ sync_pf_clients --link alr "
}

while [[ $# != 0 ]] ; do
    case "${1}" in
          -l | --link)
              OPTS_STR=${OPTS_STR}" --link $2"
              shift 2
              ;;
          -h | --help)
              HELP_FLAG=1
              break
              ;;
          -n|--dry-run)
              OPTS_STR=${OPTS_STR}" -n"
              shift
              ;;
          -*)
              echo "Error: Unknown option: $1"
              display_help
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
    sync_client_data.sh $OPTS_STR $CLIENTS
fi
