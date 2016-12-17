#!/bin/bash

LOCAL_PATH=${1}
STAGE="${2,,}"
if [[ -z "${STAGE}" ]]; then
    STAGE=dev
fi

SERVER=pl_"${STAGE}"

OLD_DIR=`pwd`

cd ~/${STAGE}/${LOCAL_PATH}
SRV_DAT_DIR=/home/${SERVER}/web/__lib__/${LOCAL_PATH}

rlocks -f -u | rsync -av --files-from - ./ dev-lnx:${SRV_DAT_DIR}

cd ${OLD_DIR}
