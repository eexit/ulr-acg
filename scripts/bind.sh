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

CONF_DIR=`pwd`/../confs/bind
MASTER_CONF=$CONF_DIR/named.conf
SLAVE_CONF=$CONF_DIR/named.conf.slave
ZONE_FILE=$CONF_DIR/g1b5.tp.org.zone
RV4_ZONE_FILE=$CONF_DIR/rv4.g1b5.tp.org.zone
RV6_ZONE_FILE=$CONF_DIR/rv6.g1b5.tp.org.zone

if [ "`whoami`" != "root" ]; then
    echo
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

clear

echo
echo
echo "========================="
echo "= BIND Installer Script ="
echo "========================="
echo
echo

/etc/init.d/named stop

read -p "Are you the DNS master? (y/n) " -n 1 ANS
if [ "y" == $ANS ]; then
	cp -f $MASTER_CONF /etc/named.conf
	cp -f $CONF_DIR/$ZONE_FILE /etc/named/$ZONE_FILE
	cp -f $CONF_DIR/$RV4_ZONE_FILE /etc/named/$RV4_ZONE_FILE
	cp -f $CONF_DIR/$RV6_ZONE_FILE /etc/named/$RV6_ZONE_FILE
else
	cp -f $SLAVE_CONF /etc/named.conf
fi

/etc/init.d/named start


