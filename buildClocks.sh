#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

. "$HOME/buildAPKs/scripts/shlibs/lock.sh"
_SCLTRPERROR_() { # Run on script error.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildClocks.sh ERROR:  Signal %s received!\\e[0m\\n" "$?"
	exit 201
}

_SCLTRPEXIT_() { # Run on exit.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit
}

_SCLTRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildClocks.sh WARNING:  Signal %s received!\\e[0m\\n" "$?"
	_WAKEUNLOCK_
 	exit 211 
}

_SCLTRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mbuildAPKs buildClocks.sh WARNING:  Quit signal %s received!\\e[0m\\n" "$?"
 	exit 221 
}

trap '_SCLTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SCLTRPEXIT_ EXIT
trap _SCLTRPSIGNAL_ HUP INT TERM 
trap _SCLTRPQUIT_ QUIT 

DAY="$(date +%Y%m%d)"
JID=Clocks
NUM="$(date +%s)"
WDR="$HOME/buildAPKs/sources/${JID,,}"
cd "$HOME"/buildAPKs
mkdir -p  "$HOME"/buildAPKs/var/log
if [[ ! -f "$HOME/buildAPKs/docs/.git" ]] || [[ ! -f "$HOME/buildAPKs/scripts/maintenance/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/clocks/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/livewallpapers/.git" ]] || [[ ! -f "$HOME/buildAPKs/sources/widgets/.git" ]]
then
	echo
	echo "Updating buildAPKs; \`${0##*/}\` might want to load sources from submodule repositories into buildAPKs. This may take a little while to complete. Please be patient if this script wants to download source code from https://github.com"
	cd "$HOME/buildAPKs"
	git pull
	git submodule update --init -- ./docs
	git submodule update --init -- ./scripts/maintenance
	git submodule update --init -- ./scripts/shlibs
	git submodule update --init -- ./sources/clocks
	git submodule update --init -- ./sources/livewallpapers
	git submodule update --init -- ./sources/widgets
else
	echo
	echo "To update module ~/buildAPKs/sources/clocks to the newest version remove the ~/buildAPKs/sources/clocks/.git file and run ${0##*/} again."
fi
_WAKELOCK_
find "$HOME"/buildAPKs/sources/clocks -name AndroidManifest.xml \
	-execdir "$HOME/buildAPKs/buildOne.sh" "$JID" {} \; \
	2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd "$HOME"/buildAPKs/sources/livewallpapers/android-clock-livewallpaper/
../../../buildOne.sh Clocks "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd "$HOME"/buildAPKs/sources/widgets/16-bit-clock/16-bit-clock/
../../../../buildOne.sh Clocks "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
# cd "$HOME"/buildAPKs/sources/widgets/Android-MonthCalendarWidget/
# ../../../buildOne.sh Clocks "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd "$HOME"/buildAPKs/sources/widgets/clockWidget/
../../../buildOne.sh Clocks "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd "$HOME"/buildAPKs/sources/widgets/decimal-clock-widget/decimal-clock-widget
../../../../buildOne.sh Clocks "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
cd "$HOME"/buildAPKs/sources/widgets/unix-time-clock-widget/unix-time-clock
../../../../buildOne.sh Clocks "$JID" 2> "$HOME/buildAPKs/var/log/stnderr.build.${JID,,}.$NUM.log"
_WAKEUNLOCK_
. "$RDR/scripts/shlibs/faa.bash" "$JID" "$WDR" ||:

#EOF
