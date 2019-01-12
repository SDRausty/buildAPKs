#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init -- ./sources/top10
git submodule update --init -- ./scripts/maintenance
git submodule update --init -- ./docs
find /data/data/com.termux/files/home/buildAPKs/sources/top10 \
	-name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Top10 {} \; 2>stnderr"$(date +%s)".log
