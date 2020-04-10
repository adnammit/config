#!/bin/bash

DST_BASE="//dev-lnx/home/ryman.amanda/"
DST_DIR="config"
FILES=".aliases .bash_profile .bashrc bin .funcs .profile"

a=$PWD
cd $DST_BASE
if [ ! -e $DST_DIR ]; then
    mkdir $DST_DIR
fi

DST_PATH=$DST_BASE$DST_DIR"/"

echo ""
echo ">>> copying config files to $DST_PATH"

cd ~/config

for FILE in $FILES
do
    echo "syncing file $FILE"
    if [[ -d $FILE ]] ; then
        cp -r $FILE $DST_PATH
    elif [[ -f $FILE ]] ; then
        cp $FILE $DST_PATH
    fi
done

cd $a
