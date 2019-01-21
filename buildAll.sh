#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

JID=Everything 
"$HOME"/buildAPKs/pullBuildAPKsSubmodules.sh
cd "$HOME"/buildAPKs/sources
. "$HOME/buildAPKs/scripts/shlibs/mod.sh"
_WAKELOCK_
find "$HOME"/buildAPKs/sources/ -name AndroidManifest.xml \
	-execdir "$HOME/buildAPKs/buildOne.sh" "$JID" {} \; \
	2> "$HOME/buildAPKs/var/log/stnderr.build."$JID".$(date +%s).log"

#EOF
