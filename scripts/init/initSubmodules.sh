#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update repository and initialize and update submodules. 
#####################################################################
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
if grep -q submodule .git/config ; then
    echo Found submodule init.
else
    echo Submodule init not found.
    git submodule init
    fi
