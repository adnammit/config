#!/bin/sh

# symlink all bash dotfiles to $HOME
# call with `work` param to customize env:
# ./setup.sh work

DIR=$PWD
GLOBAL_DIR=$PWD/..

cd ~

ln -s $DIR/.aliases
ln -s $DIR/.funcs
ln -s $DIR/bin
ln -s $DIR/.bash_profile
ln -s $DIR/.bashrc
ln -s $DIR/.zprofile
ln -s $DIR/.git-completion
ln -s $DIR/.minttyrc
ln -s $DIR/.profile
ln -s $DIR/.vimrc
ln -s $DIR/.ssh

if [[ $1 == "work" ]] ; then
	ln -s $DIR/.work_env #TODO: global work flag or just bash?
fi

cd $DIR
