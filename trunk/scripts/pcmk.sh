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
CONF_DIR=$HERE/../confs
PCMK_CONF=$CONF_DIR/crm
COROSYNC_CONF="/etc/corosync/corosync.conf"
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
    echo -e "\a${warn}[${bldred}ERROR${txtrst}] corosync package not installed! Run setup.sh firstly..."
    echo
    exit 1;
fi
if [ 4 -ne "`env | grep -c FARM`" ]; then
    echo -e "\a${warn}[${bldred}ERROR${txtrst}] Be sure the env file was well sourced: source ./env"
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
echo
/etc/init.d/pacemaker start
echo
echo "Configuring pacemaker services..."
echo
crm configure load replace $PCMK_CONF
crm configure commit
echo
echo "[   ${bldblu}DONE${txtrst}   ]"
echo