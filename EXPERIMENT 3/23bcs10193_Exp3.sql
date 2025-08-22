-- Experiment 3 (a)

CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Employee (
    EMP_ID INT
);

INSERT INTO Employee (EMP_ID) VALUES
(2),
(4),
(4),
(6),
(6),
(7),
(8),
(8),
(8);

SELECT MAX(EMP_ID) AS SecondHighest
FROM Employee
WHERE EMP_ID < (SELECT MAX(EMP_ID) FROM Employee);


-- Experiment 3 (b)

CREATE DATABASE CompanyDB2;
USE CompanyDB2;

CREATE TABLE department (
    id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employee (
    id INT,
    name VARCHAR(50),
    salary INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES department(id)
);

INSERT INTO department (id, dept_name) VALUES
(1, 'IT'),
(2, 'SALES');

INSERT INTO employee (id, name, salary, department_id) VALUES
(1, 'JOE', 70000, 1),
(2, 'JIM', 90000, 1),
(3, 'HENRY', 80000, 2),
(4, 'SAM', 60000, 2),
(5, 'MAX', 90000, 1);

SELECT d.dept_name, e.name, e.salary
FROM employee e
JOIN department d 
ON e.department_id = d.id
WHERE e.salary=(
    SELECT MAX(salary)
    FROM employee
    WHERE department_id = e.department_id)
ORDER BY dept_name;


-- Experiment 3 (c)

CREATE DATABASE CompanyDB3;
USE CompanyDB3;

CREATE TABLE a (
    empid INT,
    ename VARCHAR(50),
    salary INT
);

INSERT INTO a VALUES
(1, 'AA', 1000),
(2, 'BB', 300);

CREATE TABLE b (
    empid INT,
    ename VARCHAR(50),
    salary INT
);

INSERT INTO b VALUES
(2, 'BB', 400),
(3, 'CC', 100);

select * from a;
select * from b;

SELECT empid, ename, MIN(salary) AS salary
FROM (
    SELECT * FROM a
    UNION ALL
    SELECT * FROM b
) s
GROUP BY empid, ename;