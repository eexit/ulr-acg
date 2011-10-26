CONNECT projet_hd;

CREATE TABLE product (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    price SMALLINT NOT NULL,
    quantity SMALLINT NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO product(name, price, quantity) VALUES(
    ('A Games of Thrones', 11, 9),
    ('A Clash of Kings', 11, 2),
    ('A Storm of Swords', 11, 12),
    ('A Feast for Crows', 11, 19),
    ('A Dance with a Dragon', 11, 3)
);