#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved by
# SDRausty https://sdrausty.github.io 
# Used for reinitializing a git repository. 
# `sn.sh` should be added to your $PATH for this script to work. 
#####################################################################
find . -type f -exec chmod 600 {} \;
find . -type d -exec chmod 700 {} \;
