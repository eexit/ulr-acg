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
SQL_SCRIPT=`pwd`/../confs/mysql/produit.sql
MYSQL_CONF=`pwd`/../confs/mysql/my.cnf
echo
echo
echo "=============================="
echo "= MySQL Configuration Script ="
echo "=============================="
echo
echo
echo "Script developped by Joris Berthelot and Laurent Le Moine Copyright (c) 2011"
echo
echo
/etc/init.d/mysqld stop
echo "Configuring mysqld...."
echo
cp -f -v $MYSQL_CONF /etc/my.cnf
chmod -R 755 /var/log
chown -R mysql:mysql /var/cluster/mysql
echo "[   ${bldblu}OK${txtrst}   ]"
echo
/etc/init.d/mysqld start
echo
read -p "Please choose a root password : " ROOT_PASSWD
mysqladmin password $ROOT_PASSWD
echo
read -p "Are you the primary node cluster (data reference)? (y/n) " -n 1 ANS
echo
if [ "y" == $ANS ]; then
	mysql -f --password=$ROOT_PASSWD < $SQL_SCRIPT
fi
echo
echo "[   ${bldblu}DONE${txtrst}   ]"
echo
