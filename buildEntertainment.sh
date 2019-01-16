#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SETRPERROR_() { # Run on script error.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	exit 201
}

_SETRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SETRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 211 
}

_SETRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
 	exit 221 
}

trap '_SETRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SETRPEXIT_ EXIT
trap _SETRPSIGNAL_ HUP INT TERM 
trap _SETRPQUIT_ QUIT 

JID=Entertainment # job id
JIDL="${JID,,}" # https://duckduckgo.com/?q=bash+variable+lower+case+site%3Atldp.org
SHNAME="${0##*/}" # shell script name
git submodule update --init -- ./scripts/shlibs
. "$HOME/buildAPKs/scripts/shlibs/lock.sh"
WDR="$RDR/sources/$JIDL/"
_WAKELOCK_
cd "$RDR" # Change directory to root directory.
if [[ ! -f "$RDR/sources/$JIDL/.git" ]]
then
	_PRINTUMODS_
	_UMODS_
	git submodule update --init -- ./sources/$JIDL
else
	_PRINTNMODS_
fi
find "$WDR" -name AndroidManifest.xml \
	-execdir "$RDR/buildOne.sh" "$JID" {} \; \
	2> "$RDR/var/log/stnderr.build$JID.$(date +%s).log"
. "$RDR/scripts/shlibs/fa.sh" "$JID" "$WDR"

#EOF
