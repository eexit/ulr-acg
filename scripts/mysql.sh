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

ROOT_PASSWD="iammysqlroot"
SQL_SCRIPT=`pwd`/../confs/mysql/produit.sql
MYSQL_CONF=`pwd`/../confs/mysql/my.cnf

if [ "`whoami`" != "root" ]; then
    echo
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

clear

echo
echo
echo "=============================="
echo "= MySQL Configuration Script ="
echo "=============================="
echo $MYSQL_CONF
echo

/etc/init.d/mysqld stop



cp -f $MYSQL_CONF /etc/my.cnf

chmod -R 755 /var/log
chown -R mysql:mysql /var/cluster/mysql

/etc/init.d/mysqld start

mysqladmin -u root password $ROOT_PASSWD

echo "Création de la base et peuplement"

mysql -f -u root --password < $SQL_SCRIPT
 

