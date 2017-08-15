#return just the names of the registered submodules
grep path .gitmodules | sed 's/.*= //'
#The following command will list the submodules:
git submodule--helper list
#Just run the following to initialise all submodule.
git submodule update --init --recursive
