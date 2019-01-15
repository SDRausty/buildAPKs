#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
cd $HOME/buildAPKs
if [[ ! -f "$HOME/buildAPKs/sources/samples/.git" ]]
then
	echo
	echo "Updating buildAPKs\; \`${0##*/}\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
	git pull
	git submodule update --init -- ./sources/samples
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./docs
else
	echo
	echo "To update module ~/buildAPKs/sources/samples to the newest version remove the ~/buildAPKs/sources/samples/.git file and run ${0##*/} again."
fi

find $HOME/buildAPKs/sources/samples/helloWorlds/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh HelloWorlds {} \; 2>stnderr"$(date +%s)".log

#EOF
