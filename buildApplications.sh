#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
NUM="$(date +%s)"
WDR="$PWD"
JID=Applications
if [[ ! -z "${1:-}" ]]
then
	JID="$@"
fi
cd "$HOME"/buildAPKs
if [[ ! -f "$HOME/buildAPKs/sources/applications/.git" ]]
then
	echo
	echo "Updating buildAPKs\; \`${0##*/}\` might need to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
	git pull
	git submodule update --init -- ./docs
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./scripts/shlibs
	git submodule update --init -- ./sources/applications
else
	echo
	echo "To update module ~/buildAPKs/sources/applications to the newest version remove the ~/buildAPKs/sources/applications/.git file and run ${0##*/} again."
fi

find "$HOME"/buildAPKs/sources/applications -name AndroidManifest.xml \
	-execdir "$HOME/buildAPKs/buildOne.sh" "$JID" {} \; \
	2> "$HOME/buildAPKs/var/log/stnderr.build$JID.$NUM.log"

#EOF
