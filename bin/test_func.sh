#!/bin/bash

# Can a function call another function?
function say_hello()
{
    echo "hello"
}

function make_greeting()
{
    NUM=$1
    while [[ NUM -gt 0 ]] ; do
        say_hello
        ((NUM--))
    done
}

make_greeting $1

# can you assign values to variables in an execution chain? (yep)
BAR=""
echo "foo" && BAR=$(echo "bar") && echo "BAR is $BAR"


RAR=

if [[ $RAR ]] ; then 
    echo "is RAR"
else
    echo "NOT RAR"
fi

explorer.exe *.sln