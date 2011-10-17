!#/bin/sh

CONF_DIR=`pwd`"/../confs"
APACHE_CONF=$CONF_DIR
SERVER_NAME="www.g1b5.tp.org"
SERVER_ROOT=/var/org/tp/g1b5

clear
echo "==========================="
echo "= Apache Installer Script ="
echo "==========================="
/etc/init.d/httpd stop

echo "::1   $SERVER_NAME" >> /etc/hosts
touch $SERVER_ROOT/ha_state