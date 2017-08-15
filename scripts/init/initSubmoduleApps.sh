#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update repository and initialize and update submodules. 
#####################################################################
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init -- ./sources/apps
