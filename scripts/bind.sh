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
CONF_DIR=`pwd`/../confs/bind
MASTER_CONF=$CONF_DIR/named.conf
SLAVE_CONF=$CONF_DIR/named.conf.slave
ZONE_FILE="g1b5.tp.org.zone"
RV4_ZONE_FILE="rv4.g1b5.tp.org.zone"
RV6_ZONE_FILE="rv6.g1b5.tp.org.zone"
echo
echo
echo "========================="
echo "= Bind Installer Script ="
echo "========================="
echo
echo
echo "Script developped by Joris Berthelot and Laurent Le Moine Copyright (c) 2011"
echo
echo
/etc/init.d/named stop
read -p "Are you the primary name server? (y/n) " -n 1 ANS
echo
if [ "y" == $ANS ]; then
    echo "Staging primary configuration files into destroot..."
    echo
	cp -f -v $MASTER_CONF /etc/named.conf
	cp -f -v $CONF_DIR/$ZONE_FILE /etc/named/$ZONE_FILE
	cp -f -v $CONF_DIR/$RV4_ZONE_FILE /etc/named/$RV4_ZONE_FILE
	cp -f -v $CONF_DIR/$RV6_ZONE_FILE /etc/named/$RV6_ZONE_FILE
    echo "[   ${bldblu}OK${txtrst}   ]"
else
    echo "Staging slave configuration files into destroot..."
    echo
	cp -f -v $SLAVE_CONF /etc/named.conf
    echo "[   ${bldblu}OK${txtrst}   ]"
fi
echo
/etc/init.d/named start
echo
echo "[   ${bldblu}DONE${txtrst}   ]"
echo