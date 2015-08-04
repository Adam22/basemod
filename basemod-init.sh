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

OPT_I=I
OPT_S=S
OPT_P=P
OPT_U=U

#Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

function help {
	echo -e \\n "Help documentation for ${BOLD}${SCRIPT}. ${NORM}"\\n
	echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT file.ext${NORM}"\\n
	echo "Command line switches are optional. The following switches are recognized."
	echo "${REV}-i${NORM}  --Install basemod in magento project ${BOLD}a${NORM}. Default is ${BOLD}A${NORM}."
	echo "${REV}-s${NORM}  --Symlink basemod to magento project ${BOLD}b${NORM}. Default is ${BOLD}B${NORM}."
	echo "${REV}-p${NORM}  --Populate basemod to developer workstations ${BOLD}c${NORM}. Default is ${BOLD}C${NORM}."
	echo "${REV}-u${NORM}  --Sets the value for option ${BOLD}d${NORM}. Default is ${BOLD}D${NORM}."
	echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
	echo -e "Example: ${BOLD}$SCRIPT -a foo -b man -c chu -d bar"\\n
	exit 1
}

NUMARGS=$#
echo -e \\n"Number of arguments: $NUMARGS"
if [ $NUMARGS -eq 0 ]; then
  help
fi

while getopts :a:b:c:d:h FLAG; do
  case $FLAG in
    a)  #set option "a"
      OPT_A=$OPTARG
      echo "-a used: $OPTARG"
      echo "OPT_A = $OPT_A"
      ;;
    b)  #set option "b"
      OPT_B=$OPTARG
      echo "-b used: $OPTARG"
      echo "OPT_B = $OPT_B"
      ;;
    c)  #set option "c"
      OPT_C=$OPTARG
      echo "-c used: $OPTARG"
      echo "OPT_C = $OPT_C"
      ;;
    d)  #set option "d"
      OPT_D=$OPTARG
      echo "-d used: $OPTARG"
      echo "OPT_D = $OPT_D"
      ;;
    h)  #show help
      help
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      help
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      #echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      #exit 2
      ;;
  esac
done

while (( "$#" )); do
	case $ACTION in
		'install')
			#./basemod.sh install
			echo "install"
			;;
		'sym')
			#./basemod.sh sym
			echo "sym"
			;;
		'populate-basemod')
			#populate-basemod;
			echo "populate-basemod"
			;;
		'update-basemod')
			#reateBasemodDeb;
			echo "update-basemod"
			;;
		'help')
			help
			;;
			*)
			
			;;
	esac
shift
done


