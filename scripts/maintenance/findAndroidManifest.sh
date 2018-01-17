#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
find .  -name AndroidManifest.xml \
	-exec cat {} \; | grep minSdkVersion
find .  -name AndroidManifest.xml \
	-exec cat {} \; | grep targetSdkVersion
