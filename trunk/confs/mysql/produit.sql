
CREATE USER "tpuser";
SET PASSWORD FOR "tpuser" = password("tpuser");

CREATE DATABASE projet_hd;

USE projet_hd;

CREATE TABLE produit 
(
	id SMALLINT NOT NULL AUTO_INCREMENT,
	nom VARCHAR(30) NOT NULL,
	prix SMALLINT NOT NULL,
	quantite SMALLINT NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO produit(nom, prix, quantite) VALUES('A Games of Thrones', 10.5, 9);
INSERT INTO produit(nom, prix, quantite) VALUES('A Clash of Kings', 10.5, 2);
INSERT INTO produit(nom, prix, quantite) VALUES('A Storm of Swords', 10.5, 12);
INSERT INTO produit(nom, prix, quantite) VALUES('A Feast for Crows', 10.5, 19);
INSERT INTO produit(nom, prix, quantite) VALUES('A Dance with a Dragon', 10.5, 3);
