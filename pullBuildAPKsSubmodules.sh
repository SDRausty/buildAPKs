#!/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update repository and update submodules.
#####################################################################
set -e 
cd "$HOME"/buildAPKs
echo Updating buildAPKs\; "\`${0##*/}\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
git pull --recurse-submodules
git submodule update --init -- ./sources/applications
git submodule update --init -- ./sources/entertainment
git submodule update --init -- ./sources/browsers 
git submodule update --init -- ./sources/clocks
git submodule update --init -- ./sources/compasses 
git submodule update --init -- ./sources/flashlights 
git submodule update --init -- ./sources/games 
git submodule update --init -- ./sources/liveWallpapers
git submodule update --init -- ./sources/samples 
git submodule update --init -- ./sources/top10 
git submodule update --init -- ./sources/tools 
git submodule update --init -- ./sources/tutorials
git submodule update --init -- ./sources/widgets
git submodule update --init -- ./scripts/maintenance
git submodule update --init -- ./docs
