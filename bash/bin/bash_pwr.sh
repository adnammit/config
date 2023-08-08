#!/bin/sh

# TODO: use this or loose this

# use for opening powershell scripts in bash -- tranforms path to the right thing
#   cygwin expects a path like         /cygdrive/c/Windows/System32/WindowsPowerShell/v1.0
#   but powershell is all like          /c/WINDOWS/System32/WindowsPowerShell/v1.0/powershell.exe

if [ ! -f "$1" ]; then
    exec "$(command -v pwsh.exe || command -v powershell.exe)" "$@"
    exit $?
fi

script="$(cygpath -w "$1")"
shift

if command -v pwsh.exe > /dev/null; then
    exec pwsh.exe "$script" "$@"
else
    exec powershell.exe -File "$script" "$@"
fi