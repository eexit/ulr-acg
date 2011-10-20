
CREATE USER 'tpuser' IDENTIFIED BY 'tpuser';

CREATE DATABASE projet_hd;

USE projet_hd;

CREATE TABLE product 
(
	id SMALLINT NOT NULL AUTO_INCREMENT,
	name VARCHAR(30) NOT NULL,
	price SMALLINT NOT NULL,
	quantity SMALLINT NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO product(name, price, quantity) VALUES('A Games of Thrones', 10.5, 9);
INSERT INTO product(name, price, quantity) VALUES('A Clash of Kings', 10.5, 2);
INSERT INTO product(name, price, quantity) VALUES('A Storm of Swords', 10.5, 12);
INSERT INTO product(name, price, quantity) VALUES('A Feast for Crows', 10.5, 19);
INSERT INTO product(name, price, quantity) VALUES('A Dance with a Dragon', 10.5, 3);
