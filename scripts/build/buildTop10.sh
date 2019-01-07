#!/bin/env sh
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init ./sources/top10
find /data/data/com.termux/files/home/buildAPKs/sources/top10 \
	-name AndroidManifest.xml \
	-execdir ~/buildAPKs/scripts/build/buildOne.sh {} \;
