#!/bin/bash

# example call:
#   $ sts process_flow test        # sync process flow dir to test
#   $ sts common                   # sync common to dev (default)

LOCAL_PATH=${1}
STAGE="${2,,}"
if [[ -z "${STAGE}" ]]; then
    STAGE=dev
fi

SERVER=${STAGE}

SRV_DAT_DIR=/var/www/sites/${SERVER}.perflogic.com/__lib__/dat/${LOCAL_PATH}

echo ${SRV_DAT_DIR}

rlocks -f -u | rsync -av --files-from - ./ dev-lnx:${SRV_DAT_DIR}

