#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by SDRausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SMTRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	exit 201
}

_SMTRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SMTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	_WAKEUNLOCK_
 	exit 211 
}

_SMTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SMTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SMTRPEXIT_ EXIT
trap _SMTRPSIGNAL_ HUP INT TERM 
trap _SMTRPQUIT_ QUIT 

cd "$HOME/buildAPKs"
if [[ ! -f "$HOME/buildAPKs/scripts/shlibs/.git" ]] 
then
	git submodule update --init ./scripts/shlibs
fi
JID=Entertainment		# job id/name
JI2=MyFirstAPKs			# job2 id/name
. "$HOME/buildAPKs/scripts/shlibs/mod.sh"

#EOF
