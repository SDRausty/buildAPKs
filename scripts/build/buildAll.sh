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
cd "$HOME"/buildAPKs
echo Updating buildAPKs.
git submodule update --init -- ./sources/apps
git submodule update --init -- ./sources/amusements
git submodule update --init -- ./sources/browsers 
git submodule update --init -- ./sources/clocks
git submodule update --init -- ./sources/compasses 
git submodule update --init -- ./sources/flashlights 
git submodule update --init -- ./sources/games 
git submodule update --init -- ./sources/liveWallpapers
git submodule update --init -- ./sources/samples 
git submodule update --init -- ./sources/top10 
git submodule update --init -- ./sources/tools 
git submodule update --init -- ./sources/tutorials
git submodule update --init -- ./sources/widgets
cd "$HOME"/buildAPKs/sources
find .  -name AndroidManifest.xml \
	-execdir "$PWD"/buildOne.sh {} \; 2>stnderr"$(date +%s)".log
_WAKEUNLOCK_
