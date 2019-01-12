#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init ./sources/liveWallpapers
find $HOME/buildAPKs/sources/liveWallpapers/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh LiveWallpapers {} \; 2>stnderr"$(date +%s)".log
