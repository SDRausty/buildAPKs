#!/data/data/com.termux/files/usr/bin/sh -e 
# Copyright 2017 (c) all rights reserved by
# SDRausty https://sdrausty.github.io 
# Used for reinitializing a git repository. 
# `sn.sh` should be added to your $PATH for this script to work. 
#####################################################################
mv .git/config ~/saved_git_config
rm -rf .git
git init
git add .
git commit -m "$(sn.sh)"
cp ~/saved_git_config .git/config
#git push --force origin master
