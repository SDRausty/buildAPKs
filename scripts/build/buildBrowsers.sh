#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init ./sources/browsers
find ~/buildAPKs/sources/browsers/  -name AndroidManifest.xml \
	-execdir ~/buildAPKs/scripts/build/buildOne.sh {} \;
