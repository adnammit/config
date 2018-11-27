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
