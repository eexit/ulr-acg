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
CONF_DIR=$HERE/../confs/apache
APACHE_CONF=$CONF_DIR/httpd.conf
#SERVER_NAME=www.g1b5.tp.org
SERVER_ROOT=/var/cluster/www/org/tp/g1b5/web

if [ "`whoami`" != "root" ]; then
    echo
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

clear

echo
echo
echo "==========================="
echo "= Apache Installer Script ="
echo "==========================="
echo
echo

#echo "127.0.0.1     $SERVER_NAME" >> /etc/hosts
#echo "::1           $SERVER_NAME" >> /etc/hosts

if [ ! -d $SERVER_ROOT ]; then
	echo
	echo "Creating Web root directory..."
    mkdir -p --verbose $SERVER_ROOT
	chown -R apache:apache /var/cluster/www
	echo
    echo "[   ${bldblu}OK${txtrst}   ]"
fi

if [ ! -e $SERVER_ROOT/ha_state ]; then
	echo
	echo "Creating Heartbeat log file"
    #touch $SERVER_ROOT/ha_state
    echo
    echo "[   ${bldblu}OK${txtrst}   ]"
fi

if [ -e /etc/httpd/conf/httpd.conf ]; then
	cd /etc/httpd/conf
	LOCAL_SUM=`md5sum httpd.conf`
	cd $CONF_DIR
	
	echo
	echo "Apache conf file already exists..."
	
	if [ "$LOCAL_SUM" != "`md5sum httpd.conf`" ]; then
		echo "...but outdated! Updating Apache conf file"
		echo
		cp -v $APACHE_CONF /etc/httpd/conf/httpd.conf
		echo
        echo "[   ${bldblu}OK${txtrst}   ]"
	fi
	cd $HERE
	echo "...and up to date!"
else
	echo
	echo "Creating Apache conf file..."
	echo
    cp -v $APACHE_CONF /etc/httpd/conf/httpd.conf
	echo
    echo "[   ${bldblu}OK${txtrst}   ]"
fi

echo
echo "Staging WebApplication into Web root directory..."
echo
cp -ax $HERE/../lib/webapp/* $SERVER_ROOT
find $SERVER_ROOT -name ".svn" -type d -exec rm -rf {} \;
chown -R apache:apache $SERVER_ROOT
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo

/etc/init.d/httpd restart

echo
echo

