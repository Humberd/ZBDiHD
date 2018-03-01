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

CREATE SEQUENCE worker_id_generator
  INCREMENT BY 1
  START WITH 1
  NOCYCLE;

CREATE SEQUENCE position_id_generator
  INCREMENT BY 1
  START WITH 1
  NOCYCLE;

CREATE SEQUENCE speciality_id_generator
  INCREMENT BY 1
  START WITH 1
  NOCYCLE;

--------------------- task2 PACKAGE ----------------------------
CREATE OR REPLACE PACKAGE task2 AS
  PROCEDURE migrate_tables;

  FUNCTION calculate_mean_salary(position_name Position.name%TYPE)
    RETURN NUMBER;
END;

--------------------- task2 PACKAGE IMPLEMENTATION ------------
CREATE OR REPLACE PACKAGE BODY task2
AS
  PROCEDURE migrate_tables AS
    BEGIN
      -- TEMP -> Position
      FOR i IN (SELECT DISTINCT t.POSITION
                FROM TEMP t) LOOP
        INSERT INTO Position VALUES (position_id_generator.nextval, i.POSITION);
      END LOOP;

      -- TEMP -> Speciality
      FOR i IN (SELECT DISTINCT t.SPECIALITY
                FROM TEMP t) LOOP
        INSERT INTO Speciality VALUES (speciality_id_generator.nextval, i.SPECIALITY);
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
        VALUES (worker_id_generator.nextval,
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
    END;

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
END;

CALL task2.migrate_tables();

DECLARE result NUMBER;
BEGIN
  result := task2.calculate_mean_salary('Sales Associate');
  dbms_output.put_line('Average salary for Sales Associate: ' || result);
END;

------------------  salary_guard TRIGGER  -----------------------
CREATE OR REPLACE TRIGGER salary_guard
  BEFORE UPDATE OF position_id, salary OR INSERT
  ON Worker
  FOR EACH ROW
  DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    position_name  VARCHAR(100);
    average_salary NUMBER;
      salaryException EXCEPTION;
  BEGIN
    SELECT Position.name
    INTO position_name
    FROM Position
    WHERE ID = :new.position_id;

    average_salary := task2.calculate_mean_salary(position_name);
    dbms_output.put_line('average ' || average_salary);
    IF (average_salary * 1.25) < :new.salary
    THEN
      RAISE salaryException;
    END IF;
  END;

ALTER TRIGGER salary_guard ENABLE;

SELECT * FROM Worker;
SELECT * FROM Position;
SELECT * FROM Speciality;