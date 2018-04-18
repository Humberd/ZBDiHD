drop table  reklama CASCADE CONSTRAINTS;
drop table  sprzedaz CASCADE CONSTRAINTS;
drop table  produkt CASCADE CONSTRAINTS;
drop table  typ_produktu CASCADE CONSTRAINTS;
drop table  typ_reklamy CASCADE CONSTRAINTS;
drop table  sklep CASCADE CONSTRAINTS;
drop table  panstwo CASCADE CONSTRAINTS;
drop table  kontynent CASCADE CONSTRAINTS;
drop table  czas CASCADE CONSTRAINTS;

create table  czas(
id_czasu NUMBER PRIMARY KEY,
miesiac NUMBER(2),
rok NUMBER(4));

create table  kontynent(
id_kontynentu NUMBER PRIMARY KEY,
nazwa VARCHAR2(30));

create table  panstwo(
id_panstwa NUMBER PRIMARY KEY,
nazwa VARCHAR2(30),
kontynent NUMBER REFERENCES  kontynent(id_kontynentu));

create table  sklep(
id_sklepu NUMBER PRIMARY KEY,
ulica VARCHAR2(30),
miejscowosc VARCHAR2(30),
wojewodztwo VARCHAR2(30),
panstwo NUMBER REFERENCES  panstwo(id_panstwa));


create table  typ_produktu(
id_typu NUMBER PRIMARY KEY,
opis VARCHAR2(30));

create table  produkt(
id_produktu NUMBER PRIMARY KEY,
nazwa VARCHAR2(30),
typ NUMBER REFERENCES  typ_produktu(id_typu));

create table  sprzedaz(
id_czasu NUMBER REFERENCES  czas(id_czasu),
id_produktu NUMBER REFERENCES  produkt(id_produktu),
id_sklepu NUMBER REFERENCES  sklep(id_sklepu),
wartosc NUMBER(12));

create table  typ_reklamy(
id_typu NUMBER PRIMARY KEY,
opis VARCHAR2(30));

create table  reklama(
id_czasu NUMBER REFERENCES  czas(id_czasu),
id_typu NUMBER REFERENCES  typ_reklamy(id_typu),
id_produktu NUMBER REFERENCES  produkt(id_produktu),
wartosc_reklamy NUMBER(10));

INSERT INTO  kontynent VALUES(1, 'Europa');
INSERT INTO  kontynent VALUES(2, 'Azja');
INSERT INTO  kontynent VALUES(3, 'Ameryka Polnocna');
INSERT INTO  kontynent VALUES(4, 'Ameryka Poludniowa');
INSERT INTO  kontynent VALUES(5, 'Afryka');
INSERT INTO  kontynent VALUES(6, 'Australia');

INSERT INTO  panstwo VALUES(1, 'Polska',1);
INSERT INTO  panstwo VALUES(2, 'Szwecja',1);
INSERT INTO  panstwo VALUES(3, 'Norwegia',1);
INSERT INTO  panstwo VALUES(4, 'Estonia',1);
INSERT INTO  panstwo VALUES(5, 'Finlandia',1);
INSERT INTO  panstwo VALUES(6, 'Lotwa',1);
INSERT INTO  panstwo VALUES(7, 'Litwa',1);
INSERT INTO  panstwo VALUES(8, 'Niemcy',1);
INSERT INTO  panstwo VALUES(9, 'Francja',1);
INSERT INTO  panstwo VALUES(10, 'Irlandia',1);
INSERT INTO  panstwo VALUES(11, 'Chiny',2);
INSERT INTO  panstwo VALUES(12, 'Indonezja',2);
INSERT INTO  panstwo VALUES(13, 'Japonia',2);
INSERT INTO  panstwo VALUES(14, 'Singapur',2);
INSERT INTO  panstwo VALUES(15, 'Australia',6);
INSERT INTO  panstwo VALUES(16, 'Kanada',3);
INSERT INTO  panstwo VALUES(17, 'USA',3);
INSERT INTO  panstwo VALUES(18, 'Meksyk',3);
INSERT INTO  panstwo VALUES(19, 'Peru',4);
INSERT INTO  panstwo VALUES(20, 'Kenia',5);

