#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SATRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	exit 201
}

_SATRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SATRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	_WAKEUNLOCK_
 	exit 211 
}

_SATRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

git submodule update --init --recursive ./scripts/shlibs
. "$HOME/buildAPKs/scripts/shlibs/lock.bash"
trap '_SATRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SATRPEXIT_ EXIT
trap _SATRPSIGNAL_ HUP INT TERM 
trap _SATRPQUIT_ QUIT 

JID=Everything 
NUM="$(date +%s)"
WDR="$RDR/sources"
. "$RDR/pullBuildAPKsSubmodules.bash"
cd "$HOME/buildAPKs/"
find "$RDR/sources/" -name AndroidManifest.xml \
	-execdir "$RDR/buildOne.bash" "$JID" {} \; \
	2> "$RDR/var/log/stnderr.build.${JID,,}.$NOW.log"
. "$RDR/scripts/shlibs/faa.bash" "$JID" "$WDR" ||:

#EOF
