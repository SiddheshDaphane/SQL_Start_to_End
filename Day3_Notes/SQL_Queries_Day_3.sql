SELECT *
FROM orders;

----------------- Filtering NULL data --------------------------

-- Step 1) Setting data to NULL because we don't have any
UPDATE orders
set city=NULL 
WHERE order_id IN ('CA-2020-152156', 'US-2019-108966');

-- Step 2) Cross checking if rows are affected or not
SELECT *
FROM orders
WHERE order_id IN ('CA-2020-152156', 'US-2019-108966');

-- We cannot write this because NULL is unknown that's why we cannot compare it
SELECT *
FROM orders
WHERE city = NULL;

-- This is way to get NULL values 
SELECT *
FROM orders
WHERE city IS NULL;

-- Using NOT NULL 
SELECT *
FROM orders
WHERE city IS NOT NULL;

------------------------ Aggregating Function --------------------------

-- 1st Function. COUNT. It will count number of records meaning acting on rows
SELECT COUNT(*) as cnt
FROM orders;


-- 2nd Function. SUM. 
SELECT SUM(sales) as total_sales
FROM orders;

-- MAX, MIN and AVG function
SELECT MAX(sales) as Max_sales,
       MIN(sales) as Min_sales,
       AVG(sales) as Avg_sales
FROM orders;


-- GROUP BY (perform like a DISTINCT but we can use aggregate function with it)
-- You have to use non aggregate column in GROUP BY
SELECT region, MAX(sales) as Max_sales,
       MIN(sales) as Min_sales,
       AVG(sales) as Avg_sales
FROM orders
GROUP BY region;

SELECT region, category, MAX(sales) as Max_sales,
       MIN(sales) as Min_sales,
       AVG(sales) as Avg_sales
FROM orders
GROUP BY region, category;

-- This will not run because in SELECT statement there are 2 non aggregate columns. Let's take an example
/*
Let's say we have two records
ID    Region      Category      sales
1)    east        technology    100
2)    east        medical       200

Now according to our query (below) we want region and category in the select statement but
in the GROUP BY we are only using region. 
In the two records which are above, database will GROUP BY region in 1 row that is east but in the SELECT 
we want category as well. Now database is confuse. How can the database group by the region and at the same time
return 2 different categories. Logocally this is not poosible and that's why columns that we use in GROUP BY clause
must be present in SELECT clause or have a aggregated columns. 
*/
SELECT region, category, MAX(sales) as Max_sales,
       MIN(sales) as Min_sales,
       AVG(sales) as Avg_sales
FROM orders
GROUP BY region; 

SELECT region, category, MAX(sales) as Max_sales,
       MIN(sales) as Min_sales,
       AVG(sales) as Avg_sales
FROM orders
WHERE profit > 50
GROUP BY region, category;

-- You have to use a column name in ORDER BY which is present in SELECT statement.
-- you can only sort the result based on the columns that are present in the SELECT clause or columns derived from the aggregated functions used in the SELECT clause. 
SELECT TOP 5 region, category, MAX(sales) as Max_sales,
       MIN(sales) as Min_sales,
       AVG(sales) as Avg_sales,
       SUM(sales) as total_sales
FROM orders
WHERE profit > 50
GROUP BY region, category
ORDER BY total_sales desc;

------------------------Filtering on Aggregate values---------------------------

-- FROM - GROUP BY - HAVING - SELECT - ORDER BY - TOP 5 (exe order)
SELECT TOP 5 sub_category,
       SUM(sales) as total_sales
FROM orders
GROUP BY sub_category
HAVING sum(sales) > 100000
ORDER BY total_sales desc;


-- because of exe order, this query is wrong
SELECT TOP 5 sub_category,
       SUM(sales) as total_sales
FROM orders
GROUP BY sub_category
HAVING total_sales > 100000
ORDER BY total_sales desc;


SELECT TOP 5 sub_category,
       SUM(sales) as total_sales
FROM orders
WHERE profit > 50
GROUP BY sub_category
HAVING sum(sales) > 100000
ORDER BY total_sales desc;

/*
So, we can use HAVING on columns meaning on non-aggregate values but it will not be efficient. Why?
Because if I use HAVING then I will have to use GROUP BY first and on that GROUP BY filters will apply
which is a extra load on database. 
On the other hand, if I use WHERE then database will go row by row and will not have to compute on a group
which will be more efficient. 
*/



