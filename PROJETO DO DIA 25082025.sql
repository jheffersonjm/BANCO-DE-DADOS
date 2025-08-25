CREATE TABLE emp( 
empname TEXT, 
salary INTEGER,
last_date TIMESTAMP, 
last_user TEXT
);

--DROP TABLE emo;

CREATE TABLE emp_audit(
operation char(1) NOT NULL,
userid text NOT NULL,
empname text NOT NULL,
salary integer,
stamp timestamp NOT NULL
);


--Comando para criar uma função
CREATE OR REPLACE FUNCTION emp_stamp()
--TIPO DE RETORNO QUE VAI TER A TRIGGER
RETURNS trigger AS 
$emp_stamp$
--CORPO DA FUNÇÃO
BEGIN
-- Check that empname and salary are given
IF NEW.empname IS NULL THEN
RAISE EXCEPTION 'empname cannot be null';
END IF;
IF NEW.salary IS NULL THEN
RAISE EXCEPTION '% cannot have null salary', NEW.empname;
END IF;
-- Who works for us when they must pay for it?
IF NEW.salary <= 0 THEN
RAISE EXCEPTION '% cannot have a negative or null salary', NEW.empname;
END IF;
-- Remember who changed the payroll when
NEW.last_date := current_timestamp;
NEW.last_user := current_user;
RETURN NEW;
END;
$emp_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON emp
FOR EACH ROW EXECUTE PROCEDURE emp_stamp();


INSERT INTO emp (empname, salary)VALUES ('Juquinha', 10000); 
SELECT * FROM emp; 
insert into emp (empname) values ('Juquinha2')
insert into emp ( salary) values ( 20000)
insert into emp (empname, salary) values ('Juquinha2', -20000)

CREATE OR REPLACE FUNCTION process_emp_audit() RETURNS TRIGGER AS $emp_audit$
BEGIN
--
-- Create a row in emp_audit to reflect the operation performed on emp,
-- make use of the special variable TG_OP to work out the operation.
--
IF (TG_OP = 'DELETE') THEN
INSERT INTO emp_audit SELECT 'D', user, OLD.EMPNAME, OLD.SALARY, now();
RETURN OLD;
ELSIF (TG_OP = 'UPDATE') THEN
INSERT INTO emp_audit SELECT 'U', user, NEW.EMPNAME, NEW.SALARY, now();
RETURN NEW;
ELSIF (TG_OP = 'INSERT') THEN
INSERT INTO emp_audit SELECT 'I', user, NEW.EMPNAME, NEW.SALARY, now();
RETURN NEW;
END IF;
RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$emp_audit$ LANGUAGE plpgsql;


CREATE TRIGGER emp_audit
AFTER INSERT OR UPDATE OR DELETE
ON emp FOR EACH ROW EXECUTE PROCEDURE process_emp_audit();


