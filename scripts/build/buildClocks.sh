#!/bin/env sh 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -e 
cd $HOME/buildAPKs
echo Updating buildAPKs.
git pull
echo "\`buildClocks.sh\` might need to load sources from 3 submodule repositories to build APKs. This may take a little while to complete. Please be patient if this script needs to download source code from https://github.com"
sleep 2
git submodule update --init ./sources/clocks
git submodule update --init ./sources/liveWallpapers
git submodule update --init ./sources/widgets
find $HOME/buildAPKs/sources/clocks/  -name AndroidManifest.xml \
	-execdir $HOME/buildAPKs/buildOne.sh {} \;
cd $HOME/buildAPKs/sources/liveWallpapers/android-clock-livewallpaper/
../../../buildOne.sh
cd $HOME/buildAPKs/sources/widgets/16-bit-clock/16-bit-clock/
../../../../buildOne.sh
cd $HOME/buildAPKs/sources/widgets/Android-MonthCalendarWidget/
../../../buildOne.sh
cd $HOME/buildAPKs/sources/widgets/clockWidget/
../../../buildOne.sh
cd $HOME/buildAPKs/sources/widgets/decimal-clock-widget/decimal-clock-widget
../../../../buildOne.sh
cd $HOME/buildAPKs/sources/widgets/unix-time-clock-widget/unix-time-clock
../../../../buildOne.sh
