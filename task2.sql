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
  birth_date    VARCHAR2(100),
  email         VARCHAR2(100),
  hire_date     VARCHAR2(100),
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

-- table_migrator
CREATE OR REPLACE PACKAGE table_migrator AS
  PROCEDURE migrate_tables;

  FUNCTION calculate_mean_salary(position_name Position.name%TYPE)
    RETURN NUMBER;
END;

-- migrate_tables
CREATE OR REPLACE PACKAGE BODY table_migrator
AS
  PROCEDURE migrate_tables AS
    BEGIN
      -- TEMP -> Position
      FOR i IN (SELECT DISTINCT t.POSITION
                FROM TEMP t) LOOP
        INSERT INTO Position VALUES (generate_position_id.nextval, i.POSITION);
      END LOOP;

      -- TEMP -> Speciality
      FOR i IN (SELECT DISTINCT t.SPECIALITY
                FROM TEMP t) LOOP
        INSERT INTO Speciality VALUES (generate_speciality_id.nextval, i.SPECIALITY);
      END LOOP;

      -- TEMP -> Worker
      FOR i IN (SELECT
                  t.name,
                  t.surname,
                  t.BIRTH,
                  t.email,
                  t.hire_date,
                  t.salary,
                  t.POSITION,
                  t.SPECIALITY
                FROM TEMP t) LOOP
        INSERT INTO Worker
        VALUES (generate_worker_id.nextval,
                i.NAME,
                i.SURNAME,
                i.BIRTH,
                i.EMAIL,
                i.HIRE_DATE,
                i.SALARY,
                (SELECT p.id
                 FROM Position p
                 WHERE p.name = i.POSITION),
                (SELECT s.id
                 FROM Speciality s
                 WHERE s.name = i.SPECIALITY));
      END LOOP;

      EXCEPTION
      WHEN OTHERS
      THEN NULL;
    END migrate_tables;

  -- calculate_mean_salary
  FUNCTION calculate_mean_salary(position_name Position.name%TYPE)
    RETURN NUMBER IS
    average NUMBER;
    BEGIN
      SELECT AVG(w.salary)
      INTO average
      FROM Worker w, POSITION p
      WHERE w.position_id = p.id
            AND p.name = position_name;
      RETURN average;
    END;
END table_migrator;

CALL table_migrator.migrate_tables();

DECLARE aa NUMBER;
BEGIN
  aa := table_migrator.calculate_mean_salary('Sales Associate');
  dbms_output.Put_line(aa); --display
END;