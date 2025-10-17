-- MEDIUM LEVEL PROBLEM


-- Create the student table
CREATE TABLE student (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    class VARCHAR(50)
);

-- Create the trigger function
CREATE OR REPLACE FUNCTION fn_student_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        RAISE NOTICE 'Inserted Row -> ID: %, Name: %, Age: %, Class: %',
                     NEW.id, NEW.name, NEW.age, NEW.class;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        RAISE NOTICE 'Deleted Row -> ID: %, Name: %, Age: %, Class: %',
                     OLD.id, OLD.name, OLD.age, OLD.class;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

-- Create the trigger
CREATE TRIGGER trg_student_audit
AFTER INSERT OR DELETE
ON student
FOR EACH ROW
EXECUTE FUNCTION fn_student_audit();

-- Test the trigger

-- Insert records
INSERT INTO student(name, age, class) VALUES ('Shivanshu', 20, 'B.Tech');
INSERT INTO student(name, age, class) VALUES ('Tanya', 21, 'B.Tech');
INSERT INTO student(name, age, class) VALUES ('Devanshu', 19, 'Non-CSE');

-- Delete a record
DELETE FROM student WHERE name = 'Devanshu';

SELECT * FROM student;




-- HARD LEVEL PROBLEM


-- Create employee and audit tables
CREATE TABLE tbl_employee (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    emp_salary NUMERIC
);

CREATE TABLE tbl_employee_audit (
    sno SERIAL PRIMARY KEY,
    message TEXT
);

-- Create the trigger function
CREATE OR REPLACE FUNCTION audit_employee_changes()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS 
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO tbl_employee_audit(message)
        VALUES ('Employee name ' || NEW.emp_name || ' has been added at ' || NOW());
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO tbl_employee_audit(message)
        VALUES ('Employee name ' || OLD.emp_name || ' has been deleted at ' || NOW());
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

-- Create the trigger
CREATE TRIGGER trg_employee_audit
AFTER INSERT OR DELETE 
ON tbl_employee
FOR EACH ROW
EXECUTE FUNCTION audit_employee_changes();

-- Test the trigger

-- Insert employees
INSERT INTO tbl_employee(emp_name, emp_salary) VALUES ('Shivanshu', 90000);
INSERT INTO tbl_employee(emp_name, emp_salary) VALUES ('Tanya', 95000);
INSERT INTO tbl_employee(emp_name, emp_salary) VALUES ('Karan', 100000);

-- Delete one employee
DELETE FROM tbl_employee WHERE emp_name = 'Karan';

SELECT * FROM tbl_employee;
SELECT * FROM tbl_employee_audit;
