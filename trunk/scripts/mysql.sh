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

$ROOT_PASSWD = "iammysqlroot"
$SQL_SCRIPT = `pwd`/../confs/mysql/produit.sql

if [ "`whoami`" != "root" ]; then
    echo
    echo -e "${warn}${warn}${warn} \aYou must be root to run $0! Go away nqqb!"
    echo
    exit 1;
fi

clear

echo
echo
echo "================"
echo "= MySQL Script ="
echo "================"
echo
echo

/etc/init.d/mysqld start

chmod -R 755 /var/log
chown -R mysql:mysql /var/lib/mysql

mysqladmin -u root password $ROOT_PASSWD

echo "Création de la base et peuplement"

mysql -f -u root --password < /home/tpuser/ulr-acg/confs/mysql/produit.sql
 

