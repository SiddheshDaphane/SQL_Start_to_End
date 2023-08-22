--------------------------------- JOINS --------------------------------------


-- Importing an table from different database (master) to namasteSQL
SELECT * into namasteSQL.dbo.returns FROM returns -- change the database to master and then run it


SELECT *
FROM returns


-- JOINing the table


CREATE TABLE returns
(
order_id VARCHAR(20),
return_reason VARCHAR(20)
)


INSERT INTO returns
SELECT * FROM returns_backup


SELECT * FROM returns


SELECT o.order_id, o.order_date, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id


SELECT DISTINCT o.order_id, o.order_date, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id 


SELECT DISTINCT o.*, return_reason
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id


SELECT DISTINCT o.*, r.*
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id -- See the order_id of 1st three rows. order_id is same and return reason is also same but this can be wrong. Maybe only 1 item is returned but not all. So what's the solution?


-- Not a solution of above question
SELECT DISTINCT o.*, r.*
FROM orders o -- This is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id




SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id


-- Q) I want all the records which are not present in returns table meaning I want records which are not being return (Interview question)




SELECT o.order_id, o.product_id, r.return_reason, r.order_id as ret
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL


-- Q) How much money I lost from return orders? See the output of both and compare it


SELECT r.return_reason, SUM (sales) as total_sales
FROM orders o -- this is the left table
LEFT JOIN returns r
ON o.order_id = r.order_id
GROUP BY r.return_reason


SELECT r.return_reason, SUM (sales) as total_sales
FROM orders o -- this is the left table
INNER JOIN returns r
ON o.order_id = r.order_id
GROUP BY r.return_reason






----------------------------- FOR CROSS JOIN ----------------------------------
create table employee(
emp_id int,
emp_name varchar(20),
dept_id int,
salary int,
manager_id int,
emp_age int
);




insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);
select * from employee;






create table dept(
dep_id int,
dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');
select * from dept;




--- New syntax.


SELECT *
FROM employee,dept
ORDER BY employee.emp_id


-- This give same output as above query
SELECT *
FROM employee
INNER JOIN dept
ON 1=1 -- or you can say 100=100
ORDER BY employee.emp_id


----------------------------- Improtant observation
/*
There is no 400 dept_id in employee table and there is no 500 dept_id in department table
*/


SELECT * FROM employee
SELECT * FROM dept




SELECT *
FROM employee,dept
ORDER BY employee.emp_id --- Cross join so 40 records

 
-- This give same output as above query
SELECT *
FROM employee
INNER JOIN dept
ON 1=1 -- or you can say 100=100
ORDER BY employee.emp_id ---- Cross join so 40 records


SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
INNER JOIN dept d
ON e.dept_id = d.dep_id ----- Inner join so total 9 records




SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
LEFT JOIN dept d
ON e.dept_id = d.dep_id ----- Left Join so 10 records


SELECT e.emp_id, e.emp_name, e.dept_id, d.dep_name
FROM employee e
RIGHT JOIN dept d
ON e.dept_id = d.dep_id ------ Right join so 10 records and 500 is not present


SELECT e.emp_id, e.emp_name, e.dept_id,d.dep_id, d.dep_name
FROM employee e
FULL OUTER JOIN dept d
ON e.dept_id = d.dep_id ------- Full outer join but all records from both table.






CREATE TABLE people
(
manager VARCHAR(20),
region VARCHAR(10)
)
DROP TABLE people
INSERT INTO people
VALUES('Ankit','West')
,('Deepak','East')
,('Vishal','Central')
,('Sanjay','South')


SELECT * FROM people
SELECT * FROM orders




SELECT o.order_id , o.product_id, r.return_reason, p.manager
FROM orders o
INNER JOIN returns r ON o.order_id = r.order_id
INNER JOIN people p ON p.region = o.region
-- You can also use returns table if there is a same column. AND the result of first inner join will be inner joined with people table





---------------------------- Assignment ------------------------------------


-- Q1) write a query to get region wise count of return orders


