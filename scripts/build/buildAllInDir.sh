#!/data/data/com.termux/files/usr/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail

_STRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildAllInDir.sh ERROR:  Signal $? received!\\e[0m\\n"
	exit 201
}

_STRPEXIT_() { # Run on exit.
	_CLUPA_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_STRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildAllInDir.sh WARNING:  Signal $? received!\\e[0m\\n"
 	exit 211 
}

_STRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildAllInDir.sh WARNING:  Quit signal $? received!\\e[0m\\n"
 	exit 221 
}

trap "_STRPERROR_ $LINENO $BASH_COMMAND $?" ERR 
trap _STRPEXIT_ EXIT
trap _STRPSIGNAL_ HUP INT TERM 
trap _STRPQUIT_ QUIT 

_CLUPA_() { # Run on quit.
 	rmdir "$TMPDIR"/buildAPKsLibs 2>/dev/null &
	_WAKEUNLOCK_
}
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
	printf "\033[1;32mDONE  \033[0m\n\n"
}

_PRINTP_() {
	printf "\n\033[1;34mPopulating %s/buildAPKsLibs: " "$TMPDIR"
	printf '\033]2;Populating %s/buildAPKsLibs: OK\007' "$TMPDIR"
}

_PRINTWLA_() {
	printf "\n\033[1;34mActivating termux-wake-lock: "'\033]2;Activating termux-wake-lock: OK\007'
}

_PRINTWLD_() {
	printf "\n\033[1;34mReleasing termux-wake-lock: "'\033]2;Releasing termux-wake-lock: OK\007'
}
NUM="$(date +%s)"
_WAKELOCK_
git pull 
git submodule update --init
git submodule update --init --recursive --remote
if [ ! -e "$TMPDIR"/buildAPKsLibs ]
then
	_PRINTP_
	mkdir "$TMPDIR"/buildAPKsLibs 
	cd "$TMPDIR"/buildAPKsLibs 
	find /storage/ -name "*.aar" -exec ln -s {} \; 2>"$PWD"/stnderr"$NUM".log 
	find /storage/ -name "*.jar" -exec ln -s {} \; 2>"$PWD"/stnderr"$NUM".log
	cd "$PWD"
	 _PRINTDONE_
fi
/bin/env /bin/find . -name AndroidManifest.xml -execdir /bin/bash "$PWD"/buildOne.sh "$@" {} \; 2>"$PWD"/stnderr"$NUM".log
