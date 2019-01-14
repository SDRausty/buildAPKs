#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
cd $HOME/buildAPKs
echo Updating buildAPKs\; "\`${0##*/}\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
git pull
git submodule update --init -- ./sources/widgets
git submodule update --init -- ./scripts/maintenance
git submodule update --init -- ./docs
find $HOME/buildAPKs/sources/widgets/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Widgets {} \; \
	2>stnderr"$(date +%s)".log
"$HOME"/buildAPKs/scripts/fa.sh Widgets 

#EOF
