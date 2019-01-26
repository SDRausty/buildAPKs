#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

. "$HOME/buildAPKs/scripts/shlibs/lock.bash"
_SCOTRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildCompasses.sh ERROR:  Signal %s received!\\e[0m\\n" "$?"
	exit 201
}

_SCOTRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SCOTRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildCompasses.sh WARNING:  Signal %s received!\\e[0m\\n" "$?"
	_WAKEUNLOCK_
 	exit 211 
}

_SCOTRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildCompasses.sh WARNING:  Quit signal %s received!\\e[0m\\n" "$?"
 	exit 221 
}

trap '_SCOTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SCOTRPEXIT_ EXIT
trap _SCOTRPSIGNAL_ HUP INT TERM 
trap _SCOTRPQUIT_ QUIT 

DAY="$(date +%Y%m%d)"
JID=Compasses 
NUM="$(date +%s)"
WDR="$HOME/buildAPKs/sources/${JID,,}"
cd "$HOME"/buildAPKs
mkdir -p  "$HOME"/buildAPKs/var/log
if [[ ! -f "$HOME/buildAPKs/docs/.git" ]] || [[ ! -f "$HOME/buildAPKs/scripts/maintenance/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/compasses/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/samples/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/tutorials/.git" ]]
then
	echo
	echo "Updating buildAPKs; \`${0##*/}\` might want to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script wants to download source code from https://github.com"
	cd "$HOME/buildAPKs"
	git pull
	git submodule update --init -- ./docs
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./scripts/shlibs
	git submodule update --init --recursive ./sources/compasses 
	git submodule update --init -- ./sources/samples
	git submodule update --init -- ./sources/tutorials
else
	echo
	echo "To update module ~/buildAPKs/sources/compasses to the newest version remove the ~/buildAPKs/sources/compasses/.git file and run ${0##*/} again."
fi
_WAKELOCK_
find "$HOME"/buildAPKs/sources/compasses -name AndroidManifest.xml \
	-execdir "$HOME/buildAPKs/buildOne.bash" "$JID" {} \; \
	2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd /data/data/com.termux/files/home/buildAPKs/sources/samples/android-code/Compass/
"$HOME"/buildAPKs/buildOne.bash "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd /data/data/com.termux/files/home/buildAPKs/sources/samples/Compass/
"$HOME"/buildAPKs/buildOne.bash "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
. "$RDR/scripts/shlibs/faa.bash" "$JID" "$WDR" ||:

#EOF
