!#/bin/sh

HERE=`pwd`
CONF_DIR=$HERE/../confs/apache
APACHE_CONF=$CONF_DIR/g1b5.conf
SERVER_NAME=www.g1b5.tp.org
SERVER_ROOT=/var/www/org/tp/g1b5/web

if [ "`whoami`" != 'root' ]; then
    echo
    echo "You have to be root user to run $0!"
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

/etc/init.d/httpd stop

#echo "127.0.0.1     $SERVER_NAME" >> /etc/hosts
#echo "::1           $SERVER_NAME" >> /etc/hosts

if [ ! -d $SERVER_ROOT ]; then
	echo
	echo Creating Web root directory...
    mkdir -p --verbose $SERVER_ROOT
	chown -R apache:apache $SERVER_ROOT
	echo
	echo [ OK ]
fi

if [ ! -e $SERVER_ROOT/ha_state ]; then
	echo
	echo Creating Heartbeat log file
    touch $SERVER_ROOT/ha_state
    echo
	echo [ OK ]
fi

if [ -e /etc/httpd/conf.d/g1b5.conf ]; then
	cd /etc/httpd/conf.d
	LOCAL_SUM=`md5sum g1b5.conf`
	cd $HERE
	cd $CONF_DIR
	
	echo
	echo Apache conf file already exists...
	
	if [ "$LOCAL_SUM" != "`md5sum g1b5.conf`" ]; then
		echo ...but outdated... Updating Apache conf file
		echo
		cp -v $APACHE_CONF /etc/httpd/conf.d/g1b5.conf
		echo
		echo [ OK ]
	fi
	cd $HERE
	echo ...and up to date!
elif [ ! -e /etc/httpd/conf.d/g1b5.conf ]; then
	echo
	echo Creating Apache conf file...
	echo
    cp -v $APACHE_CONF /etc/httpd/conf.d/g1b5.conf
	echo
	echo [ OK ]
fi

echo
echo Staging WebApplication into Web root directory...
echo
cp -rf $HERE/../lib/webapp/* /tmp/web
find /tmp/web -name ".svn" -type d -exec rm -rf {} \;
rm -rf $SERVER_ROOT/*
mv -v /tmp/web/* $SERVER_ROOT
echo
echo [ OK ]
echo

/etc/init.d/httpd start

echo
echo