INSERT INTO  sklep VALUES(1, 'Malinowa', 'Warszawa' , 'Mazowieckie', 1);
INSERT INTO  sklep VALUES(2, 'Rybna', 'Sztokholm' , null, 2);
INSERT INTO  sklep VALUES(3, 'Fiordowa', 'Oslo' , null, 3);
INSERT INTO  sklep VALUES(4, 'Finska', 'Talin' , null, 4);
INSERT INTO  sklep VALUES(5, 'Zimna', 'Helsinki' , null, 5);
INSERT INTO  sklep VALUES(6, 'Baltycka', 'Ryga' , null, 6);
INSERT INTO  sklep VALUES(7, 'Jagielonska', 'Wilno' , null, 7);
INSERT INTO  sklep VALUES(8, 'Branderburska', 'Berlin' , null, 8);
INSERT INTO  sklep VALUES(9, 'Bagietkowa', 'Paryz' , 'Central', 9);
INSERT INTO  sklep VALUES(10, 'Zielona', 'Dublin' , null, 10);
INSERT INTO  sklep VALUES(11, 'Ryzowa', 'Pekin' , 'Mazowieckie', 11);
INSERT INTO  sklep VALUES(12, 'Tarasowa', 'Dzakarta' , 'District-1', 12);
INSERT INTO  sklep VALUES(13, 'Elektroniczna', 'Tokio' , null, 13);
INSERT INTO  sklep VALUES(14, 'Hinduska', 'Singapur' , null, 14);
INSERT INTO  sklep VALUES(15, 'Winna', 'Canberra' , null, 15);
INSERT INTO  sklep VALUES(16, 'Drzewna', 'Ottawa' , null, 16);
INSERT INTO  sklep VALUES(17, 'Prosta', 'Waszyngton' , null, 17);
INSERT INTO  sklep VALUES(18, 'Salsowa', 'Meksyk' , 'Centro', 18);
INSERT INTO  sklep VALUES(19, 'Inkowa', 'Lima' , null, 19);
INSERT INTO  sklep VALUES(20, 'Safari', 'Mombasa' , null, 20);


