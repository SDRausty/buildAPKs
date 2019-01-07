#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by S D Rausty 
# Adapted from Adi Lima https://github.com/fx-adi-lima/android-tutorials
#####################################################################
set -Eeuo pipefail

_STRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[0m\\n"
	exit 201
}

_STRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_STRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs WARNING:  Signal $? received!\\e[0m\\n"
 	exit 211 
}

_STRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs WARNING:  Quit signal $? received!\\e[0m\\n"
 	exit 221 
}
now=`date +%Y%m%d%s`
trap "_STRPERROR_ $LINENO $BASH_COMMAND $?" ERR 
trap _STRPEXIT_ EXIT
trap _STRPSIGNAL_ HUP INT TERM 
trap _STRPQUIT_ QUIT 
printf "\n\e[1;38;5;116mBeginning build in %s\n" "$PWD"
if [ ! -e "./assets" ]
then
	find . -type d -name assets -exec ln -s {} \;
fi
if [ ! -e "./assets" ]
then
	mkdir ./assets
fi
if [ ! -d "./bin" ]
then
	mkdir ./bin
fi
if [ ! -d "./gen" ]
then
	mkdir ./gen
fi
if [ ! -d "./res" ]
then
	mkdir ./res
fi
if [ ! -d "./src" ] && [ -d "./java" ]
then
	ln -s java src
fi
if [ ! -d "/sdcard/Download/builtAPKs" ]
then
	mkdir /sdcard/Download/builtAPKs
fi
printf "\e[1;38;5;115m%s\n\e[0m" "aapt: begun"
aapt package -f \
	--min-sdk-version 3 \
	-M ./AndroidManifest.xml \
	-I "$PREFIX"/share/java/android.jar \
	-J gen \
	-S res \
	-m
printf "\e[1;38;5;148m%s\n\e[1;38;5;114m%s\n\e[0m" "aapt: done" "ecj: begun"
ecj -d ./obj -classpath "$PREFIX"/share/java/android.jar \
	-sourcepath . "$(find . -type f -name "*.java")"
printf "\e[1;38;5;149m%s\n\e[1;38;5;113m%s\n\e[0m" "ecj: done" "dx: begun"
dx --dex --min-sdk-version=4 --output=./bin/classes.dex ./obj
printf "\e[1;38;5;148m%s\n\e[1;38;5;112m%s\n\e[0m" "dx: done" "Making the apk."
aapt package -f \
	--min-sdk-version 3 \
	-M ./AndroidManifest.xml \
	-S ./res \
	-A ./assets \
	-F bin/step2.apk
printf "\e[1;38;5;113m%s\n\e[0m" "Adding the classes.dex to the apk."
cd bin
aapt add -f step2.apk classes.dex
printf "\e[1;38;5;114m%s\n" "Signing step2.apk"
apksigner ../step2-debug.key step2.apk ../step2.apk
sleep 1
cd ..
cp step2.apk /sdcard/Download/builtAPKs/step"$now".apk
printf "\e[1;38;5;115mCopied to /sdcard/Download/builtAPKs/step%s.apk\n" "$now"
printf "\e[1;38;5;149mYou can install it from /sdcard/Download/builtAPKs/step%s.apk\n" "$now" 
sleep 1
printf "\e[1;38;5;151m%s\n\e[0m" "Cleaning up."
rm -rf bin 
rm -rf gen 
rm -rf obj 
printf "\e[1;38;5;151mCompleted build in %s\n\n\e[0m" "$PWD"

