#!/bin/bash

clear

echo "Hello, $USER. The script is starting now!"

COLOR="black"
echo "Here is a color: $COLOR"
echo 
echo

message="so $USER, let's play a game called Fizz-Buzz!"
echo $message

#here is a 'for' loop:
for number in {1..100}
do
# output:
    output=""
    
# if the number is divisible by three (if modulus == 0), add fizz to the output:
    if [ $((number%3)) -eq 0 ] ; then 
	output="FIZZZZZ"
    fi

# if the number is divisible by five, add buzz to the output: 
    if [ $((number%5)) -eq 0 ] ; then
	output="${output}BUZZZZZZZZZZZ"
    fi

# otherwise 
    if [ -z $output ]; then 
	echo $number
    else
	echo $output;
    fi
    
done






