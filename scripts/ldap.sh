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

CONF_DIR=`pwd`/../confs/ldap
LDAP_CONF=$CONF_DIR/ldap.conf
SLAPD_CONF=$CONF_DIR/slapd.conf
LDIF_FILE=$CONF_DIR/g1b5.ldif

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
echo "= LDAP Installer Script ="
echo "========================="
echo
echo

/etc/init.d/slapd stop

rm -Rf /etc/openldap/slapd.d

cp $LDAP_CONF /etc/openldap/ldap.conf

cp $SLAPD_CONF /etc/openldap/slapd.conf

mkdir /var/cluster/ldap

chown ldap:ldap /var/cluster/ldap

/etc/init.d/slapd start

read -p "Fill the database? (y/n) " -n 1 ANS
if [ "y" == $ANS ]; then
	echo
	ldapadd -x -D 'cn=Manager,dc=g1b5,dc=tp,dc=org' -W -f $LDIF_FILE
fi
echo

