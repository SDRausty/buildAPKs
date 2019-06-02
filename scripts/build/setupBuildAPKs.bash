#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by S D Rausty 
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SUPTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh ERROR:  Signal $RV received!\\e[0m\\n"
	printf "\\e[?25h\\e[0m\\n"
	exit 201
}

_SUPTRPEXIT_() { # Run on exit.
	local RV="$?"
	sleep 0.04
	if [[ "$RV" = 0 ]] ; then
		printf "\\a\\e[1;7;38;5;155m%s %s \\a\\e[0m\\e[1;34m: \\a\\e[1;32m%s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "DONE 🏁 "
		printf "\\e]2; %s: %s \\007" "${0##*/} $ARGS" "DONE 🏁 "
	else
		printf "\\a\\e[1;7;38;5;88m%s %s \\a\\e[0m\\e[1;34m: \\a\\e[1;32m%s %s\\e[0m\\n\\n\\a\\e[0m" "${0##*/}" "$ARGS" "[Exit Signal $RV]" "DONE 🏁 "
		printf "\033]2; %s: %s %s \\007" "${0##*/} $ARGS" "[Exit Signal $RV]" "DONE 🏁 "
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SUPTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh WARNING:  Signal $RV received!\\e[0m\\n"
 	exit 211 
}

_SUPTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs setupBuildAPKs.sh WARNING:  Quit signal $RV received!\\e[0m\\n"
 	exit 221 
}

trap '_SUPTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SUPTRPEXIT_ EXIT
trap _SUPTRPSIGNAL_ HUP INT TERM 
trap _SUPTRPQUIT_ QUIT 
declare -a ARGS="$@"	## Declare arguments as string.
if [[ -z "${1:-}" ]]
then
	ARGS=""
fi
printf "\n\e[1;38;5;116m%s\n" "Beginning buildAPKs setup"
declare COMMANDIF=""
COMMANDIF="$(command -v au)" ||:
if [[ "$COMMANDIF" = au ]] 
then 
	au aapt apksigner dx ecj4.6 findutils git
else
	pkg install aapt apksigner dx ecj4.6 findutils git
fi
cd "$HOME"
git clone https://github.com/sdrausty/buildAPKs
./buildAPKs/buildEntertainment.bash

#EOF
