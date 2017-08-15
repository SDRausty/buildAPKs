#!/data/data/com.termux/files/usr/bin/sh 
# Copyright 2017 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
find .  -name .classpath -exec rm {} \;
find .  -name .project -exec rm {} \;
find .  -name proguard-project.txt -exec rm {} \;
find .  -name project.properties -exec rm {} \;
find .  -name proguard.cfg -exec rm {} \;
find .  -name makefile.linux_pc -exec rm {} \;
find .  -name makefile -exec rm {} \;
find .  -name pom.xml -exec rm {} \;
find .  -name ant.properties -exec rm {} \;
find .  -name local.properties -exec rm {} \;
find .  -name default.properties -exec rm {} \;
find .  -name build.xml -exec rm {} \;
find .  -name Android.kpf -exec rm {} \;
../scripts/purge/purgerf.sh
