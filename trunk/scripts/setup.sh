!#/bin/sh

UC1=10.192.10.24
UC2=10.192.10.23

clear

echo
echo
echo "====================="
echo "= Main Setup Script ="
echo "====================="
echo
echo

if [ "`whoami`" != 'root' ]; then
    echo "You have to be root user to run $0!"
    exit 1;
fi
echo
echo Configuring interfaces...
if [ 1 -eq "`ifconfig | grep -c $UC1`" ]; then
    ifconfig eth1 inet6 add fd00:0:c9::501/64
fi
if [ 1 -eq "`ifconfig | grep -c $UC2`" ]; then
    ifconfig eth1 inet6 add fd00:0:c9::502/64
fi
echo
echo [ OK ]
echo
echo Installing haproxy...
yum -y -q install haproxy
echo
echo [ OK ]
echo
echo Installing heartbeat...
yum -y -q install heartbeat
echo
echo [ OK ]
echo
echo Installing openldap...
yum -y -q install openldap
echo
echo [ OK ]
echo
echo Installing openldap-servers...
yum -y -q install openldap-servers
echo
echo [ OK ]
echo
echo Installing openldap-clients...
yum -y -q install openldap-clients
echo
echo [ OK ]
echo
echo Installing php-ldap...
yum -y -q install php-ldap
echo
echo [ OK ]
echo
