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

COROSYNC_CONF="/etc/corosync/corosync.conf"

clear

echo
echo
echo "=============================="
echo "= Pacemaker Installer Script ="
echo "=============================="
echo
echo
echo "Script developped by Joris Berthelot and Laurent Le Moine Copyright (c) 2011"
echo
echo

if [ ! -d /etc/corosync ]; then
    echo -e "\a${warn}[${bldred}ERROR${txtrst}] ${txtrst}corosync package not installed! Run setup.sh firstly..."
    echo
    exit 1;
fi

echo "Configuring corosync..."
cp -f $COROSYNC_CONF.example $COROSYNC_CONF
sed -i.bak "s/.*mcastaddr:.*/mcastaddr:\ $FARM_MCAST/g" $COROSYNC_CONF
sed -i.bak "s/.*mcastport:.*/mcastport:\ $FARM_PORT/g" $COROSYNC_CONF
sed -i.bak "s/.*bindnetaddr:.*/bindnetaddr:\ $FARM_SERV_ADDR/g" $COROSYNC_CONF
cat << EOT > /etc/corosync/service.d/pcmk
service {
        # Load the Pacemaker Cluster Resource Manager
        name: pacemaker
        ver:  1
}
EOT
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo

/etc/init.d/corosync start

echo "Checking status of corosync..."
echo
if [ 4 -ge "`grep -c "[TOTEM ]" /var/log/messages`" ]; then
    echo "${info}The Corosync Cluster Engine seems to work fine."
else
    echo "${warn}An error might occurred! Take a look at your /var/log/messages log..."
fi
echo

/etc/init.d/pacemaker start

echo
echo "Configuring pacemaker services..."
echo

# Disables node isolating for failed cluster
crm configure property stonith-enabled=false
# Ignores clusters without quorum
crm configure property no-quorum-policy=ignore
# Checks the configuration
crm_verify -L
# Registers heartbeat IP state resources
crm configure primitive ClusterIP ocf:heartbeat:IPaddr2 params ip=$FARM_ADDR cidr_netmask=24 op monitor interval=5s
# Checks where the IP cluster is running on
crm resource status ClusterIP
# Registers heartbeat Apache resource
crm configure primitive WebApp ocf:heartbeat:apache params configfile=/etc/httpd/conf/httpd.conf op monitor interval=10s
# Forces the Apache and IP resources to run on the same host
crm configure colocation ulr-acg-project inf: WebApp ClusterIP
# Forces cluster to start IP resource BEFORE Apache resource when heads
crm configure order apache-after-ip inf: ClusterIP WebApp
# Registers DRBD heartbeat resource
crm cib new drbd
crm cib drbd configure primitive UlrData ocf:linbit:drbd params drbd_resource=ulr-data op monitor interval=30s
# Configures DRBD master/slave
crm cib drbd configure ms UlrDataClone UlrData meta master-max=1 master-node-max=1 clone-max=2 clone-node-max=1 notify=true
crm cib commit drbd
# Registers FS heartbeat resource
crm cib new fs
crm cib fs configure primitive FS ocf:heartbeat:Filesystem params device="/dev/drbd/by-res/ulr-data" directory="/var/cluster" fstype="ext4"
# Forces the FS resource runing on the master DRBD clone
crm cib fs configure colocation fs_on_drbd inf: FS UlrDataClone:Master
# Forces the FS to run after the DRBD has started
crm cib fs configure order FS-after-UlrData inf: UlrDataClone:promote FS:start
# Forces the Apache resource to depend on the FS
crm cib fs configure colocation WebApp-with-FS inf: WebApp FS
# Forces the Apache resource to start after the FS resource
crm cib fs configure order WebApp-after-FS inf: FS WebApp
crm cib commit fs
echo
echo

