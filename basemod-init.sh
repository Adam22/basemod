#!/bin/bash

######################################################################
#Description: This script install, update and populate creatuity-basemod module
#Author: Adam Tumielewicz <atumielewicz@cratuity.pl>
#Copyright 2015
#License: Creatuity Corp.
#http://creativecommons.org/licenses/by-sa/4.0/legalcode
######################################################################


PACKAGE_DIR_TREE="dist/usr/bin"
DEBIAN_DIR="dist/DEBIAN"
BASEMODREPOLINK="https://github.com/Adam22/DrupalBasicConfiguration.git"
CURRENTPATH=`pwd`
ACTION=$1
VERSION=`cat ./VERSION`
SCRIPT=`basename ${BASH_SOURCE[0]}`

function cloneBasemod {
	if ! [ -d "creatuity-basemod" ] && [$(basename `pwd`) -eq "creatuity-basemod"]; then		
		mkdir creatuity-basemod	
		cd creatuity-basemod
	fi	
	if [ -d ".git" ]; then
		echo .git exist;
	else
  		git rev-parse --git-dir 2> /dev/null;
  		git clone $BASEMODREPOLINK ./
  		git clean -df
	fi;
}

function updateBasemod {
	if [ -d ".git" ]; then
		echo .git exist;
		git pull origin master 
	else
		echo "No git repository"
		exit 1
	fi
}

function parseControlFile {
	sed -i 's/Version: [0-9]\.[0-9]/'"$VERSION"'/' ./control
}

function preparePackage {
	if  [ -d "dist" ]; then
		mkdir -p $DEBIAN_DIR
		mkdir -p $PACKAGE_DIR_TREE
		parseControlFile;
		cp basemod* dist/usr/bin/
		cp control dist/DEBIAN/
		if [[ -f "Makefile" ]]; then
			make -f Makefile
			make install Makefile
		fi
	fi
}

function createBasemodDeb {
	cloneBasemod;
	updateBasemod;	
	preparePackage;
}

function populate {
	ssh -p 8888 dev
	ssh atumielewicz
	apt-get install creatuity-basemod
}

###########################
# getopts section

OPT_A=A
OPT_B=B
OPT_C=C
OPT_D=D

#Set fonts for Help.
#NORM=`tput sgr0`
#BOLD=`tput bold`
#REV=`tput smso`

function help {
	echo -e \\n "Help documentation for ${BOLD}${SCRIPT}. ${NORM}"\\n
	echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT file.ext${NORM}"\\n
	echo "Command line switches are optional. The following switches are recognized."
	echo "${REV}-a${NORM}  --Sets the value for option ${BOLD}a${NORM}. Default is ${BOLD}A${NORM}."
	echo "${REV}-b${NORM}  --Sets the value for option ${BOLD}b${NORM}. Default is ${BOLD}B${NORM}."
	echo "${REV}-c${NORM}  --Sets the value for option ${BOLD}c${NORM}. Default is ${BOLD}C${NORM}."
	echo "${REV}-d${NORM}  --Sets the value for option ${BOLD}d${NORM}. Default is ${BOLD}D${NORM}."
	echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
	echo -e "Example: ${BOLD}$SCRIPT -a foo -b man -c chu -d bar file.ext${NORM}"\\n
	exit 1
}



while (( "$#" )); do
	case $ACTION in
		'install')
			./basemod.sh install
			;;
		'sym')
			./basemod.sh sym
			;;
		'populate-basemod')
			populate-basemod;
			;;
		'update-basemod')
			createBasemodDeb;
			;;
			*)
			help
			;;
	esac
shift
done


