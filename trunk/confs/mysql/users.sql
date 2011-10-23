CREATE USER 'tpuser'
IDENTIFIED BY 'tpuser';

GRANT ALL PRIVILEGES
ON *.* TO 'root'@'%';

CREATE DATABASE projet_hd;

GRANT SELECT PRIVILEGES
ON projet_hd.* TP 'tpuser'@'10.192.10.%';