/*
Following is a sample database

sub-category    date        sales
chairs       '2019-01-01'    100
charis       '2019-10-10'    200
bookcases    '2019-01-01'    300
bookcases    '2020-10-10'    400

I am running following query on this database. What will be the output?

SELECT sub-category, SUM(sales) as total_sales, MAX(order_date)
FROM orders
GROUP BY sub-category
HAVING MAX(order_date) > '2020-01-01'
ORDER BY total_sales DESC;

What will be the output?

1)charis, 300, '2019-10-10'
2)bookcase, 400, '2020-10-10'
3)bookcases, 700, '2020-10-10' 

Answer :- 
So the answer will be 3) bookcases, 700, '202-10-10'
Look at the order of exe. It will go to FROM then it will GROUP BY. Once it is grouped by sub-categories
then it will SUM sales which is 700 and then it will give MAX(date) 
Important point here is that database will not go row by row because we are using GROUP BY function.
It will group it and give collective output. 


SELECT sub-category, SUM(sales) as total_sales, MAX(order_date)
FROM orders
WHERE MAX(order_date) > '2020-01-01'
GROUP BY sub-category
ORDER BY total_sales DESC;


Answer is (bookcases    '2020-10-10'    400) (Think)
*/   



---------------------- COUNT FUNCTION ---------------------

SELECT COUNT (DISTINCT category)
FROM orders

SELECT COUNT (1)
FROM orders

SELECT COUNT (100)
FROM orders

SELECT COUNT (city) -- doesn't count NULL values
FROM orders

/*
Imporatnt Question. 

Following is the database

region      sales
'east'      100
'east'      NULL
'east'      200

SELECT region, AVG(sales) as avg_sales
FROM orders
GROUP BY region

SELECT region, SUM(sales)/COUNT(region) as x
FROM orders
GROUP BY region

What will be the output of both queries?

The answer is 150 and 100
*/

-------------------------------- ASSIGNMENT and QUESTIONS --------------------------------------

-- Q1) write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909

UPDATE orders
SET city=NULL
WHERE order_id IN ('CA-2020-161389', 'US-2021-156909')

-- Q2) write a query to find orders where city is null (2 rows)

SELECT *
FROM orders
WHERE city IS NULL

-- Q3) write a query to get total profit, first order date and latest order date for each category 

SELECT category, SUM(profit) as total_profit, MIN(order_date) as first_order_date, MAX(order_date) as latest_order_date
FROM orders
GROUP BY category 

-- Q4) write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

SELECT sub_category
FROM orders
GROUP BY sub_category
HAVING AVG(profit) > MAX(profit)/2 

-- Q5) create the exams table with below script;
-- write a query to find students who have got same marks in Physics and Chemistry.
-- create table exams (student_id int, subject varchar(20), marks int);

create table exams (student_id int, subjects varchar(20), marks int);
insert into exams values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',90)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

DROP TABLE exams

SELECT student_id, marks
FROM exams
WHERE subjects ='Physics' or subjects = 'Chemistry'
GROUP BY student_id, marks
HAVING COUNT(DISTINCT subjects) = 2
      -- AND MIN(marks) = MAX(marks);



-- Q) Write a query for student who got same marks in all 3 subjects

create table examss (student_id int, subjects varchar(20), marks int);
insert into examss values (1,'Chemistry',91),(1,'Physics',91),(1,'Maths',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79);

DROP TABLE examss


SELECT student_id, marks
FROM examss
WHERE subjects ='Physics' or subjects = 'Chemistry'  or subjects = 'Maths'
GROUP BY student_id, marks
HAVING COUNT(DISTINCT subjects) = 3


-- Write a query to find a student who has same marks in any two subject

SELECT student_id, marks
FROM examss
WHERE subjects ='Physics' or subjects = 'Chemistry'  or subjects = 'Maths'
GROUP BY student_id, marks
HAVING COUNT(DISTINCT subjects) > 1




create table exam (student_id int, subjects varchar(20), marks int);
insert into exam values (1,'Chemistry',91),(1,'Physics',92),(1,'Maths',93)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80),(3,'Maths',80)
,(4,'Chemistry',71),(4,'Physics',54)
,(5,'Chemistry',79),(4,'Maths',88);

SELECT student_id, marks
FROM exam
WHERE subjects ='Physics' or subjects = 'Chemistry'  or subjects = 'Maths'
GROUP BY student_id, marks
HAVING COUNT(DISTINCT subjects) = 3
       --AND MIN(marks) = MAX(marks); 


/* 

1)Anurag

SELECT student_id
FROM exams
WHERE subject IN ('Physics', 'Chemistry')
GROUP BY student_id
HAVING COUNT(DISTINCT marks) = 1 

2) DISHA

Select distinct s.student_id, s.marks 
from exam s
Join exam s1 
On s.student_id = s1.student_id and 
s.subjects = 'Physics' and s1.subjects = 'Chemistry'
Where s.marks = s1.marks */

-- Q6) write a query to find total number of products in each category.

SELECT COUNT(DISTINCT product_id), category
FROM orders
GROUP BY category 

-- Q7) write a query to find top 5 sub categories in west region by total quantity sold

SELECT TOP 5 sub_category, SUM(quantity) as total_quantity
FROM orders
WHERE region = 'West'
GROUP BY sub_category
ORDER BY total_quantity DESC 

-- Q8) write a query to find total sales for each region and ship mode combination for orders in year 2020

SELECT region, ship_mode, SUM(sales) AS total_sales 
FROM orders
WHERE order_date BETWEEN '2020-01-01' and '2020-12-31'
GROUP BY region, ship_mode 