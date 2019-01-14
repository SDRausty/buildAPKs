#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by S D Rausty 
# Adapted from Adi Lima https://github.com/fx-adi-lima/android-tutorials
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_STRPERROR_() { # Run on script error.
	local RV="$?"
	echo Signal $RV received!
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!  See \`stnderr*.log files.\`\\e[0m\\n" "${0##*/}" "$RV"
	if [[ "$RV" = 1 ]] 
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mOn Signal 1 try running %s again; This error can be resolved by running %s in a directory that has the \`AndroidManifest.xml\` file.  More information in \`stnderr*.log files.\`\\e[0m\\n" "${0##*/}" "${0##*/}"
		ls
	fi
	if [[ "$RV" = 255 ]]
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mOn Signal 255 try running %s again; This error might have been corrected by clean up.  More information in \`stnderr*.log files.\`\\e[0m\\n" "${0##*/}"
	fi
	exit 220
}

_STRPEXIT_() { # Run on exit.
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		echo Signal $RV received!  More information in \`stnderr*.log files.\`
	fi
	if [[ "$RV" = 223 ]]  
	then 
		printf "\\e[?25h\\e[1;7;38;5;0mSignal 223 generated in %s; Try running %s again; This error can be resolved by running %s in a directory that has an \`AndroidManifest.xml\` file.  More information in \`stnderr*.log files.\`\\n\\nRunning \`ls\`:\\n" "$PWD" "${0##*/}" "${0##*/}"
		ls
	fi
	sleep 1
	printf "\e[1;38;5;151m%s\\n\\e[0m" "Cleaning up."
 	rm -rf ./bin 2>/dev/null ||:  
	rm -rf ./gen 2>/dev/null ||:  
 	rm -rf ./obj 2>/dev/null ||:  
	find . -name R.java -exec rm {} \; 2>/dev/null ||:  
	printf "\e[1;38;5;151mCompleted tasks in %s\n\n\e[0m" "$PWD"
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_STRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "$?" "${0##*/}"
 	exit 221 
}

_STRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "$?" "${0##*/}"
 	exit 222 
}

trap '_STRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _STRPEXIT_ EXIT
trap _STRPSIGNAL_ HUP INT TERM 
trap _STRPQUIT_ QUIT 

DAY=`date +%Y%m%d`
NOW=`date +%Y%m%d%H%S`
if [[ -z "${1:-}" ]] 
then
	EXT=""
else
	EXT="$1"
fi
if [[ -z "${2:-}" ]] 
then
	echo "\$PWD is undefined!"
	exit 223
else
	WDR="$2"
fi
printf "\n\e[1;38;5;116mBeginning build in %s\n" "$PWD"
if [ ! -e "./assets" ]
then
	mkdir -p ./assets
fi
if [ ! -d "./bin" ]
then
	mkdir -p ./bin
fi
if [ ! -d "./gen" ]
then
	mkdir -p ./gen
fi
if [ ! -d "./obj" ]
then
	mkdir -p ./obj
fi
if [ ! -d "./res" ]
then
	mkdir -p ./res
fi
if [ ! -d "/sdcard/Download/builtAPKs/"$EXT$DAY"" ]
then
	mkdir -p -p /sdcard/Download/builtAPKs/"$EXT$DAY"
fi
printf "\e[1;38;5;115m%s\n\e[0m" "aapt: begun"
aapt package -f \
	-M ./AndroidManifest.xml \
	-J gen \
	-S res \
	-m
printf "\e[1;38;5;148m%s\n\e[1;38;5;114m%s\n\e[0m" "aapt: done" "ecj: begun"
if [ -d "$TMPDIR"/buildAPKsLibs ] && [ -d "$WDR"/libs ] # directories exist
then # loads artifacts
        ecj -d ./obj -classpath "$TMPDIR"/buildAPKsLibs:"$WDR"/libs -sourcepath . "$(find . -type f -name "*.java")"
elif [ -d "$TMPDIR"/buildAPKsLibs ]
then
        ecj -d ./obj -classpath "$TMPDIR"/buildAPKsLibs -sourcepath . "$(find . -type f -name "*.java")"
else
        ecj -d ./obj -sourcepath . "$(find . -type f -name "*.java")"
fi
printf "\e[1;38;5;149m%s\n\e[1;38;5;113m%s\n\e[0m" "ecj: done" "dx: begun"
dx --dex --output=./bin/classes.dex ./obj
printf "\e[1;38;5;148m%s\n\e[1;38;5;112m%s\n\e[0m" "dx: done" "Making the apk."
aapt package -f \
	--min-sdk-version 1 \
	--target-sdk-version 23 \
	-M ./AndroidManifest.xml \
	-S ./res \
	-A ./assets \
	-F bin/step2.apk
printf "\e[1;38;5;113m%s\n\e[0m" "Adding the classes.dex to the apk."
cd bin
aapt add -f step2.apk classes.dex
printf "\e[1;38;5;114m%s\n" "Signing step2.apk"
apksigner ../step2-debug.key step2.apk ../step2.apk
cd ..
cp step2.apk /sdcard/Download/builtAPKs/"$EXT$DAY"/step"$NOW".apk
printf "\e[1;38;5;115mCopied to /sdcard/Download/builtAPKs/"$EXT$DAY"/step%s.apk\n" "$NOW"
printf "\e[1;38;5;149mYou can install it from /sdcard/Download/builtAPKs/"$EXT$DAY"/step%s.apk\n" "$NOW" 

#EOF
