#!/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init ./sources/compasses
git submodule update --init ./sources/tutorials
git submodule update --init ./sources/samples
find $HOME/buildAPKs/sources/compasses/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh {} \;
cd /data/data/com.termux/files/home/buildAPKs/sources/samples/android-code/Compass/
$HOME/buildAPKs/buildOne.sh
cd /data/data/com.termux/files/home/buildAPKs/sources/samples/Compass/
$HOME/buildAPKs/buildOne.sh
