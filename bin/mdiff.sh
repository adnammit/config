#!/bin/bash

#===========================================================================
#
# MDIFF
#    For all your Mega and Multiple diffing purposes
#
# Uses and Stupidities:
#    This is for when you have a common file and it turns out there are a million more of the boogers
#    in custom client code. Gah, if only you didn't have to diff through a billion files...
#    But wait -- mdiff is here to help.
#
#    Spits the output into a file in ~/mdiff_output (or another dir of your choosing).
#    You can also output to the screen instead.
#    For now this only works if the file is in common or one of it's subdirs.
#
#   Usage
#         $ mdiff [OPTIONS] [FILENAME]


# TO DO:
# - provide an optional second arg for the output directory
# - provide flag for screen output
# - add diff -y
# - are any of the files the same?
# - change it so that the file it recieves is the 'common' file (since some files do not have a common version)

a=$PWD
FILENAME="$1"
DIRNAME="mdiff_output"
DIR="~/$DIRNAME" #necessary?

# remove the extension from the filename
NAME=${FILENAME%.*}   # split on '.'
NAME=${NAME,,}        # lowercase
OUTPUT="found_$NAME.txt"

echo "finding $FILENAME..."

# make the directory if it doesnt' already exist
cd ~
mkdir -p "$DIRNAME"

#if [ ! -d "$DIRNAME" ]
#then
#    mkdir "$DIRNAME"
#    echo "created dir $DIRNAME"
#else
#    echo "dir $DIRNAME already existed"
#fi

ZAT="~/$DIRNAME/$OUTPUT"

# look for all files of FILENAME and output them into a file
cd ~/rel/dat

echo "saving $OUTPUT in ${ZAT} pwd is $PWD"

#find -name "$FILENAME" > '$ZAT' # this doesn't work -- whyyyyy?
find -name "$FILENAME" > ../../$DIRNAME/$OUTPUT

echo "printed found files to $OUTPUT"

cd ~/$DIRNAME

# find the common one so we can compare everything else to it
####CHANGE TO WHILE LOOP
for LINE in $(cat $OUTPUT)
do
    if [[ "$LINE" == *"/common/"* ]]
    then
	BASE=${LINE%/*}
    fi
done

COM="$BASE/$FILENAME"

cd ~/rel/dat

# now diff away!
echo "comparing $COM...."
NUM=1
for FILE in $(cat "../../$DIRNAME/$OUTPUT")
do
    echo -e "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "[$NUM] $FILE:"
    echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    diff $COM $FILE
    echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo -e "\n\n"
    NUM=$((NUM + 1))
done




# are any of them the same?


# take us home.
cd $a
