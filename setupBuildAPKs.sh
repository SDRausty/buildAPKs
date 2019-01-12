#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by S D Rausty 
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
VERSIONID="v1.2"

_STRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh ERROR:  Signal $? received!\\e[0m\\n"
	printf "\\e[?25h\\e[0m\\n"
	exit 201
}

_STRPEXIT_() { # Run on exit.
	local RV="$?"
	sleep 0.04
	if [[ "$RV" = 0 ]] ; then
		printf "\\a\\e[1;7;38;5;155m%s %s \\a\\e[0m$VERSIONID\\e[1;34m: \\a\\e[1;32m%s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "DONE 🏁 "
		printf "\\e]2; %s: %s \\007" "${0##*/} $ARGS" "DONE 🏁 "
	else
		printf "\\a\\e[1;7;38;5;88m%s %s \\a\\e[0m$VERSIONID\\e[1;34m: \\a\\e[1;32m%s %s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "[Exit Signal $RV]" "DONE 🏁 "
		printf "\033]2; %s: %s %s \\007" "${0##*/} $ARGS" "[Exit Signal $RV]" "DONE 🏁 "
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_STRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh WARNING:  Signal $? received!\\e[0m\\n"
 	exit 211 
}

_STRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh WARNING:  Quit signal $? received!\\e[0m\\n"
 	exit 221 
}

trap "_STRPERROR_ $LINENO $BASH_COMMAND $?" ERR 
trap _STRPEXIT_ EXIT
trap _STRPSIGNAL_ HUP INT TERM 
trap _STRPQUIT_ QUIT 

printf "\n\e[1;38;5;116m%s\n" "Beginning buildAPKs setup"
pkg install aapt apksigner dx ecj findutils git
cd && git clone https://github.com/sdrausty/buildAPKs
./buildAPKs/scripts/build/buildMyFirstAPK.sh
