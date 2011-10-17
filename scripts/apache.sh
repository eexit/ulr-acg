!#/bin/sh

CONF_DIR=`pwd`/../confs
APACHE_CONF=$CONF_DIR/apache.conf
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
    mkdir -p $SERVER_ROOT
fi

if [ ! -e $SERVER_ROOT/ha_state ]; then
    touch $SERVER_ROOT/ha_state
fi

if [(! -e /etc/httpd/conf.d/g1b5.conf) -o ("`md5sum $APACHE_CONF`" != "`md5sum /etc/httpd/conf.d/g1b5.conf`")]; then
    cp $APACHE_CONF /etc/httpd/conf.d/g1b5.conf
fi

/etc/init.d/httpd start

