#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e
JID=MyFirstAPKs
mkdir -p  "$HOME"/buildAPKs/var/log
find "$HOME"/buildAPKs/sources/Apps/ -name AndroidManifest.xml \
	-execdir "$HOME"/buildAPKs/buildOne.sh "$JID" {} \; \
	2> "$HOME"/buildAPKs/var/log/stnderr.buildMyFirstAPKs."$(date +%s)".log
#EOF
