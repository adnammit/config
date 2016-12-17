#!/bin/bash

rm -i "$1"
cd RCS
mkdir -p obsolete
mv -i "$1,v" obsolete
cd ..
