#!/bin/bash
if [ -n "$1" ]; then
    PARAMETER=$1
else
    PARAMETER="none"
fi

CURRENTPATH=`pwd`
MODMANDIR="$CURRENTPATH/.modman"
INTCBDIR="$MODMANDIR/intcb"
INTCBREPOLINK="ssh://git@stash.creatuity.net:7999/intcb/intcb.git"
INTCBEEDIR="$MODMANDIR/intcb_ee"
INTCBEEREPOLINK="ssh://git@stash.creatuity.net:7999/intcb/intcb_ee.git"
ISEE="0"

function verifyMagentoProject {
    echo "Veryfing Magento project"
    if [ -f "$CURRENTPATH/app/Mage.php" ]; then
        echo "    Magento project confirmed"
        if [ -d "$CURRENTPATH/app/code/core/Enterprise" ]; then
		echo "    This is Magento EE project"
                ISEE="1"
	fi
    else
        echo "    Error: This is not a Magento project!"
        exit 0
    fi
}

function verifyModman {
    echo "Veryfing .modman directory"
    if [ -d "$CURRENTPATH/.modman" ]; then
        echo "    .modman directory exists"
    else
        echo "    .modman directory does not exist, attempt to create it..."
        modman init
    fi
}

function verifyIntcb {
    echo "Veryfing intcb exists in .modman directory"
    if [ -d "$INTCBDIR/.git" ]; then
        echo "    intcb repository exists in .modman directory, attempt to pull latest changes (make sure you have commited your changes, otherwise this step will fail"
        cd $INTCBDIR
        git fetch
        git checkout master
        git pull
        cd $CURRENTPATH
    else
        echo "    intcb repository does not exist in .modman directory, attempt to clone it"
        cd $MODMANDIR
        git clone $INTCBREPOLINK intcb
        cd $CURRENTPATH
    fi
}

function verifyIntcbEE {
    echo "Veryfing intcb_ee exists in .modman directory"
    if [ -d "$INTCBEEDIR/.git" ]; then
        echo "    intcb_ee repository exists in .modman directory, attempt to pull latest changes (make sure you have commited your changes, otherwise this step will fail"
        cd $INTCBEEDIR
        git fetch
        git checkout master
        git pull
        cd $CURRENTPATH
    else
        echo "    intcb_ee repository does not exist in .modman directory, attempt to clone it"
        cd $MODMANDIR
        git clone $INTCBEEREPOLINK intcb_ee
        cd $CURRENTPATH
    fi

}

function deployIntcb {
    echo "Deploying Base module to Magento project"
    cd $CURRENTPATH
    modman deploy intcb --copy --force
}

function symIntcb {
    echo "Symlinking Base module to Magento project"
    cd $CURRENTPATH
    modman deploy intcb --force
}

function deployIntcbEE {
    echo "Deploying Base EE module to Magento project"
    cd $CURRENTPATH
    modman deploy intcb_ee --copy --force
}

function symIntcbEE {
    echo "Symlinking Base EE module to Magento project"
    cd $CURRENTPATH
    modman deploy intcb_ee --force
}

if [ $PARAMETER == "install" ]; then
    verifyMagentoProject
    verifyModman
    verifyIntcb
    deployIntcb
    if [ "$ISEE" == "1" ]; then
        verifyIntcbEE
        deployIntcbEE
    fi
else
    if [ $PARAMETER == "sym" ]; then
        verifyMagentoProject
        verifyModman
        verifyIntcb
        symIntcb
        if [ "$ISEE" == "1" ]; then
            verifyIntcbEE
            symIntcbEE
        fi
    else
        echo "Use 'basemod install' to install/update latest Base module files in your Magento project"
        echo "Use 'basemod sym' to symlink latest Base module files in your Magento project"
        echo "If your Magento project is EE, module Base EE will be installed/updated also."
    fi
fi

