#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Change shebangs from Termux into Linux shebangs.
#####################################################################
find .  -name "*.sh" \
	-execdir sed -i 's/#\!\/data\/data\/com.termux\/files\/usr\/bin\/sh -e/#\!\/bin\/sh -e/g' {} \;
find .  -name "*.sh" \
	-execdir sed -i 's/#\!\/data\/data\/com.termux\/files\/usr\/bin\/sh/#\!\/bin\/sh/g' {} \;
mkdir /sdcard/Download
if [ ! -d "/sdcard/Download" ]; then
echo "You will need to adjust the destination directory for the produced APKs!"
echo "Destination directory /sdcard/Download does not exist on your system!"
fi
