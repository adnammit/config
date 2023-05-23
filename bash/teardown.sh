#!/bin/sh

# undoes everything setup did -- mostly just for testing setup

DIR=$PWD

cd ~

unlink .aliases
unlink .funcs
unlink bin
unlink .bash_profile
unlink .bashrc
unlink .git-completion
unlink .minttyrc
unlink .profile
unlink .vimrc
unlink .gitconfig

if [ -f ".work_env" ] ; then
	unlink .work_env
fi

cd $DIR
