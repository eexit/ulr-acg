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
APACHE_CONF=$CONF_DIR/g1b5.conf
SERVER_NAME=www.g1b5.tp.org
SERVER_ROOT=/var/www/org/tp/g1b5/web

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
	chown -R apache:apache $SERVER_ROOT
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

if [ -e /etc/httpd/conf.d/g1b5.conf ]; then
	cd /etc/httpd/conf.d
	LOCAL_SUM=`md5sum g1b5.conf`
	cd $CONF_DIR
	
	echo
	echo "Apache conf file already exists..."
	
	if [ "$LOCAL_SUM" != "`md5sum g1b5.conf`" ]; then
		echo "...but outdated! Updating Apache conf file"
		echo
		cp -v $APACHE_CONF /etc/httpd/conf.d/g1b5.conf
		echo
        echo "[   ${bldblu}OK${txtrst}   ]"
	fi
	cd $HERE
	echo "...and up to date!"
else
	echo
	echo "Creating Apache conf file..."
	echo
    cp -v $APACHE_CONF /etc/httpd/conf.d/g1b5.conf
	echo
    echo "[   ${bldblu}OK${txtrst}   ]"
fi

echo
echo "Staging WebApplication into Web root directory..."
echo
cp -rf $HERE/../lib/webapp/* /tmp/web
find /tmp/web -name ".svn" -type d -exec rm -rf {} \;
rm -rf $SERVER_ROOT/*
mv -v /tmp/web/* $SERVER_ROOT
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo

cat << EOT >> /etc/httpd/conf/httpd.conf

<Location /server-status>
   SetHandler server-status
   Order deny,allow
   Deny from all
   Allow from 127.0.0.1
</Location>
EOT

/etc/init.d/httpd restart

echo
echo

