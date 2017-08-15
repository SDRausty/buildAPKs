#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Used to compare attempted builds to actual builds compiled. 
#####################################################################
find . -name AndroidManifest.xml > a
find . -name step2.apk > s
cat a s > t
sort t > u
vi a s u
