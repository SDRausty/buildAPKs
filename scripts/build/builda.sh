#!/data/data/com.termux/files/usr/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Adapted from https://github.com/fx-adi-lima/android-tutorials
#####################################################################
set -e 
if [ ! -e "./bin" ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir ./bin
fi
if [ ! -e "./AndroidManifest.xml" ]; then
	find . -type f -name AndroidManifest.xml -exec ln -s {} \;
fi
if [ ! -e "./assets" ]; then
	find . -type d -name assets -exec ln -s {} \;
fi
if [ ! -e "./assets" ]; then
mkdir ./assets
fi
if [ ! -e "./res" ]; then
	find . -type d -name res -exec ln -s {} \;
fi
if [ ! -e "./src" ]; then
	find . -type d -name src -exec ln -s {} \;
fi
# create R.java
echo "aapt begun!"
aapt package -v -f \
             -M $(find . -type f -name "AndroidManifest.xml") \
	     -J $(find . -type d -name src) \
	     -S $(find . -type d -name res) \
             -m

echo "ecj begun!"
ecj -d ./obj -sourcepath . $(find . -type f -name "*.java")

echo "dx begun!"
dx --dex --verbose --output=./bin/classes.dex ./obj

echo "Making the apk."
aapt package -v -f \
             -M ./AndroidManifest.xml \
             -S ./res \
	     -A ./assets \
             -F bin/step2.apk

# Add the classes.dex to the apk.
echo "Adding the classes.dex to the apk."
cd bin
aapt add -f step2.apk classes.dex

echo "Signing the the apk."
apksigner ../step2-debug.key step2.apk ../step2.apk

cd ..
echo "Making it accessible to the outside world."
chmod 644 step2.apk

echo "Our moon app is ready to go."
cp step2.apk /sdcard/Download/moon.apk
echo "Your moon.apk was copied to /sdcard/Download/moon.apk"
echo "It is ready to be installed."
echo "Install moon.apk from /sdcard/Download/ using your file manager from Android."
