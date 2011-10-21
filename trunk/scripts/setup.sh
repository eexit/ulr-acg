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
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go rtfm nqqb!"
    echo
    exit 1;
fi
source ./env
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
echo << EOT
This script is about to configure and deploy a full Web active/passive cluster engine architecture. Please note that this
project is devised to work on two machines only with respectives IP addresse $UC1v4 and $UC2v4.
Feel free to change theses IP above...

What this script will do
------------------------
1. Enables needed services and installs required services
2. Creates a new Linux LVM partition for low level data replication
3. Configures, deployes and starts required services
4. Configures and start clustering engine Corosync and Pacemaker

IMPORTANT: Do not run this script on both machines in the same way! In a cluster architecture, there
is always a primary node since the architecture is active/passive. So answer "Y" when it will
ask you if you are the primary node cluster BUT ONLY IF YOU ARE. Expecially on step 2.
EOT
read -p "Press any key to continue or <CTRL> + C to abort..."
echo
echo
read -p "Which is your WAN ethernet interface? Specify ONLY the interface number: " -n 1 NUM
ETH="eth$NUM"
echo -e "\nWorking ethernet interface: $ETH"
IP=`ip addr show $ETH | grep "inet " | tail -n 1 | sed 's/\// /' | awk '{print $2}'`
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
        ifconfig $OETH $DRUC1/16
    fi
    if [ 0 -eq "`ifconfig $ETH | grep -c $UC1v6`" ]; then
        ifconfig $ETH inet6 add $UC1v6/64
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
        ifconfig $OETH $DRUC2/16
    fi
    if [ 0 -eq "`ifconfig $ETH | grep -c $UC2v6`" ]; then
        ifconfig $ETH inet6 add $UC2v6/64
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
/sbin/chkconfig --del iptables
service iptables stop # Prevents from undesired firewalling
service ntpd start # Cluster arch need to be time synced
yum remove -y -q openldap-2.4.23-4.fc14.i686 # Removes olidsh openldap
echo
echo "Installing pacemaker..."
yum -y -q install pacemaker
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing corosync..."
yum -y -q install corosync
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing drbd..."
yum install -y -q drbd drbd-pacemaker drbd-udev
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing openldap..."
yum -y -q install openldap
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing openldap-servers..."
yum -y -q install openldap-servers
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing openldap-clients..."
yum -y -q install openldap-clients
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing php-ldap, php-mysql..."
yum -y -q install php-ldap php-mysql
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing wget..."
yum -y -q install wget
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo "Installing bind..."
yum -y -q install bind bind-chroot
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo
echo
echo "Will now configure Linux LVM and low level replication..."
echo
read -p "Press any key to continue..."
/bin/sh ./drbd.sh
echo "Will now configure LDAP service..."
echo
read -p "Press any key to continue..."
/bin/sh ./ldap.sh
echo "Will now configure Bind service..."
echo
read -p "Press any key to continue..."
/bin/sh ./bind.sh
echo "Will now configure MySQL service..."
echo
read -p "Press any key to continue..."
/bin/sh ./mysql.sh
echo "Will now configure Apache service..."
echo
read -p "Press any key to continue..."
/bin/sh ./apache.sh
echo "Will now configure Pacemaker service..."
echo
read -p "Press any key to continue..."
/bin/sh ./pcmk.sh
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo "[   ${bldblu}INSTALLATION COMPLETED${txtrst}   ]"
echo
echo
echo
echo
