#!/bin/bash

# setup all my personal repos on a new machine
echo "Cloning and setting up command line environment"

cd ~

git clone git@github.com:adnammit/config.git
git clone git@github.com:adnammit/notes.git

# # run config setup
# cd config
# ./setup

echo "Creating /codes dir and cloning repositories"

mkdir codes
cd codes

git clone git@github.com:adnammit/website.git
git clone git@github.com:adnammit/aspdotnet6api.git
git clone git@github.com:adnammit/dockerprofiles.git
git clone git@github.com:adnammit/sandbox.git
git clone git@github.com:adnammit/vitepress-notes.git

mkdir upNext
cd upNext
git clone git@github.com:adnammit/media-client.git
git clone git@github.com:adnammit/media-database.git
git clone git@github.com:adnammit/media-service.git
cd ..

# ### optional repos:
# git clone git@github.com:adnammit/checkbookPlus.git
# git clone git@github.com:adnammit/MediumClone.git
# git clone git@github.com:adnammit/reactLogin.git
# git clone git@github.com:adnammit/vue3boilerplate-auth0.git
# git clone git@github.com:adnammit/vue3boilerplate.git
