DROP TABLE f_sprzedaz;
DROP TABLE f_reklama;
DROP TABLE f_promocja;
DROP TABLE w_produkt;
DROP TABLE w_panstwo;
DROP TABLE w_sklep;
DROP TABLE w_czas;


CREATE TABLE w_produkt (
  id    NUMBER NOT NULL ENABLE,
  nazwa VARCHAR2(100),
  PRIMARY KEY (ID)
);

CREATE TABLE w_panstwo (
  id    NUMBER NOT NULL ENABLE,
  nazwa VARCHAR2(100),
  PRIMARY KEY (ID)
);

CREATE TABLE w_sklep (
  id    NUMBER NOT NULL ENABLE,
  nazwa VARCHAR2(100),
  PRIMARY KEY (ID)
);

CREATE TABLE w_czas (
  id  NUMBER NOT NULL ENABLE,
  rok NUMBER,
  PRIMARY KEY (ID)
);

CREATE TABLE f_sprzedaz (
  id         NUMBER NOT NULL ENABLE,
  id_czas    NUMBER,
  id_produkt NUMBER,
  id_panstwo NUMBER,
  kwota      NUMBER,
  PRIMARY KEY (id),
  FOREIGN KEY (id_czas) REFERENCES w_czas (id),
  FOREIGN KEY (id_produkt) REFERENCES w_produkt (id),
  FOREIGN KEY (id_panstwo) REFERENCES w_panstwo (id)
);

CREATE TABLE f_reklama (
  id           NUMBER NOT NULL ENABLE,
  id_czas      NUMBER,
  id_produkt   NUMBER,
  id_panstwo   NUMBER,
  cena         NUMBER,
  czas_trwania NUMBER,
  PRIMARY KEY (id),
  FOREIGN KEY (id_czas) REFERENCES w_czas (id),
  FOREIGN KEY (id_produkt) REFERENCES w_produkt (id),
  FOREIGN KEY (id_panstwo) REFERENCES w_panstwo (id)
);

CREATE TABLE f_promocja (
  id              NUMBER NOT NULL ENABLE,
  id_sklep        NUMBER,
  id_produkt      NUMBER,
  id_czas         NUMBER,
  liczba_promocji NUMBER,
  PRIMARY KEY (id),
  FOREIGN KEY (id_sklep) REFERENCES w_sklep (id),
  FOREIGN KEY (id_produkt) REFERENCES w_produkt (id),
  FOREIGN KEY (id_czas) REFERENCES w_czas (id)
);

-------------------------------------

CREATE SEQUENCE sek_wczas
  START WITH 1
  INCREMENT BY 1;
CREATE SEQUENCE sek_wpanstwo
  START WITH 1
  INCREMENT BY 1;
CREATE SEQUENCE sek_wprodukt
  START WITH 1
  INCREMENT BY 1;
CREATE SEQUENCE sek_wsklep
  START WITH 1
  INCREMENT BY 1;
CREATE SEQUENCE sek_fsprzedaz
  START WITH 1
  INCREMENT BY 1;
CREATE SEQUENCE sek_freklama
  START WITH 1
  INCREMENT BY 1;
CREATE SEQUENCE sek_fpromocja
  START WITH 1
  INCREMENT BY 1;
CREATE OR REPLACE TRIGGER t_id_kategorii
  BEFORE INSERT
  ON w_kategoria
  FOR EACH ROW
  BEGIN
    :new.id := sek_kategoria.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_wczas
  BEFORE INSERT
  ON w_czas
  FOR EACH ROW
  BEGIN
    :new.id := sek_wczas.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_wpanstwo
  BEFORE INSERT
  ON w_panstwo
  FOR EACH ROW
  BEGIN
    :new.id := sek_wpanstwo.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_wprodukt
  BEFORE INSERT
  ON w_produkt
  FOR EACH ROW
  BEGIN
    :new.id := sek_wprodukt.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_wsklep
  BEFORE INSERT
  ON w_sklep
  FOR EACH ROW
  BEGIN
    :new.id := sek_wsklep.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_fsprzedaz
  BEFORE INSERT
  ON f_sprzedaz
  FOR EACH ROW
  BEGIN
    :new.id := sek_fsprzedaz.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_freklama
  BEFORE INSERT
  ON f_reklama
  FOR EACH ROW
  BEGIN
    :new.id := sek_freklama.nextval;
  END;

CREATE OR REPLACE TRIGGER t_id_fpromocja
  BEFORE INSERT
  ON f_promocja
  FOR EACH ROW
  BEGIN
    :new.id := sek_fpromocja.nextval;
  END;

-------------------------------
INSERT INTO w_sklep (nazwa)
  SELECT DISTINCT s.NAZWA
  FROM SKLEP s;

INSERT INTO w_panstwo (nazwa)
  SELECT DISTINCT p.nazwa
  FROM panstwo p;

INSERT INTO w_produkt (nazwa)
  SELECT DISTINCT p.NAZWA
  FROM PRODUKT p;

INSERT INTO w_czas (rok)
  SELECT DISTINCT *
  FROM (SELECT EXTRACT(YEAR FROM z.DATA_ZAMOWIENIA)
        FROM ZAMOWIENIE z
        UNION
        SELECT EXTRACT(YEAR FROM r.DATA_OD)
        FROM REKLAMA r
        UNION
        SELECT EXTRACT(YEAR FROM p.DATA_OD)
        FROM PROMOCJA p);

INSERT INTO f_sprzedaz (id_czas, id_produkt, id_panstwo, kwota)
  SELECT
    wc.id,
    wp.id,
    wpa.id,
    SUM(sz.ILOSC * mgn.CENA)
  FROM w_czas wc, w_produkt wp, w_panstwo wpa, ZAMOWIENIE z,
    SZCZEGOLY_ZAMOWIENIA sz,
    PRODUKT p,
    KLIENT k,
    PANSTWO pn,
    MAGAZYN mgn
  WHERE EXTRACT(YEAR FROM z.DATA_ZAMOWIENIA) = wc.rok
        AND z.ID_ZAMOWIENIA = sz.ID_ZAMOWIENIA
        AND sz.ID_PRODUKTU = p.ID_PRODUKTU
        AND p.NAZWA = wp.nazwa
        AND z.ID_KLIENTA = k.ID_KLIENTA
        AND k.PANSTWO = pn.ID_PANSTWA
        AND pn.NAZWA = wpa.nazwa
        AND mgn.ID_PRODUKTU = p.ID_PRODUKTU
  GROUP BY wc.id, wp.id, wpa.id
