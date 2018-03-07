CREATE TABLE w_czas (
  id      NUMBER NOT NULL ENABLE,
  miesiac NUMBER NOT NULL ENABLE,
  rok     NUMBER NOT NULL ENABLE,
  PRIMARY KEY (id)
);

CREATE TABLE w_kategoria (
  id    NUMBER       NOT NULL ENABLE,
  nazwa VARCHAR(100) NOT NULL ENABLE,
  PRIMARY KEY (id)
);

CREATE TABLE w_lokalizacja (
  id   NUMBER       NOT NULL ENABLE,
  stan VARCHAR(100) NOT NULL ENABLE,
  PRIMARY KEY (id)
);

CREATE TABLE f_sprzedaz (
  id               NUMBER NOT NULL ENABLE,
  id_w_czas        NUMBER,
  id_w_kategoria   NUMBER,
  id_w_lokalizacja NUMBER,
  PRIMARY KEY (id),
  FOREIGN KEY (id_w_czas) REFERENCES w_czas (id),
  FOREIGN KEY (id_w_kategoria) REFERENCES w_kategoria (id),
  FOREIGN KEY (id_w_lokalizacja) REFERENCES w_lokalizacja (id)
);

-------------------
CREATE SEQUENCE sek_kategoria
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER t_id_kategorii
  BEFORE INSERT
  ON w_kategoria
  FOR EACH ROW
  BEGIN
    :new.id := sek_kategoria.nextval;
  END;


INSERT INTO w_kategoria (nazwa)
  SELECT DISTINCT b.category
  FROM books b;
------------------
CREATE SEQUENCE sek_lokalizacja
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER t_id_lokalizacji
  BEFORE INSERT
  ON w_lokalizacja
  FOR EACH ROW
  BEGIN
    :new.id := sek_lokalizacja.nextval;
  END;

INSERT INTO w_lokalizacja (stan)
  SELECT DISTINCT o.SHIPSTATE
  FROM ORDERS o;
-----------------
CREATE SEQUENCE sek_czas
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER t_id_czas
  BEFORE INSERT
  ON w_czas
  FOR EACH ROW
  BEGIN
    :new.id := sek_czas.nextval;
  END;

INSERT INTO w_czas (rok, miesiac)
  SELECT DISTINCT
    EXTRACT(YEAR FROM o.ORDERDATE),
    EXTRACT(MONTH FROM o.ORDERDATE)
  FROM ORDERS o;
--------------------
CREATE SEQUENCE sek_sprzedaz
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER t_id_sprzedaz
  BEFORE INSERT
  ON f_sprzedaz
  FOR EACH ROW
  BEGIN
    :new.id := sek_sprzedaz.nextval;
  END;

INSERT INTO f_sprzedaz (id_w_czas, id_w_kategoria, id_w_lokalizacja)
