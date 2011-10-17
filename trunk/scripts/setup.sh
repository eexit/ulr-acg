!#/bin/sh

clear

if [ "$(whoami)" != 'root' ]; then
    echo "You have to be root user to run $0!"
    exit 1;
fi