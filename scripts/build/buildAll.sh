#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeu

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

_PRINTWLA_() {
	printf "\n\033[1;34mActivating termux-wake-lock: "'\033]2;Activating termux-wake-lock: OK\007'
}

_PRINTWLD_() {
	printf "\n\033[1;34mReleasing termux-wake-lock: "'\033]2;Releasing termux-wake-lock: OK\007'
}

_WAKELOCK_
"$HOME"/buildAPKs/scripts/pullBuildAPKsSubmodules.sh
cd "$HOME"/buildAPKs/sources
find .  -name AndroidManifest.xml \
	-execdir "$HOME"/buildAPKs/buildOne.sh All {} \; 2>stnderr"$(date +%s)".log
"$HOME"/buildAPKs/scripts/maintenance/fa.sh All 
_WAKEUNLOCK_
