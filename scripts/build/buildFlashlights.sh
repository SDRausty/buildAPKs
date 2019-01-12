#!/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init ./sources/flashlights
find /data/data/com.termux/files/home/buildAPKs/sources/flashlights/ \
	-name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Flashlights {} \; 2>stnderr"$(date +%s)".log
