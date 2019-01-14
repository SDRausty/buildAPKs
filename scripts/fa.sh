#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Compares attempted builds with deposited compiles.. 
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_STRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs fa.sh ERROR:  Signal $? received!\\e[0m\\n"
	exit 201
}

_STRPEXIT_() { # Run on exit.
	cd $WDR
	rm -rf $TMPDIR/fa$NUM
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_STRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs fa.sh WARNING:  Signal $? received!\\e[0m\\n"
 	exit 211 
}

_STRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs fa.sh WARNING:  Quit signal $? received!\\e[0m\\n"
 	exit 221 
}

trap "_STRPERROR_ $LINENO $BASH_COMMAND $?" ERR 
trap _STRPEXIT_ EXIT
trap _STRPSIGNAL_ HUP INT TERM 
trap _STRPQUIT_ QUIT 

declare -a ARGS="$@"	## Declare arguments as string.
DAY=`date +%Y%m%d`
NUM="$(date +%s)"
WDR="$PWD"
if [[ -z "${1:-}" ]] 
then
	EXT=""
else
	EXT="$ARGS"
fi
mkdir $TMPDIR/fa$NUM
find . -name AndroidManifest.xml > $TMPDIR/fa$NUM/possible
find . -name step2.apk > $TMPDIR/fa$NUM/built
echo "  Results for $WDR"
cd $TMPDIR/fa$NUM
wc -l possible built | head -n 2 ||:
echo -n "  "
echo -n $(( $(ls -Al /sdcard/Download/builtAPKs/"$EXT$DAY"/ | wc -l) - 1 ))
echo " deposited in /sdcard/Download/builtAPKs/"$EXT$DAY"/ "
echo
