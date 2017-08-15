#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Adapted from Adi Lima https://github.com/fx-adi-lima/android-tutorials
#####################################################################
now=`date +%Y%m%d%s`
if [ ! -d "./bin" ]; then
mkdir ./bin
fi
if [ ! -d "./assets" ]; then
mkdir ./assets
fi
if [ ! -d "./res" ]; then
mkdir ./res
fi
if [ ! -d "/sdcard/Download/builtAPKs" ]; then
mkdir /sdcard/Download/builtAPKs
fi
echo "aapt begun"
aapt package -v -f \
             -M ./AndroidManifest.xml \
             -I $PREFIX/share/java/android.jar \
             -J src \
             -S res \
             -m

echo "ecj begun"
ecj -d ./obj -classpath $HOME/../usr/share/java/android.jar \
	     -sourcepath ./app/src $(find src -type f -name "*.java")

echo "dx begun"
dx --dex --verbose --output=./bin/classes.dex ./obj

echo "Make the apk"

aapt package -v -f \
             -M ./AndroidManifest.xml \
             -S ./res \
	     -A ./assets \
             -F bin/step2.apk

echo "Add the classes.dex to the apk"
cd bin
aapt add -f step2.apk classes.dex

echo "Sign step2.apk"
apksigner ../step2-debug.key step2.apk ../step2.apk

cd ..
echo "And make it accessible to the outside world"
chmod 644 step2.apk

echo "Our Step2 app is ready to go"
cp step2.apk /sdcard/Download/builtAPKs/step2$now.apk
echo "Copied to /sdcard/Download/builtAPKs/step2$now.apk"
echo "You can install step2$now.apk from /sdcard/Download/builtAPKs/"
sleep 1
