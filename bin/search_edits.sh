#!/bin/bash

#replace "sartor.james" with 2015 to see everyone's edits this year


 
if[ $1 == "-r" ]
then
    find -L . -name  "*,v" ! -name "version.txt,v" | xargs awk '/date/ && /ryman/ {print $2 "     "  FILENAME}' | sort -k1 
else      
    cd RCS
    find . -name  "*,v" ! -name "version.txt,v" | xargs awk '/date/ && /ryman/ {print $2 "     "  FILENAME}' | sort -k1 
    cd ..      
fi


