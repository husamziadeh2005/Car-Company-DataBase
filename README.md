# Car Company Database Project

## Overview
This project implements a relational database system for managing a car company's operations, including employees, branches, clients, and suppliers. The database schema is designed to efficiently store and retrieve information, supporting various business queries and reporting needs.

## Database Schema
The database consists of several interconnected tables. The schema is defined in `compsnyDB.session.sql` and includes the following tables:

- **Employee**: Stores information about car company employees.
- **Branch**: Manages details of different company branches.
- **Client**: Contains information about the clients.
- **Works_With**: Links employees to the clients they work with and tracks total sales.
- **Branch_Supplier**: Records suppliers associated with each branch.

### Entity-Relationship Diagram (ERD)
Below is the Entity-Relationship Diagram illustrating the relationships between the tables:

![Company ER Diagram](/home/ubuntu/car_company_db/CarCompanyDatabase/Company ER.png)

### Relational Schema
For a more detailed view of the relational structure, refer to the following diagram:

![Company Relations Diagram](https://private-us-east-1.manuscdn.com/sessionFile/yo6L9LhtUSBtKRMGrUZ40o/sandbox/k5pzDDgE2YysGfqwhIQbB5-images_1782076336286_na1fn_L2hvbWUvdWJ1bnR1L2Nhcl9jb21wYW55X2RiL0NhckNvbXBhbnlEYXRhYmFzZS9jb21wYW55LXJlbGF0aW9ucw.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUveW82TDlMaHRVU0J0S1JNR3JVWjQwby9zYW5kYm94L2s1cHpERGdFMll5c0dmcXdoSVFiQjUtaW1hZ2VzXzE3ODIwNzYzMzYyODZfbmExZm5fTDJodmJXVXZkV0oxYm5SMUwyTmhjbDlqYjIxd1lXNTVYMlJpTDBOaGNrTnZiWEJoYm5sRVlYUmhZbUZ6WlM5amIyMXdZVzU1TFhKbGJHRjBhVzl1Y3cucG5nIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzk4NzYxNjAwfX19XX0_&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=SDXojy1V0ZgUd5jchFZLAY8HtQFqhfEPapBhgyLq~Brt1VhS2vJ0AE~BG~vuhzbKknh-Q8rfLsxo1Df1NEsTH-Rygr82cv5uKTfY4CEJSnKDVGFRMssYowm~6mV1cW0i4dHaFs97tDofL~BpfoDALL8rsx6106ceEMVzXUU6ZQV9~W1Y4fVh2oHUm9jRHgL53A5iWrfxwqdXNSan4fJJycljUvwzAlxZwgC5APBiS8xx~PVfbkA~oYIozrGgnDixAXEF17o4m1RA83yI0SObTt51gTMCriuYa4E8MNtTIVnrGt-XiFm29Or9JDbsI3ewMeUtzLtsrPI9MemKhUyeSA__)

## Sample Data and Queries
The `compsnyDB.session.sql` file also contains sample data insertion statements and various SQL queries demonstrating data retrieval and analysis. The project includes several CSV files that represent the results of some of these queries.

### Example Queries and Results

#### Average Employee Salary
```sql
SELECT AVG(salary)
FROM employee;
```
Result:

| AVG(salary) |
|-------------|
| 2250.0000   |

#### Employees in Branch 2
```sql
SELECT *
FROM employee
WHERE branch_id = 2;
```
Result (from `Branch2Emp.csv`):

| emp_id | first_name | last_name | birth_day  | sex | salary | super_id | branch_id |
|--------|------------|-----------|------------|-----|--------|----------|-----------|
| 102    | YAZAN      | MOHAMMAD  | 1964-03-15 | M   | 1500   | 100      | 2         |
| 103    | SARA       | ALI       | 2003-06-25 | F   | 700    | 102      | 2         |
| 104    | JOUD       | AHMAD     | 1998-02-05 | F   | 1600   | 102      | 2         |
| 105    | Stanley    | Hudson    | 2005-02-19 | M   | 600    | 102      | 2         |

#### Clients Handled by Yazan Mohammad's Branch
```sql
SELECT client.client_id , client.client_name
FROM client 
WHERE client.branch_id =(SELECT branch.branch_id
FROM branch 
WHERE branch.mgr_id=102
);
```
Result (from `HandledByYazan.csv`):

| client_id | client_name         |
|-----------|---------------------|
| 400       | Amman Taxi Services |
| 401       | Jordan-Logistics    |
| 404       | Amman Car Rental    |
| 406       | Gulf Express Logistics |

#### Clients with Total Sales Over $100,000
```sql
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
```
Result (from `ClientOver100.csv`):

| client_name             |
|-------------------------|
| Dubai Rent A Car        |
| Istanbul Delivery Fleet |

#### Employee Count by Sex
```sql
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;
```
Result (from `sexCout.csv`):

| COUNT(sex) | sex |
|------------|-----|
| 7          | M   |
| 2          | F   |


