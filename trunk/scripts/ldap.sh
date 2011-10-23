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
CONF_DIR=`pwd`/../confs/ldap
LDAP_CONF=$CONF_DIR/ldap.conf
SLAPD_CONF=$CONF_DIR/slapd.conf
LDIF_FILE=$CONF_DIR/g1b5.ldif
echo
echo
echo "========================="
echo "= LDAP Installer Script ="
echo "========================="
echo
echo
echo "Script developped by Joris Berthelot and Laurent Le Moine Copyright (c) 2011"
echo
echo
/etc/init.d/slapd stop
echo "Configuring slapd...."
echo
rm -Rf /etc/openldap/slapd.d
cp -v -f $LDAP_CONF /etc/openldap/ldap.conf
cp -v -f $SLAPD_CONF /etc/openldap/slapd.conf

if [ ! -d /var/cluster/ldap ]; then
    mkdir -p --verbose /var/cluster/ldap
fi
chown ldap:ldap /var/cluster/ldap
echo
echo "[   ${bldblu}OK${txtrst}   ]"
echo
/etc/init.d/slapd start
echo
echo
read -p "Are you the primary node cluster (data reference)? (y/n) " -n 1 ANS
if [ "y" == $ANS ]; then
	echo
	ldapadd -x -D 'cn=Manager,dc=g1b5,dc=tp,dc=org' -W -f $LDIF_FILE
    echo "[   ${bldblu}OK${txtrst}   ]"
    echo
fi
echo
echo "[   ${bldblu}DONE${txtrst}   ]"
echo
