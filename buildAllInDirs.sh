#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SAIDTRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildAllInDirs.sh ERROR:  Signal %s received!\\e[0m\\n" "$?"
	exit 201
}

_SAIDTRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SAIDTRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildAllInDirs.sh WARNING:  Signal %s received!\\e[0m\\n" "$?"
	_WAKEUNLOCK_
 	exit 211 
}

_SAIDTRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildAllInDirs.sh WARNING:  Quit signal %s received!\\e[0m\\n" "$?"
 	exit 221 
}

trap '_SAIDTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SAIDTRPEXIT_ EXIT
trap _SAIDTRPSIGNAL_ HUP INT TERM 
trap _SAIDTRPQUIT_ QUIT 

JID=InDirs
NUM="$(date +%s)"
WDR="$PWD"
"$HOME"/buildAPKs/pullBuildAPKsSubmodules.sh
. "$HOME/buildAPKs/scripts/shlibs/lock.sh"
_WAKELOCK_
if [ ! -e "$TMPDIR"/buildAPKsLibs ]
then
	_PRINTP_
	mkdir -p "$TMPDIR"/buildAPKsLibs 
	cd "$TMPDIR"/buildAPKsLibs 
	find "$WDR"/libs -name "*.aar" -exec ln -s {} \; 2>"$WDR"/stnderr"$NUM".log ||:
	find "$WDR"/libs  -name "*.jar" -exec ln -s {} \; 2>"$WDR"/stnderr"$NUM".log ||:
	cd "$WDR"
	 _PRINTDONE_
fi
/bin/env /bin/find "$HOME"/buildAPKs/sources/ -name AndroidManifest.xml \
	-execdir /bin/bash "$HOME/buildAPKs/buildOne.sh" "$JID" "$WDR" {} \; \
	2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
_WAKEUNLOCK_

#EOF