INSERT INTO  czas VALUES(1,1,2010);
INSERT INTO  czas VALUES(2,2,2010);
INSERT INTO  czas VALUES(3,3,2010);
INSERT INTO  czas VALUES(4,4,2010);
INSERT INTO  czas VALUES(5,5,2010);
INSERT INTO  czas VALUES(6,6,2010);
INSERT INTO  czas VALUES(7,7,2010);
INSERT INTO  czas VALUES(8,8,2010);
INSERT INTO  czas VALUES(9,9,2010);
INSERT INTO  czas VALUES(10,10,2010);
INSERT INTO  czas VALUES(11,11,2010);
INSERT INTO  czas VALUES(12,12,2010);
INSERT INTO  czas VALUES(13,1,2011);
INSERT INTO  czas VALUES(14,2,2011);
INSERT INTO  czas VALUES(15,3,2011);
INSERT INTO  czas VALUES(16,4,2011);
INSERT INTO  czas VALUES(17,5,2011);
INSERT INTO  czas VALUES(18,6,2011);
INSERT INTO  czas VALUES(19,7,2011);
INSERT INTO  czas VALUES(20,8,2011);
INSERT INTO  czas VALUES(21,9,2011);
INSERT INTO  czas VALUES(22,10,2011);
INSERT INTO  czas VALUES(23,11,2011);
INSERT INTO  czas VALUES(24,12,2011);
INSERT INTO  czas VALUES(25,1,2012);
INSERT INTO  czas VALUES(26,2,2012);
INSERT INTO  czas VALUES(27,3,2012);
INSERT INTO  czas VALUES(28,4,2012);
INSERT INTO  czas VALUES(29,5,2012);
INSERT INTO  czas VALUES(30,6,2012);
INSERT INTO  czas VALUES(31,7,2012);
INSERT INTO  czas VALUES(32,8,2012);
INSERT INTO  czas VALUES(33,9,2012);
INSERT INTO  czas VALUES(34,10,2012);
INSERT INTO  czas VALUES(35,11,2012);
INSERT INTO  czas VALUES(36,12,2012);
INSERT INTO  czas VALUES(37,1,2013);
INSERT INTO  czas VALUES(38,2,2013);
INSERT INTO  czas VALUES(39,3,2013);
INSERT INTO  czas VALUES(40,4,2013);
INSERT INTO  czas VALUES(41,5,2013);
INSERT INTO  czas VALUES(42,6,2013);
INSERT INTO  czas VALUES(43,7,2013);
INSERT INTO  czas VALUES(44,8,2013);
INSERT INTO  czas VALUES(45,9,2013);
INSERT INTO  czas VALUES(46,10,2013);
INSERT INTO  czas VALUES(47,11,2013);
INSERT INTO  czas VALUES(48,12,2013);
INSERT INTO  czas VALUES(49,9,2017);
INSERT INTO  czas VALUES(50,10,2017);
INSERT INTO  czas VALUES(51,11,2017);
INSERT INTO  czas VALUES(52,12,2017);

INSERT INTO  typ_reklamy VALUES(1, 'Billboard');
INSERT INTO  typ_reklamy VALUES(2, 'Telewizja');
INSERT INTO  typ_reklamy VALUES(3, 'Radio');
INSERT INTO  typ_reklamy VALUES(4, 'Plakat');

INSERT INTO  typ_produktu VALUES(1, 'Ksiazka');
INSERT INTO  typ_produktu VALUES(2, 'Audioksiazka');
INSERT INTO  typ_produktu VALUES(3, 'Film');
INSERT INTO  typ_produktu VALUES(4, 'Muzyka');


INSERT INTO  produkt VALUES(1, 'Slady na piasku', 1);
INSERT INTO  produkt VALUES(2, 'Straszny dziadunio', 1);
INSERT INTO  produkt VALUES(3, 'Zly', 1);
INSERT INTO  produkt VALUES(4, 'Dziennik 1954', 1);
INSERT INTO  produkt VALUES(5, 'Heban', 1);
INSERT INTO  produkt VALUES(6, 'Zly', 2);
INSERT INTO  produkt VALUES(7, 'Kamieniarz', 2);
INSERT INTO  produkt VALUES(8, 'Zart', 2);
INSERT INTO  produkt VALUES(9, 'Alchemik', 2);
INSERT INTO  produkt VALUES(10, 'Tozsamosc', 2);
INSERT INTO  produkt VALUES(11, 'Rewers', 3);
INSERT INTO  produkt VALUES(12, 'Chce sie zyc', 3);
INSERT INTO  produkt VALUES(13, 'Moj rower', 3);
INSERT INTO  produkt VALUES(14, 'Seksmisja', 3);
INSERT INTO  produkt VALUES(15, 'Vabank', 3);
INSERT INTO  produkt VALUES(16, 'Marsz Radeckiego', 4);
INSERT INTO  produkt VALUES(17, 'Aria na strune G', 4);
INSERT INTO  produkt VALUES(18, 'Mesjasz', 4);
INSERT INTO  produkt VALUES(19, 'Komeda', 4);
INSERT INTO  produkt VALUES(20, 'Morricone', 4);

