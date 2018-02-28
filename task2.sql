CREATE TABLE Position
(
  id   NUMBER(6)     NOT NULL,
  name VARCHAR2(100) NOT NULL UNIQUE,
  PRIMARY KEY (id)
);

CREATE TABLE Speciality
(
  id   NUMBER(6)     NOT NULL,
  name VARCHAR2(100) NOT NULL UNIQUE,
  PRIMARY KEY (id)
);

CREATE TABLE Worker
(
  id            NUMBER(6) NOT NULL,
  name          VARCHAR2(100),
  surname       VARCHAR2(100),
  birthday      DATE,
  salary        NUMBER(10),
  position_id   NUMBER(6) NOT NULL,
  speciality_id NUMBER(6) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (position_id) REFERENCES Position (id),
  FOREIGN KEY (speciality_id) REFERENCES Speciality (id)
);

CREATE SEQUENCE generate_worker_id
  INCREMENT BY 1
  START WITH 1
  NOCYCLE;

CREATE SEQUENCE generate_position_id
  INCREMENT BY 1
  START WITH 1
  NOCYCLE;

CREATE SEQUENCE generate_speciality_id
  INCREMENT BY 1
  START WITH 1
  NOCYCLE;

CREATE OR REPLACE PACKAGE table_migrator AS
  PROCEDURE migrate_tables;
END;

CREATE OR REPLACE PACKAGE BODY table_migrator
AS
  PROCEDURE migrate_tables
  AS
    BEGIN
      FOR i IN (SELECT DISTINCT t.POSITION
                FROM TEMP t) LOOP
        INSERT INTO Position VALUES (generate_position_id.nextval, i.POSITION);
      END LOOP;

      FOR i IN (SELECT DISTINCT t.SPECIALITY
                FROM TEMP t) LOOP
        INSERT INTO Speciality VALUES (generate_speciality_id.nextval, i.SPECIALITY);
      END LOOP;
    END migrate_tables;
END table_migrator;

CALL table_migrator.migrate_tables()