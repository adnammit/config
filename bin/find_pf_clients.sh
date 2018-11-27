#!/bin/bash

a=$PWD
cd ~/dev/

CLIENTS=
FILE_NAME=process_flow_request.pls
GIT_ROOT=$(git rev-parse --show-toplevel)
FILES=$(find $GIT_ROOT -name $FILE_NAME)
PATH_STR=

for FILE in $FILES
do
    PATH_STR=$(dirname $FILE)
    PATH_STR=$(echo ${PATH_STR##*/})
    CLIENTS=$CLIENTS" "$PATH_STR
done

CLIENTS=$(echo $CLIENTS | sort | uniq)

for CLIENT in $CLIENTS
do
    echo $CLIENT
done

cd $a
