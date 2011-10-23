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
USER_SQL_SCRIPT=`pwd`/../confs/mysql/users.sql
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
# On arrete mysqld avant de le configurer
/etc/init.d/mysqld stop
echo "Configuring mysqld...."
echo
# On remplace l'ancien fichier de configuration par le nouveau
cp -f -v $MYSQL_CONF /etc/my.cnf
# On donne l'accès à mysqld au répertoire nécessaires
chmod -R 755 /var/log
chown -R mysql:mysql /var/cluster/mysql
echo "[   ${bldblu}OK${txtrst}   ]"
echo
# On démarre mysqld
/etc/init.d/mysqld start
echo
read -p "Please choose a root password : " ROOT_PASSWD
mysqladmin password $ROOT_PASSWD
echo
echo "Creating the users...."
# On lance un script qui crée et donne des privilèges aux différents utilisateurs
mysqld -f --password=$ROOT_PASSWD < $USER_SQL_SCRIPT
echo
# Si la machine est le noeud principal, on éxécute un script qui crée la base projet_hd et la table product, puis la peuple 
read -p "Are you the primary node cluster (data reference)? (y/n) " -n 1 ANS
echo
if [ "y" == $ANS ]; then
	mysql -f --password=$ROOT_PASSWD < $SQL_SCRIPT
fi
echo
echo "[   ${bldblu}DONE${txtrst}   ]"
echo
