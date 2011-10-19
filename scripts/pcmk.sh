!#/bin/sh

if [ "`whoami`" != "root" ]; then
    echo
    echo "You have to be root user to run $0!"
    echo
    exit 1;
fi

clear

echo
echo
echo "=============================="
echo "= Pacemaker Installer Script ="
echo "=============================="
echo
echo

if [ ! -d /etc/corosync ]; then
    echo "[ERROR] corosync package not installed! Run setup.sh firstly..."
    echo
    exit 1;
fi

echo "Configuring corosync..."
cp -f /etc/corosync/corosync.conf.example /etc/corosync/corosync.conf
sed -i.bak "s/.*mcastaddr:.*/mcastaddr:\ $farm_mcast/g" /etc/corosync/corosync.conf
sed -i.bak "s/.*mcastport:.*/mcastport:\ $farm_port/g" /etc/corosync/corosync.conf
sed -i.bak "s/.*bindnetaddr:.*/bindnetaddr:\ $farm_addr/g" /etc/corosync/corosync.conf

cat << EOT >> /etc/corosync/service.d/pcmk
service {
        # Load the Pacemaker Cluster Resource Manager
        name: pacemaker
        ver:  1
}
EOT
echo
echo "[ OK ]"
echo

/etc/init.d/corosync start

echo
echo

