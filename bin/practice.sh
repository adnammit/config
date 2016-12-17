#!/bin/bash

FILE="$1"

if [ -f "$FILE" ]
then
    echo "filename $FILE exists"
else
    echo "filename $FILE doesn't exist"
fi
