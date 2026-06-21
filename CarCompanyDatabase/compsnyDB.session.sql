CREATE TABLE employee(
emp_id INT PRIMARY KEY,
first_name VARCHAR(20),
last_name VARCHAR(20),
birth_day DATE,
sex VARCHAR(1),
salary INT,
super_id INT,
branch_id INT
);



CREATE TABLE branch(
branch_id INT PRIMARY KEY,
branch_name VARCHAR(20),
mgr_id INT,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);



ALTER TABLE employee 
ADD FOREIGN KEY(branch_id) 
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee 
ADD FOREIGN KEY(super_id) 
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(20),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id,client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE  CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE  CASCADE
);

CREATE TABLE branch_supplier(
branch_id INT ,
supplier_name VARCHAR(20),
supplier_type VARCHAR(20),
PRIMARY KEY(branch_id,supplier_name),
FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- AMMAN
INSERT INTO employee VALUES(100,'HUSAM','ZIADEH','2005-6-2','M',2000,NULL,NULL);

INSERT INTO branch VALUES (1, 'Amman', 100, '2010-06-04');

UPDATE employee 
SET branch_id =1
WHERE emp_id=100;

INSERT INTO employee VALUES(101,'ANAS','ALHUSSIENI','2008-7-17','M',2500,100,1);


-- DUBAI
INSERT INTO employee VALUES(102, 'YAZAN', 'MOHAMMAD', '1964-03-15', 'M', 1500, 100, NULL);

UPDATE branch
SET branch_name = 'DUBAI',
WHERE branch_id = 2;

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

ALTER TABLE client
MODIFY client_name VARCHAR(50);

INSERT INTO employee VALUES(103, 'SARA', 'ALI', '2003-06-25', 'F', 700, 102, 2);
INSERT INTO employee VALUES(104, 'JOUD', 'AHMAD', '1998-02-05', 'F', 1600, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '2005-02-19', 'M', 600, 102, 2);

--ISTANBUL
INSERT INTO employee VALUES(106, 'HASHEM', 'FARES', '1995-09-05', 'M', 3800, 100, NULL);

INSERT INTO branch VALUES(3, 'ISTANBUL', 106, '2014-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;



INSERT INTO employee VALUES(107, 'ASLAN', 'OGLU', '1989-07-22', 'M', 6500, 106, 3);
INSERT INTO employee VALUES(108, 'ALI', 'YALMEZ', '1997-10-01', 'M', 1050, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Dubai Auto Parts', 'Engine Parts');
INSERT INTO branch_supplier VALUES(2, 'Gulf Tires', 'Tires');
INSERT INTO branch_supplier VALUES(3, 'Anatolia Motors', 'Engine Parts');
INSERT INTO branch_supplier VALUES(2, 'Desert Lubricants', 'Motor Oil');
INSERT INTO branch_supplier VALUES(3, 'Bosphorus Tires', 'Tires');
INSERT INTO branch_supplier VALUES(3, 'Istanbul Auto Glass', 'Windshields');
INSERT INTO branch_supplier VALUES(3, 'Turkish Battery Co.', 'Batteries');

-- CLIENT
INSERT INTO client VALUES(400, 'Amman Taxi ', 2);
INSERT INTO client VALUES(401, 'Jordan-Logistics', 2);
INSERT INTO client VALUES(402, 'Dubai Rent A Car', 3);
INSERT INTO client VALUES(403, 'Emirates Transport Group', 3);
INSERT INTO client VALUES(404, 'Amman Car Rental', 2);
INSERT INTO client VALUES(405, 'Istanbul Delivery Fleet', 3);
INSERT INTO client VALUES(406, 'Gulf Express Logistics', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 22500);
INSERT INTO works_with VALUES(108, 402, 267000);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 130000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 24000);

SELECT * FROM employee ORDER BY salary;
SELECT * FROM works_with;

-- Find all male employees
SELECT *
FROM employee
WHERE sex = 'M';

-- Find all employees at branch 2
SELECT *
FROM employee
WHERE branch_id = 2;

-- Find all employees who are female & born after 1999 
SELECT *
FROM employee
WHERE (birth_day >= '1999-01-01' AND sex = 'F') ;

-- Find the average of all employee's salaries
SELECT AVG(salary)
FROM employee;

-- Find out how many males and females there are
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Find all clients who are handles by the branch that YAZAN MOHAMMAD manages
SELECT client.client_id , client.client_name
FROM client 
WHERE client.branch_id =(SELECT branch.branch_id
FROM branch 
WHERE branch.mgr_id=102
);

-- Find the names of all clients who have spent more than 100,000 dollars
SELECT client.client_name
FROM client
WHERE client.client_id IN (
 SELECT client_id
 FROM (
 SELECT SUM(works_with.total_sales) AS totals, client_id
FROM works_with
 GROUP BY client_id) AS total_client_sales
 WHERE totals > 100000
);