#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_STRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildCompasses.sh ERROR:  Signal %s received!\\e[0m\\n" "$?"
	exit 201
}

_STRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_STRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildCompasses.sh WARNING:  Signal %s received!\\e[0m\\n" "$?"
 	exit 211 
}

_STRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildCompasses.sh WARNING:  Quit signal %s received!\\e[0m\\n" "$?"
 	exit 221 
}

trap '_STRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _STRPEXIT_ EXIT
trap _STRPSIGNAL_ HUP INT TERM 
trap _STRPQUIT_ QUIT 

_WAKELOCK_() {
	_PRINTWLA_ 
	am startservice --user 0 -a com.termux.service_wake_lock com.termux/com.termux.app.TermuxService 1>/dev/null
	_PRINTDONE_ 
}

_WAKEUNLOCK_() {
	_PRINTWLD_ 
	am startservice --user 0 -a com.termux.service_wake_unlock com.termux/com.termux.app.TermuxService 1>/dev/null
	_PRINTDONE_ 
}

_PRINTDONE_() {
	printf "\\033[1;32mDONE  \\033[0m\\n"
}

_PRINTP_() {
	printf "\\n\\033[1;34mPopulating %s/buildAPKsLibs: " "$TMPDIR"
	printf '\033]2;Populating %s/buildAPKsLibs: OK\007' "$TMPDIR"
}

_PRINTWLA_() {
	printf "\\n\\033[1;34mActivating termux-wake-lock: "'\033]2;Activating termux-wake-lock: OK\007'
}

_PRINTWLD_() {
	printf "\\n\\033[1;34mReleasing termux-wake-lock: "'\033]2;Releasing termux-wake-lock: OK\007'
}
declare -a ARGS="$@"	## Declare arguments as string.
NUM="$(date +%s)"
WDR="$PWD"
if [[ -z "${1:-}" ]] ; then
	ARGS=Flashlights
fi
_WAKELOCK_
cd "$HOME"/buildAPKs
echo Updating buildAPKs.
git pull
git submodule update --init -- ./sources/flashlights
git submodule update --init -- ./scripts/maintenance
git submodule update --init -- ./docs
find /data/data/com.termux/files/home/buildAPKs/sources/flashlights/ \
	-name AndroidManifest.xml \
	-execdir "$HOME"/buildAPKs/buildOne.sh "$ARGS" {} \; 2>"$PWD"/stnderr"$NUM".log
"$HOME"/buildAPKs/scripts/maintenance/fa.sh "$ARGS" 
