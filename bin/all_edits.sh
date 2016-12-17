#!/bin/bash

#replace "sartor.james" with 2015 to see everyone's edits this year

cd RCS
find . -name  "*,v" ! -name "version.txt,v" | xargs awk '/date/ && /2016/ {print $2 "     "  FILENAME}' | sort -k1 
cd ..
