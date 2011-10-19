!#/bin/sh

CONF_DIR=`pwd`/../confs/ldap
LDAP_CONF=$CONF_DIR/ldap.conf
SLAPD_CONF=$CONF_DIR/slapd.conf
LDIF_FILE=$CONF_DIR/g1b5.ldif

if [ "`whoami`" != 'root' ]; then
    echo
    echo "You have to be root user to run $0!"
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

rm -rf /etc/openldap/slapd.d

cp $LDAP_CONF /etc/openldap/ldap.conf

cp $SLAPD_CONF /etc/openldap/slapd.conf

chown -R ldap:ldap /etc/openldap/
chown -R ldap:ldap /var/lib/ldap
chown -R ldap:ldap /var/run/openldap

/etc/init.d/slapd start

ldapadd -x -D 'cn=Manager,dc=g1b5,dc=tp,dc=org' -W -f $LDIF_FILE
 

