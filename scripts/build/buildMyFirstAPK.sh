#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs/sources/moon
$HOME/buildAPKs/scripts/build/buildOne.sh 2>stnderr"$(date +%s)".log