select * from returns
select * from orders


-- My answer
SELECT o.region, COUNT(DISTINCT r.order_id) as no_of_return_orders
FROM returns r
INNER JOIN orders o
ON o.order_id = r.order_id
GROUP BY region




-- Solution
select region,count(distinct o.order_id) as no_of_return_orders
from orders o
inner join returns r on o.order_id=r.order_id
group by region






-- Q2) write a query to get category wise sales of orders that were not returned
/*
Pahile me INNER JOIN vaparla hota pan jar inner join vaparla and WHERE caluse madhe order_id IS NULL kela tar output kahic yenar nahi karan apan inner join karto ahe


Second query madhe me LEFT JOIN vaparla ahe karan mala ashe records pahije ahet je RETURNS table amdhe nahie mhanun aplyala LEFT JOIN use karav lagel
*/


-- My answer (wrong)
SELECT o.category, SUM(o.sales) as total_sales
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL
GROUP BY o.category




-- My answer (correct)
SELECT o.category, SUM(o.sales) as total_sales
FROM orders o
LEFT JOIN returns r
ON o.order_id = r.order_id
WHERE r.order_id IS NULL
GROUP BY o.category


-- Solution
select category,sum(o.sales) as total_sales
from orders o
left join returns r on o.order_id=r.order_id
where r.order_id is null
group by category






-- Q3) write a query to print dep name and average salary of employees in that dep .


/*
Aplyala avg salary kadhaychi ahe department chi. confuse hou shakta ki employee_id yeu shakta ka nahi
*/
select * from employee
select * from dept


-- My solution
SELECT d.dep_name, AVG(salary) as avg_sal
FROM employee e
LEFT JOIN dept d
ON e.dept_id = d.dep_id
GROUP BY d.dep_name


-- Solution
select d.dep_name,avg(e.salary) as avg_sal
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name


-- Q4) write a query to print dep names where none of the emplyees have same salary.


-- My answer
SELECT d.dep_name
FROM employee e
LEFT JOIN dept d
ON e.dept_id = d.dep_id
GROUP BY d.dep_name
HAVING COUNT(DISTINCT salary) = 1


-- Solution
select d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
group by d.dep_name
having count(e.emp_id)=count(distinct e.salary)


-- Q5) 5- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)


/*
Little bit confusing question. Need to look at the solution


Solution logic is more accurate
*/


select * from orders
select * from returns


select count(DISTINCT city) from orders


-- My answer
SELECT sub_category
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE return_reason IN ('Other', 'Wrong Items', 'Bad Quality')
GROUP BY sub_category -- The question says all 3 kinds of records 
– so that means we are not talking at row level but at a group level
– meaning assume that if a sub-category has 2 out of 3 kinds of returns and we use the – WHERE clause. Now WHERE goes row by row meaning a sub-category having 2 out of 3 – – – kinds of return will also get selected but we want all 3 kinds of returns. 
– If a question says that either in any kind of return then I can use the WHERE clause.
– Extremely important concept 


-- Solution
select o.sub_category
from orders o
inner join returns r on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3




-- Q6) write a query to find cities where not even a single order was returned.


/*
konta barobar ahe ki donhi chukicha ahe
*/


-- My Answer 1
SELECT city
FROM orders o
LEFT JOIN returns r
ON o.order_id=r.order_id
WHERE r.order_id IS NULL
GROUP BY city -- Very important concept ahe and mothi mistake ahe ya logic madhe.
-- jar r.order_id IS NULL asa lihla tar process kasa hoil te baghayla pahije.
-- WHERE row by row jata and having group var lagta.
-- Jenvha me ithe 'WHERE r.order_id IS NULL' use kela tenva row by row gela
-- atta assume kar ki eak city ahe (Pune) jithun order 2 order return zalya ahet
-- pune badquality
-- pune NULL
-- atta ithe 'WHERE r.order_id IS NULL' ya condition pramane pune qualify zali karan NULL ahe
-- Pan question madhe mhantla ahe ki eak pan single order nako city madhun mhanje logic chukla maza
-- So where kadhi vaparaycha he khup IMP ahe. Confusion hou shakta we are talking about city (group) level not at row level and that’s why WHERE cannot be used here.