INSERT INTO  reklama VALUES(1, 1, 1, 1000);
INSERT INTO  reklama VALUES(1, 1, 2, 2000);
INSERT INTO  reklama VALUES(1, 1, 3, 3000);
INSERT INTO  reklama VALUES(1, 1, 4, 5000);
INSERT INTO  reklama VALUES(1, 1, 6, 1200);
INSERT INTO  reklama VALUES(1, 1, 7, 5000);
INSERT INTO  reklama VALUES(1, 1, 8, 1200);
INSERT INTO  reklama VALUES(1, 1, 9, 1200);
INSERT INTO  reklama VALUES(2, 1, 11, 2500);
INSERT INTO  reklama VALUES(2, 1, 12, 1200);
INSERT INTO  reklama VALUES(2, 1, 13, 1800);
INSERT INTO  reklama VALUES(2, 1, 14, 5000);
INSERT INTO  reklama VALUES(2, 1, 16, 2500);
INSERT INTO  reklama VALUES(2, 1, 17, 5000);
INSERT INTO  reklama VALUES(2, 1, 18, 2500);
INSERT INTO  reklama VALUES(2, 1, 19, 2500);
INSERT INTO  reklama VALUES(2, 1, 20, 5000);
INSERT INTO  reklama VALUES(3, 2, 1, 10000);
INSERT INTO  reklama VALUES(3, 2, 2, 20000);
INSERT INTO  reklama VALUES(3, 2, 3, 30000);
INSERT INTO  reklama VALUES(3, 2, 4, 50000);
INSERT INTO  reklama VALUES(3, 2, 6, 12000);
INSERT INTO  reklama VALUES(3, 2, 7, 50000);
INSERT INTO  reklama VALUES(3, 2, 8, 12000);
INSERT INTO  reklama VALUES(3, 2, 9, 12000);
INSERT INTO  reklama VALUES(4, 2, 11, 25000);
INSERT INTO  reklama VALUES(4, 2, 12, 12000);
INSERT INTO  reklama VALUES(4, 2, 13, 18000);
INSERT INTO  reklama VALUES(4, 2, 14, 50000);
INSERT INTO  reklama VALUES(4, 2, 16, 25000);
INSERT INTO  reklama VALUES(5, 2, 17, 50000);
INSERT INTO  reklama VALUES(5, 2, 18, 25000);
INSERT INTO  reklama VALUES(5, 2, 19, 25000);
INSERT INTO  reklama VALUES(5, 2, 20, 50000);
INSERT INTO  reklama VALUES(6, 3, 11, 2500);
INSERT INTO  reklama VALUES(6, 3, 12, 1200);
INSERT INTO  reklama VALUES(7, 3, 13, 1800);
INSERT INTO  reklama VALUES(7, 3, 14, 5000);
INSERT INTO  reklama VALUES(8, 4, 16, 2500);
INSERT INTO  reklama VALUES(8, 4, 17, 5000);
INSERT INTO  reklama VALUES(8, 4, 18, 2500);
INSERT INTO  reklama VALUES(9, 4, 19, 2500);
INSERT INTO  reklama VALUES(9, 4, 20, 5000);
INSERT INTO  reklama VALUES(10, 4, 19, 2500);
INSERT INTO  reklama VALUES(10, 4, 20, 5000);
INSERT INTO  reklama VALUES(11, 4, 19, 2500);
INSERT INTO  reklama VALUES(11, 4, 20, 5000);
INSERT INTO  reklama VALUES(12, 4, 19, 2500);
INSERT INTO  reklama VALUES(12, 4, 20, 5000);
INSERT INTO  reklama VALUES(13, 4, 19, 2500);
INSERT INTO  reklama VALUES(13, 4, 20, 5000);
INSERT INTO  reklama VALUES(14, 3, 19, 2500);
INSERT INTO  reklama VALUES(14, 3, 20, 5000);
INSERT INTO  reklama VALUES(15, 3, 19, 2500);
INSERT INTO  reklama VALUES(16, 2, 20, 5000);
INSERT INTO  reklama VALUES(17, 2, 19, 2500);
INSERT INTO  reklama VALUES(18, 2, 20, 5000);
INSERT INTO  reklama VALUES(19, 4, 19, 2500);
INSERT INTO  reklama VALUES(20, 4, 20, 5000);
INSERT INTO  reklama VALUES(21, 1, 1, 1000);
INSERT INTO  reklama VALUES(22, 1, 2, 2000);
INSERT INTO  reklama VALUES(23, 1, 3, 3000);
INSERT INTO  reklama VALUES(24, 1, 4, 5000);
INSERT INTO  reklama VALUES(26, 1, 6, 1200);
INSERT INTO  reklama VALUES(27, 1, 7, 5000);
INSERT INTO  reklama VALUES(28, 1, 7, 6000);
INSERT INTO  reklama VALUES(29, 1, 7, 5000);
INSERT INTO  reklama VALUES(30, 2, 16, 25000);
INSERT INTO  reklama VALUES(31, 2, 17, 50000);
INSERT INTO  reklama VALUES(32, 2, 18, 25000);
INSERT INTO  reklama VALUES(33, 2, 19, 25000);
INSERT INTO  reklama VALUES(34, 2, 20, 50000);
INSERT INTO  reklama VALUES(36, 3, 11, 2500);
INSERT INTO  reklama VALUES(37, 3, 12, 1200);
INSERT INTO  reklama VALUES(38, 2, 4, 50000);
INSERT INTO  reklama VALUES(40, 2, 6, 12000);
INSERT INTO  reklama VALUES(41, 2, 7, 50000);
INSERT INTO  reklama VALUES(42, 2, 8, 12000);
INSERT INTO  reklama VALUES(43, 2, 9, 12000);
INSERT INTO  reklama VALUES(45, 2, 11, 25000);
INSERT INTO  reklama VALUES(46, 3, 9, 12000);
INSERT INTO  reklama VALUES(48, 2, 11, 25000);
INSERT INTO  reklama VALUES(49, 3, 9, 12000);
INSERT INTO  reklama VALUES(51, 3, 11, 18000);
INSERT INTO  reklama VALUES(52, 1, 11, 12000);

