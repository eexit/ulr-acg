!#/bin/sh

HERE=`pwd`
CONF_DIR=$HERE/../confs/ha
HA_CONF=$CONF_DIR/ha.cf
HA_ROOT=/etc/ha.d

if [ "`whoami`" != "root" ]; then
    echo
    echo "You have to be root user to run $0!"
    echo
    exit 1;
fi

clear

echo
echo
echo "======================="
echo "= HA Installer Script ="
echo "======================="
echo
echo

if [ ! -d $HA_ROOT ]; then
    echo "[ERROR] heartbeat package not installed! Run setup.sh firstly..."
    echo
    exit 1;
fi

if [ -e $HA_ROOT/authkeys ]; then
    cd $HA_ROOT
    LOCAL_SUM=`md5sum authkeys`
    cd $CONF_DIR
    
    echo
    echo "Heartbeat conf file already exists..."
    
    if [ "$LOCAL_SUM" != "`md5sum authkeys`" ]; then
		echo "...but outdated... Updating Heartbeat conf file"
		echo
		cp -v $CONF_DIR/authkeys $HA_ROOT/authkeys
		chmod 600 $HA_ROOT/authkeys
		echo
		echo "[ OK ]"
	fi
	cd $HERE
	echo "...and up to date!"
else
	echo
	echo "Creating Heartbeat conf file..."
	echo
    cp -v $CONF_DIR/authkeys $HA_ROOT/authkeys
    chmod 600 $HA_ROOT/authkeys
	echo
	echo "[ OK ]"
fi


echo
echo

