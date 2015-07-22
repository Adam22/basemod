#!/bin/bash

DIR_TREE="creatuity-basemod/dist/usr/bin"
BASEMODREPOLINK="https://github.com/Adam22/DrupalBasicConfiguration.git"
CURRENTPATH=`pwd`
ACTION=$1

function cloneBasemod {
	if ! [ -d "basmode" ] && [$(basename `pwd`) -eq "basemod"]; then		
		mkdir basemod	
		cd basemod
	fi	
	if [ -d ".git" ]; then
		echo .git exist;
	else
  		git rev-parse --git-dir 2> /dev/null;
  		git clone $BASEMODREPOLINK basemod/
  		git clean -df
	fi;
}
function updateBasemod {
	if [ -d ".git" ]; then
		echo .git exist;
		git pull origin master 
	else
		echo "no git repository"
	fi
}
function preparePackage {
	if ! [ -d "creatuity-basemod" ]; then
		mkdir -p $DIR_TREE
	fi
	cd creatuity-basemod
	if [[ -d "dist" ]]; then
		if [[ -f "Makefile" ]]; then
			make -f Makefile
		fi
	fi
}

function createBasemodDeb {
	cloneBasemod;
	updateBasemod
}
while (( "$#" )); do
	case $ACTION in
		'--install-basemod')
			./basemod-test.sh
			;;
		'--update-repository')
			;;
		'--updade-basemod')
			preparePackage;
			pwd
			cat VERSION
			;;
			*)
			echo $1
			;;
	esac
shift
done