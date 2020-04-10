#!/bin/bash
# Backup my current dev branch, notes and config in case my computer
#   finally eats it.

USER=ryman.amanda

LOCAL_HOME=/c/UserData/${USER}
REMOTE_BKUP_DIR=${USER}@dev-lnx.portland.perflogic.com:/home/${USER}/win_backups

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

sync_configuration.sh

show_me_a_robot.sh
