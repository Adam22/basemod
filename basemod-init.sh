#!/bin/bash

DIR_TREE="creatuity-basemod/dist/usr/bin"
BASEMODREPOLINK="https://github.com/Adam22/DrupalBasicConfiguration.git"
CURRENTPATH=`pwd`
ACTION=$1

function cloneBasemod {
	if ! [ -d "basmode" ]; then		
		mkdir basemod
	fi
	cd basemod	
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

case $ACTION in
	'--install')
		./basemod-test.sh
		;;
	'--populate')
		;;
	'--build-deb')
		preparePackage;
		pwd
		cat VERSION
		;;
	'--updade')
		;;
esac