-- My answer 2
SELECT city, COUNT(r.order_id)
FROM orders o
LEFT JOIN returns r
ON o.order_id=r.order_id
GROUP BY city
HAVING COUNT(r.order_id) = 0


-- Solution
select city
from orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0




-- Q7) write a query to find top 3 subcategories by sales of returned orders in east region


/*
SUM(o.sales) he aggregate function ahe and jar tyala apan alias kela nahi tar ORDER BY madhe sales lihta yenar nahi.
and mag required output yenar nahi
*/


-- My answers
SELECT TOP 3 o.sub_category, SUM(o.sales) AS returned_sales
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE o.region = 'East'
GROUP BY o.sub_category
ORDER BY returned_sales DESC


SELECT TOP 3 o.sub_category, SUM(o.sales)
FROM orders o
INNER JOIN returns r
ON o.order_id = r.order_id
WHERE o.region = 'East'
GROUP BY o.sub_category
ORDER BY SUM(o.sales)DESC


-- Solution
select top 3 sub_category,sum(o.sales) as return_sales
from orders o
inner join returns r on o.order_id=r.order_id
where o.region='East'
group by sub_category
order by return_sales desc




-- Q8) write a query to print dep name for which there is no employee
select * from dept
select * from employee


-- My answer
SELECT d.dep_name
FROM dept d
LEFT JOIN employee e
ON d.dep_id=e.dept_id
WHERE e.emp_id IS NULL


-- Solution
select d.dep_id,d.dep_name
from dept d
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;


--Q9) write a query to print employees name for dep id is not avaiable in dept table


-- My answer
SELECT e.emp_name
FROM employee e
LEFT JOIN dept d
ON e.dept_id=d.dep_id
WHERE dep_name IS NULL


-- solution
select e.*
from employee e
left join dept d on e.dept_id=d.dep_id
where d.dep_id is null;


-------------------------------- AMAZON INTERVIEW QUESTION ------------------------------------


/*
There are 2 tables, the first table has 5 records and the second table has 10 records.
You can assume any values in each of the tables. How many maximum and minimum records possible
in case of inner join, left join, right join and full outer join?
*/
CREATE TABLE t1
(
col_1 INT
)
INSERT INTO t1 VALUES (1)
,(1)
,(1)
,(1)
,(1)
SELECT * from t1
DROP TABLE t1




CREATE TABLE t2
(
col_1 INT
)


INSERT INTO t2 VALUES (1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
,(1)
SELECT * from t2


SELECT COUNT(*) as max_count FROM t1
INNER JOIN t2 ON t1.col_1=t2.col_1


SELECT COUNT(*) as max_count FROM t1
LEFT JOIN t2 ON t1.col_1=t2.col_1


SELECT COUNT(*) as max_count FROM t1
RIGHT JOIN t2 ON t1.col_1=t2.col_1
SELECT COUNT(*) as max_count FROM t1
FULL OUTER JOIN t2 ON t1.col_1=t2.col_1




CREATE TABLE t3
(
col_1 INT
)
INSERT INTO t3 VALUES (2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
,(2)
DROP TABLE t3
SELECT * from t3


SELECT COUNT(*) as max_count FROM t1
INNER JOIN t3 ON t1.col_1=t3.col_1


SELECT COUNT(*) as max_count FROM t1
LEFT JOIN t3 ON t1.col_1=t3.col_1


SELECT COUNT(*) as max_count FROM t1
RIGHT JOIN t3 ON t1.col_1=t3.col_1
SELECT COUNT(*) as max_count FROM t1
FULL OUTER JOIN t3 ON t1.col_1=t3.col_1


