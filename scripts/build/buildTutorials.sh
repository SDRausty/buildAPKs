#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init -- ./sources/tutorials
git submodule update --init -- ./scripts/maintenance
git submodule update --init -- ./docs
find $HOME/buildAPKs/sources/tutorials/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Tutorials {} \; 2>stnderr"$(date +%s)".log
"$HOME"/buildAPKs/scripts/maintenance/fa.sh Tutorials 
