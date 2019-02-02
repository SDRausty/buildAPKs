#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SINITRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs init.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${3:-unknown}" "${1:-unknown}" "${2:-command}"
	exit 179
}

_SINITRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SINITRPSIGNAL_() { # Run on signal.
	local RV="$?"
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 178 
}

_SINITRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "init.bash" "$RV"
 	exit 177 
}

trap '_SINITRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SINITRPEXIT_ EXIT
trap _SINITRPSIGNAL_ HUP INT TERM 
trap _SINITRPQUIT_ QUIT 

export DAY="$(date +%Y%m%d)"
JIDL="${JID,,}"	# search.string: bash variable lower case site:tldp.org
NUM="$(date +%s)"
RDR="$HOME/buildAPKs"
SRDR="${RDR:33}" # search.string: string manipulation site:www.tldp.org
WDR="$RDR/sources/$JIDL"
. "$RDR/buildAPKs/scripts/shlibs/lock.bash" ||:
cd "$RDR"
git pull # TODO: offline option 
git submodule update --init --recursive ./scripts/shlibs # ditto
. "$HOME/buildAPKs/scripts/shlibs/lock.bash" # TODO: short job option
# . "$HOME/buildAPKs/scripts/shlibs/mod.bash" # TODO: long job option
#EOF
