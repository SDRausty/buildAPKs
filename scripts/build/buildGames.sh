#!/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init ./sources/games
find $HOME/buildAPKs/sources/games/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Games {} \; 2>stnderr"$(date +%s)".log
