#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by SDRausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SETRPERROR_() { # Run on script error.
	local RV="$?"
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs %s ERROR:  Signal %s received!\\e[0m\\n" "${0##*/}" "$RV"
	set +Eeuo pipefail 
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
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
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
JID=InDir
NUM="$(date +%s)"
WDR="$PWD"
_WAKELOCK_

find "$@" -name AndroidManifest.xml \
	-execdir /bin/bash "$HOME/buildAPKs/buildOne.sh" "$JID" "$WDR" {} \; \
	2> "$WDR/stnderr.build.${JID,,}.$NUM.log"
exit $?
#	SEARCH: LOWERCASE BASH VARIABLE PATTERN REPLACEMENT SUBSTITUTION SITE:TLDP.ORG
#	http://www.tldp.org/LDP/abs/html/bashver4.html#CASEMODPARAMSUB
#EOF
