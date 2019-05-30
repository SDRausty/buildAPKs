#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SINMTRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs initm.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${3:-VALUE}" "${1:-LINENO}" "${2:-BASH_COMMAND}"
	exit 179
}

_SINMTRPEXIT_() { # Run on exit.
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SINMTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "initm.bash" "$RV"
 	exit 178 
}

_SINMTRPQUIT_() { # Run on quit.
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "initm.bash" "$RV"
 	exit 177 
}

trap '_SINMTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SINMTRPEXIT_ EXIT
trap _SINMTRPSIGNAL_ HUP INT TERM 
trap _SINMTRPQUIT_ QUIT 
export DAY="$(date +%Y%m%d)"
export JIDL="${JID,,}"	# search.string: bash variable lower case site:tldp.org
export NUM="$(date +%s)"
export RDR="$(cat $HOME/buildAPKs/var/conf/RDR)"   #  Set variable to contents of file.
export SRDR="${RDR:33}" # search.string: string manipulation site:www.tldp.org
export JDR="$RDR/sources/$JIDL"
cd "$RDR"
(git pull && git submodule update --init --recursive ./scripts/shlibs) || (echo ; echo "Cannot update: continuing...")
. "$RDR/scripts/shlibs/mod.bash"

#EOF
