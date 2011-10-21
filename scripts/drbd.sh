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
HERE=`pwd`
CONF_DIR=$HERE/../confs/drbd
DRBD_CONF=$CONF_DIR/drbd.conf
echo
echo
echo "========================="
echo "= DRBD Installer Script ="
echo "========================="
echo
echo
echo "Script developped by Joris Berthelot and Laurent Le Moine Copyright (c) 2011"
echo
echo
if [ ! -e /etc/drbd.conf ]; then
    echo -e "\a[${bldred}ERROR${txtrst}] drbd package not installed! Run setup.sh firstly..."
    echo
    exit 1;
fi
echo "Creation of Linux LVM (8E) physical primary partion..."
echo
read -p "Manage the /dev/sdb device to create a partition..."
read -p "Ready?"
fdisk /dev/sdb
echo "[   ${bldblu}OK${txtrst}   ]"
echo
if [ 0 -eq "`pvdisplay | grep -c "/dev/sdb1"`" ]; then
    pvcreate /dev/sdb1
fi
if [ 0 -eq "`vgdisplay | grep -c "ulr-acg"`" ]; then
    vgcreate ulr-acg /dev/sdb1
fi
if [ 0 -eq "`lvs | grep -c "ulr-data"`" ]; then
    lvcreate -n ulr-data -L1G ulr-acg
fi
echo "[   ${bldblu}OK${txtrst}   ]"
echo "Configuring drbd..."
echo
cp -v -f $DRBD_CONF /etc/
echo "[   ${bldblu}OK${txtrst}   ]"
echo
echo "Building drbd resource..."
echo
drbdadm --force create-md ulr-data
modprobe drbd
drbdadm up ulr-data
echo "[   ${bldblu}OK${txtrst}   ]"
echo
read -p "Are you the primary node cluster (data reference)? (y/n) " -n 1 ANS
if [ "y" == $ANS ]; then
    drbdadm -- --overwrite-data-of-peer primary ulr-data
	mkfs.ext4 /dev/drbd1
	echo "[   ${bldblu}OK${txtrst}   ]"
else
	drbdadm secondary ulr-data
	echo "[   ${bldblu}OK${txtrst}   ]"
fi
echo
mount /dev/drbd1 /var/cluster
if [ ! -d /var/cluster ]; then
	mkdir -p /var/cluster/mysql
    mkdir /var/cluster/www
    mkdir /var/cluster/ldap
    chmod -R 755 /var/cluster
    chown mysql:mysql /var/cluster/mysql
    chown ldap:ldap /var/cluster/ldap
    chown apache:apache /var/cluster/www
fi
echo
read -p "${warn} Edit your /etc/fstab and set the mount point /var/cluster to /dev/drbd1. Want to edit right now? (y/n) " -n 1 ANS
if [ "y" == $ANS ]; then
	vim /etc/fstab
fi
echo
echo "[   ${bldblu}DONE${txtrst}   ]"
echo
