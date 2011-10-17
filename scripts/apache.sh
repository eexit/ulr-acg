!#/bin/sh

APP_NAME=g1b5
CONF_DIR=`pwd`/../confs
APACHE_CONF=$CONF_DIR/apache.conf
SERVER_NAME=www.$APP_NAME.tp.org
SERVER_ROOT=/var/www/org/tp/$APP_NAME/web

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

echo "127.0.0.1     $SERVER_NAME" >> /etc/hosts
echo "::1           $SERVER_NAME" >> /etc/hosts

if [ ! -d $SERVER_ROOT ]; then
    mkdir -p $SERVER_ROOT
fi

touch $SERVER_ROOT/ha_state
cp $APACHE_CONF /etc/httpd/conf.d/$APP_NAME.conf

/etc/init.d/httpd start

