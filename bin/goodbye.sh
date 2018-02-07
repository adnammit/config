#!/bin/bash

USER=ryman.amanda

LOCAL_HOME=/c/UserData/${USER}
REMOTE_BKUP_DIR=${USER}@dev-lnx.portland.perflogic.com:/home/${USER}/win_backups

# dev git repo
SRC=${LOCAL_HOME}/dev
TGT=${REMOTE_BKUP_DIR}/dev
EXCLUDE_FLAGS="--exclude w32/ --exclude w32.9/ --exclude w64.9/ --exclude build/DEV/ --exclude build/TEST/ --exclude *.ncb --exclude *.suo --exclude *vcproj*"

echo "rsync -ltvr -e ssh --delete ${SRC}/ ${TGT}/ ${EXCLUDE_FLAGS}"
rsync -ltvr -e ssh --delete ${SRC}/ ${TGT}/ ${EXCLUDE_FLAGS}

LOCAL_HOME=/c/Users/${USER}
EXCLUDE_FLAGS="--exclude .git*"

DIR=docs/notes
SRC=${LOCAL_HOME}/$DIR
TGT=${REMOTE_BKUP_DIR}/notes
echo "rsync -ltvr -e ssh --delete ${SRC}/ ${TGT}/ ${EXCLUDE_FLAGS}"
rsync -ltvr -e ssh --delete ${SRC}/ ${TGT}/ ${EXCLUDE_FLAGS}

echo ""
echo "----------------------------------"
echo "goodbye! ʕ•ᴥ•ʔ"
echo "----------------------------------"

# DIR=log_dlj
# SRC=${LOCAL_HOME}/$DIR
# TGT=${REMOTE_BKUP_DIR}/$DIR
# echo "rsync -ltvr -e ssh --delete ${SRC}/ ${TGT}/ ${EXCLUDE_FLAGS}"
# rsync -ltvr -e ssh --delete ${SRC}/ ${TGT}/ ${EXCLUDE_FLAGS}
