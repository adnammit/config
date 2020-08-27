#!/bin/sh

# undoes everything setup did
# idk why, it's probably super dangerous. mostly just for testing setup

DIR=$PWD

cd ~

rm -rf .aliases
rm -rf .funcs
rm -rf bin
unlink .bash_profile
unlink .bashrc
unlink .inputrc
unlink .minttyrc
unlink .profile
unlink .git-completion
rm -f .gitconfig

cd $DIR
