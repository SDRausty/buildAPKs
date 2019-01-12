#!/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Update repository and update submodules.
#####################################################################
set -e 
cd "$HOME"/buildAPKs
echo Updating buildAPKs.
git pull --recurse-submodules
git submodule update --init -- ./sources/apps
git submodule update --init -- ./sources/amusements
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
