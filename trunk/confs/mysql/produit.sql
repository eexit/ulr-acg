
CREATE USER "tpuser"@"localhost";
SET PASSWORD FOR "tpuser"@"localhost" = password("tpuser");

CREATE DATABASE projet_hd;

USE projet_hd;

CREATE TABLE produit 
(
	id INT NOT NULL AUTO_INCREMENT,
	nom VARCHAR NOT NULL,
	prix INT NOT NULL,
	quantite INT NOT NULL,
	PRIMARY KEY id
);

INSERT INTO produit VALUES();
