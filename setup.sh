#!/bin/sh

# did you just clone this repo? use this script to create all the necessary shortcuts
# execute from the directory this script lives in

DIR=$PWD

cd ~

ln -s $DIR/.aliases
ln -s $DIR/.bash_profile
ln -s $DIR/.bashrc
ln -s $DIR/.funcs
ln -s $DIR/.inputrc
ln -s $DIR/.minttyrc
ln -s $DIR/.profile
ln -s $DIR/bin
ln -s $DIR/.git-completion
cp $DIR/global_gitconfig .gitconfig

cd $DIR
