#!/bin/bash

LOCAL_PATH=${1}
# STAGE="${2,,}"
# if [[ -z "${STAGE}" ]]; then
#     STAGE=dev
# fi

CONF="config"

a=$PWD

cd ~/${CONF}
SRV_DIR=/home/${CONF}
rsync -av --files-from - ./ dev-lnx:${SRV_DIR}

cd ${a}
