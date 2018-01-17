#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
find .  -name AndroidManifest.xml \
	-exec cat {} \; | grep minSdkVersion
find .  -name AndroidManifest.xml \
	-exec cat {} \; | grep minSdkVersion
	#-execdir sed -i '/minSdkVersion/c\\tandroid\:minSdkVersion\=\"14\"' {} \;
        #android:targetSdkVersion="27" />
	#-execdir /buildAPKs/scripts/build/buildOne.sh {} \;
