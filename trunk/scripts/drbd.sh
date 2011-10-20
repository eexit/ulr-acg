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
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

HERE=`pwd`
CONF_DIR=$HERE/../confs/drbd
DRBD_CONF=$CONF_DIR/drbd.conf

clear

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

echo "Creating clone partition..."
echo
echo "You need to create a new LVM partition (8E) on /dev/sdb..."
read -p "Ready?"
fdisk /dev/sdb
pvcreate /dev/sdb1
vgcreate ulr-acg /dev/sdb1
lvcreate -n drbd-www -L1G ulr-acg
lvcreate -n drbd-mysql -L1G ulr-acg
lvcreate -n drbd-ldap -L1G ulr-acg
#lvcreate -n drbd-named -L1G ulr-acg

echo
echo "[   ${bldblu}OK${txtrst}   ]"

echo "Configuring drbd..."
cp -f $DRBD_CONF /etc/
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo

echo "Building drbd resource..."
echo
drbdadm --force create-md data
modprobe drbd
drbdadm up data
echo

read -p "Is this cluster the clone data reference? (y/n) " -n 1 ANS
if [ "y" == $ANS ]; then
    drbdadm -- --overwrite-data-of-peer primary data
fi
mkfs.ext4 /dev/drbd1
mount /dev/drbd1 /mnt
echo

echo "Moving /var content to the new partition..."
mkdir -p --verbose /dev/drbd1/var/www
#mkdir -p --verbose /dev/drbd1/var/
cd /var/www
cp -ax * /dev/drbd1/var/www
cd ..
mv www www.old
mkdir www
mount /dev/drbd1/var/www /var/www
echo
echo "${warn} Please, edit your /etc/fstab and /var to /dev/drbd1"
echo
read -p "Press any key to edit the /etc/fstab file..."
vim /etc/fstab
echo
echo

