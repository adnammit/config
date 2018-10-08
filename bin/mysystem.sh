#!/bin/bash
clear
echo "Hello $USER!"
echo

echo "Today is `date`, this is week `date+"%V"`."
echo

echo "These users are currently connected:"
w | cut -d " " -f l - | grep -v USER | sort -u
echo

echo "This is `uname -s` running on a `uname -m` processor."
echo

echo "This is the uptime information: "
uptime
echo

echo "That's all folks!"