INSERT INTO  sprzedaz VALUES(1, 1, 1, 2000);
INSERT INTO  sprzedaz VALUES(1, 2, 1, 3000);
INSERT INTO  sprzedaz VALUES(1, 3, 2, 4000);
INSERT INTO  sprzedaz VALUES(1, 4, 2, 1000);
INSERT INTO  sprzedaz VALUES(2, 1, 3, 200);
INSERT INTO  sprzedaz VALUES(2, 2, 3, 300);
INSERT INTO  sprzedaz VALUES(3, 3, 4, 5000);
INSERT INTO  sprzedaz VALUES(3, 4, 4, 100);
INSERT INTO  sprzedaz VALUES(4, 1, 4, 200);
INSERT INTO  sprzedaz VALUES(4, 2, 5, 1200);
INSERT INTO  sprzedaz VALUES(5, 3, 5, 5000);
INSERT INTO  sprzedaz VALUES(5, 4, 6, 100);
INSERT INTO  sprzedaz VALUES(6, 1, 6, 2000);
INSERT INTO  sprzedaz VALUES(6, 2, 6, 3000);
INSERT INTO  sprzedaz VALUES(7, 3, 7, 5000);
INSERT INTO  sprzedaz VALUES(7, 14, 7, 100);
INSERT INTO  sprzedaz VALUES(8, 13, 8, 5000);
INSERT INTO  sprzedaz VALUES(8, 15, 9, 100);
INSERT INTO  sprzedaz VALUES(8, 16, 10, 2000);
INSERT INTO  sprzedaz VALUES(9, 17, 6, 3000);
INSERT INTO  sprzedaz VALUES(10, 18, 11, 5000);
INSERT INTO  sprzedaz VALUES(11, 19, 12, 100);
INSERT INTO  sprzedaz VALUES(12, 20, 13, 5000);
INSERT INTO  sprzedaz VALUES(13, 14, 14, 100);
INSERT INTO  sprzedaz VALUES(14, 1, 15, 2000);
INSERT INTO  sprzedaz VALUES(15, 12, 16, 3000);
INSERT INTO  sprzedaz VALUES(16, 13, 7, 5000);
INSERT INTO  sprzedaz VALUES(17, 7, 17, 100);
INSERT INTO  sprzedaz VALUES(18, 2, 7, 100);
INSERT INTO  sprzedaz VALUES(19, 14, 18, 100);
INSERT INTO  sprzedaz VALUES(20, 3, 7, 100);
INSERT INTO  sprzedaz VALUES(21, 2, 19, 100);
INSERT INTO  sprzedaz VALUES(22, 4, 7, 100);
INSERT INTO  sprzedaz VALUES(23, 4, 20, 100);
INSERT INTO  sprzedaz VALUES(24, 4, 7, 100);
INSERT INTO  sprzedaz VALUES(25, 1, 1, 2000);
INSERT INTO  sprzedaz VALUES(26, 12, 11, 3000);
INSERT INTO  sprzedaz VALUES(27, 3, 2, 4000);
INSERT INTO  sprzedaz VALUES(28, 4, 12, 1000);
INSERT INTO  sprzedaz VALUES(29, 1, 3, 2000);
INSERT INTO  sprzedaz VALUES(30, 3, 4, 50000);
INSERT INTO  sprzedaz VALUES(31, 14, 4, 1000);
INSERT INTO  sprzedaz VALUES(32, 1, 4, 200);
INSERT INTO  sprzedaz VALUES(33, 12, 5, 12000);
INSERT INTO  sprzedaz VALUES(34, 3, 15, 5000);
INSERT INTO  sprzedaz VALUES(35, 4, 6, 100);
INSERT INTO  sprzedaz VALUES(36, 1, 16, 2000);
INSERT INTO  sprzedaz VALUES(37, 12, 6, 30000);
INSERT INTO  sprzedaz VALUES(38, 13, 18, 5000);
INSERT INTO  sprzedaz VALUES(39, 15, 9, 100);
INSERT INTO  sprzedaz VALUES(40, 16, 10, 2000);
INSERT INTO  sprzedaz VALUES(41, 17, 6, 30000);
INSERT INTO  sprzedaz VALUES(42, 18, 11, 5000);
INSERT INTO  sprzedaz VALUES(43, 19, 12, 1000);
INSERT INTO  sprzedaz VALUES(44, 20, 13, 60000);
INSERT INTO  sprzedaz VALUES(45, 14, 14, 100);
INSERT INTO  sprzedaz VALUES(46, 1, 15, 2000);
INSERT INTO  sprzedaz VALUES(47, 12, 16, 3000);
INSERT INTO  sprzedaz VALUES(47, 13, 7, 1000);
INSERT INTO  sprzedaz VALUES(48, 7, 17, 6000);
INSERT INTO  sprzedaz VALUES(48, 2, 7, 3000);
INSERT INTO  sprzedaz VALUES(19, 1, 18, 100);
INSERT INTO  sprzedaz VALUES(20, 13, 7, 7000);
INSERT INTO  sprzedaz VALUES(21, 12, 19, 100);
INSERT INTO  sprzedaz VALUES(22, 14, 7, 1000);
INSERT INTO  sprzedaz VALUES(23, 14, 20, 100);
INSERT INTO  sprzedaz VALUES(24, 15, 7, 1000);
INSERT INTO  sprzedaz VALUES(49, 13, 7, 6000);
INSERT INTO  sprzedaz VALUES(50, 12, 19, 200);
INSERT INTO  sprzedaz VALUES(52, 14, 7, 5000);



commit;