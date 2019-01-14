#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
LCTN=MyFirstAPKs
find $HOME/buildAPKs/sources/Apps/ -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh "$LCTN" {} \; \
	2>stnderr"$(date +%s)".log

#EOF
