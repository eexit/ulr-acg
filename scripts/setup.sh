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

if [ "`whoami`" != "root" ]; then
    echo
    echo -e "${warn}${warn}${warn}\aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

UC1HOST="mamba14"
UC2HOST="mamba13"
#UC1I="eth0"
#UC2I="eth1"
UC1v4="10.192.10.24"
UC2v4="10.192.10.23"
DRUC1="10.0.0.24"
DRUC2="10.0.0.23"
UC1v6="fd00:0:c9::501"
UC2v6="fd00:0:c9::502"

# Sets env variable to configure pacemaker
export FARM_PORT="6800"
export FARM_MCAST="239.0.0.1"
export FARM_SERV_ADDR="10.192.10.0"
export FARM_ADDR="10.192.10.50"

clear

echo
echo
echo "====================="
echo "= Main Setup Script ="
echo "====================="
echo
echo
echo "Script developped by Joris Berthelot and Laurent Le Moine Copyright (c) 2011"
echo
echo
read -p "Which is your primary ethernet interface? (ethX)" -n 4 ETH
echo -e "\nWorking ethernet interface: $ETH"

IP=`ip addr show $ETH | grep "inet " | tail -n 1 | awk '{print $4}' | sed s/255/0/`

echo "Hostname: `hostname`"
echo "IP Address: $IP"

echo
echo "Hardcore configuration processing..."

if [ "eth0" == $ETH ]; then
    OETH="eth1"
else
    OETH="eth0"
fi

# Configuration for mamba14 
if [ 1 -eq "`hostname | grep -c $UC1HOST`" ]; then
    hostname $UC1HOST
    
    if [ 0 -eq "`ifconfig $OETH | grep -c $DRUC1`" ]; then
        ifconfig $OETH add $DRUC1/24
    fi
    
    if [ 0 -eq "`ifconfig $ETH | grep -c $UC1v6`" ]; then
        #ifconfig $UC1I inet6 add $UC1v6/64
    fi
    
    if [ 0 -eq "`cat /etc/hosts | grep -c $UC2HOST`" ]; then
        echo "$UC2v4        $UC2HOST" >> /etc/hosts
        echo "$DRUC2        $UC2HOST" >> /etc/hosts
        #echo "$UC2v6        $UC2HOST" >> /etc/hosts
    fi
fi

# Configuration for mamba13
if [ 1 -eq "`hostname | grep -c $UC2HOST`" ]; then
    hostname $UC2HOST
    
    if [ 0 -eq "`ifconfig $OETH | grep -c $DRUC2`" ]; then
        ifconfig $OETH add $DRUC2/24
    fi
    
    if [ 0 -eq "`ifconfig $ETH | grep -c $UC2v6`" ]; then
        #ifconfig $UC2I inet6 add $UC2v6/64
    fi
    
    if [ 0 -eq "`cat /etc/hosts | grep -c $UC1HOST`" ]; then
        echo "$UC1v4        $UC1HOST" >> /etc/hosts
        echo "$DRUC1        $UC1HOST" >> /etc/hosts
        #echo "$UC1v6        $UC1HOST" >> /etc/hosts
    fi
fi

echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo

#sed -i.bak "s/SELINUX=enforcing/SELINUX=permissive/g" /etc/selinux/config

/sbin/chkconfig --del iptables
service iptables stop

echo
echo "Installing pacemaker..."
yum -y -q install pacemaker
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Installing corosync..."
yum -y -q install corosync
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Installing drbd..."
yum install -y -q drbd-pacemaker drbd-udev
echo
echo "[   ${bldblu}OK${txtrst}   ]"
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
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Installing openldap-servers..."
yum -y -q install openldap-servers
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Installing openldap-clients..."
yum -y -q install openldap-clients
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Installing php-ldap..."
yum -y -q install php-ldap
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Installing wget..."
yum -y -q install wget
echo
echo "[   ${bldblu}OK${txtrst}   ]"




source $0
