!#/bin/sh

UC1HOST="mamba14"
UC2HOST="mamba13"
UC1I="eth0"
UC2I="eth1"
UC1v4="10.192.10.24"
UC2v4="10.192.10.23"
UC1v6="fd00:0:c9::501"
UC2v6="fd00:0:c9::502"


clear

echo
echo
echo "====================="
echo "= Main Setup Script ="
echo "====================="
echo
echo

if [ "`whoami`" != "root" ]; then
    echo "You have to be root user to run $0!"
    exit 1;
fi

echo "export farm_port=6800" >> ~/.bashrc
echo "export farm_mcast=228.128.1.1" >> ~/.bashrc

echo
echo "Configuring interfaces..."
if [ 1 -eq "`ifconfig | grep -c $UC1v4`" ]; then
    hostname $UC1HOST
    ifconfig $UC1I inet6 add $UC1v6/64
    echo "export farm_addr=$UC1v4" >> ~/.bashrc
fi
if [ 1 -eq "`ifconfig | grep -c $UC2v4`" ]; then
    hostname $UC2HOST
    ifconfig $UC2I inet6 add $UC2v6/64
    echo "export farm_addr=$UC2v4" >> ~/.bashrc
fi
source ~/.bashrc
echo
echo "[ OK ]"
echo

if [ 0 -eq "`cat /etc/hosts | grep -c $UC1HOST`" ]; then
    echo "$UC1v4        $UC1HOST" >> /etc/hosts
    echo "$UC1v6        $UC1HOST" >> /etc/hosts
fi
if [ 0 -eq "`cat /etc/hosts | grep -c $UC2HOST`" ]; then
    echo "$UC2v4        $UC2HOST" >> /etc/hosts
    echo "$UC2v6        $UC2HOST" >> /etc/hosts
fi

# if [ 0 -eq "`cat /etc/sysctl.conf | grep -c net.ipv4.ip_nonlocal_bind`" ]; then
#     echo "Allows IP sharing..."
#     cat << EOT >> /etc/sysctl.conf
# 
# # Allows HAproxy shared IP
# net.ipv4.ip_nonlocal_bind = 1
# EOT
#     sysctl -p
#     echo
#     echo "[ OK ]"
# fi

#sed -i.bak "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config

/sbin/chkconfig --del iptables
service iptables stop
echo
echo "Installing pacemaker..."
yum -y -q install pacemaker
echo
echo "[ OK ]"
echo
echo "Installing corosync..."
yum -y -q install corosync
echo
echo "[ OK ]"
echo

#echo "Installing haproxy..."
#yum -y -q install haproxy
#echo
#echo "[ OK ]"
#echo
#echo "Installing heartbeat..."
#yum -y -q install heartbeat
#echo
#echo "[ OK ]"
#echo
echo "Installing openldap..."
yum -y -q install openldap
echo
echo "[ OK ]"
echo
echo "Installing openldap-servers..."
yum -y -q install openldap-servers
echo
echo "[ OK ]"
echo
echo "Installing openldap-clients..."
yum -y -q install openldap-clients
echo
echo "[ OK ]"
echo
echo "Installing php-ldap..."
yum -y -q install php-ldap
echo
echo "[ OK ]"
echo

