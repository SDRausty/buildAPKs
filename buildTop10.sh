#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
cd $HOME/buildAPKs
if [[ ! -f "$HOME/buildAPKs/sources/top10/.git" ]]
then
	echo
	echo "Updating buildAPKs\; \`${0##*/}\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
	git pull
	git submodule update --init -- ./sources/top10
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./docs
else
	echo
	echo "To update module ~/buildAPKs/sources/top10 to the newest version remove the ~/buildAPKs/sources/top10/.git file and run ${0##*/} again."
fi

find /data/data/com.termux/files/home/buildAPKs/sources/top10 \
	-name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh Top10 {} \; 2>stnderr"$(date +%s)".log

#EOF
