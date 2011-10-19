!#/bin/sh

HERE=`pwd`
CONF_DIR=$HERE/../confs/haproxy
HAPROXY_CONF=$CONF_DIR/haproxy.cfg
HAPROXY_ROOT=/etc/haproxy

if [ "`whoami`" != "root" ]; then
    echo
    echo "You have to be root user to run $0!"
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
    echo "[ERROR] haproxy package not installed! Run setup.sh firstly..."
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
		echo "[ OK ]"
	fi
	cd $HERE
	echo "...and up to date!"
else
	echo
	echo "Creating HAProxy conf file..."
	echo
    cp -v $HAPROXY_CONF $HAPROXY_ROOT/haproxy.cfg
	echo
	echo "[ OK ]"
fi

/etc/init.d/haproxy start

echo
echo

