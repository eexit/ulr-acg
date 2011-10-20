!#/bin/sh
# Text color variables
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}!${txtrst}

HERE=`pwd`
CONF_DIR=$HERE/../confs/haproxy
HAPROXY_CONF=$CONF_DIR/haproxy.cfg
HAPROXY_ROOT=/etc/haproxy

if [ "`whoami`" != "root" ]; then
    echo
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

clear

echo
echo
echo "============================"
echo "= HAProxy Installer Script ="
echo "============================"
echo
echo

if [ ! -d $HAPROXY_ROOT ]; then
    echo "[${bldred}ERROR${txtrst}] haproxy package not installed! Run setup.sh firstly..."
    echo
    exit 1;
fi

if [ -e $HAPROXY_ROOT/haproxy.cfg ]; then
	cd $HAPROXY_ROOT
	LOCAL_SUM=`md5sum haproxy.cfg`
	cd $CONF_DIR
	
	echo
	echo "HAProxy conf file already exists..."
	
	if [ "$LOCAL_SUM" != "`md5sum haproxy.cfg`" ]; then
		echo "...but outdated... Updating HAProxy conf file"
		echo
		cp -v $HAPROXY_CONF $HAPROXY_ROOT/haproxy.cfg
		echo
        echo "[   ${bldblu}OK${txtrst}   ]"
	fi
	cd $HERE
	echo "...and up to date!"
else
	echo
	echo "Creating HAProxy conf file..."
	echo
    cp -v $HAPROXY_CONF $HAPROXY_ROOT/haproxy.cfg
	echo
    echo "[   ${bldblu}OK${txtrst}   ]"
fi

/etc/init.d/haproxy start

echo
echo

