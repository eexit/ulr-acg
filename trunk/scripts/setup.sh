!#/bin/sh

clear

if [ "$(whoami)" != 'root' ]; then
    echo "You have to be root user to run $0!"
    exit 1;
fi

yum -y -q install haproxy heartbeat php-ldap
ifconfig eth1 inet6 add fd00:0:c9::502/64




