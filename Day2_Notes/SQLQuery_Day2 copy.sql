-- 1)
SELECT *  -- Use * to retrieve all columns from a table
FROM Orders_table;

/* 
Output of Query 2 and 3 chnages drastically. This is because of Order of exe.
TOP will execute in last. 
*/
-- 2) Order of exe. FROM to ORDER BY then TOP 5 
SELECT TOP 5 Order_ID, Order_Date
FROM Orders_table
ORDER BY Order_date DESC;

-- 3) Order of exe. FROM to ORDER BY then TOP 5
SELECT TOP 5 Order_ID, Order_Date
FROM Orders_table
ORDER BY Order_date ;

-- 4)
SELECT TOP 5 *
FROM Orders_table
ORDER BY Order_Date;

-- 5) DINSTICT values 
/*
DISTINCT is used to eliminate duplicate rows from the query result. 
It means that if there are multiple rows with the same values in all the selected columns, 
only one of those rows will appear in the result set.
Works on every data type
*/
SELECT DISTINCT Ship_Mode 
FROM Orders_table;

SELECT DISTINCT Ship_Mode, Segment 
FROM Orders_table;

SELECT DISTINCT *
FROM Orders_table;

-------------------------------- FILTERS -----------------------------------------
-- WHERE filter applies on row always. Same with ORDER BY.

SELECT * 
FROM Orders_table
WHERE Ship_Mode = 'First Class';

SELECT * 
FROM Orders_table
WHERE Order_Date = '2020-12-08';

SELECT * 
FROM Orders_table
WHERE Quantity = 5;

SELECT TOP 5 Order_Date, Quantity
FROM Orders_table
WHERE Quantity >= 5
ORDER BY Quantity DESC;

SELECT  Order_Date, Quantity
FROM Orders_table
WHERE Quantity != 5
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Quantity BETWEEN 5 and 11 -- 5 and 11 are included 
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Ship_Mode IN ('First Class', 'Same Day')
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Quantity NOT IN  (5,11)
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Ship_Mode > 'First Class' -- ASCII value comparison. 
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Ship_Mode = 'First Class' and Segment = 'consumer'
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Ship_Mode = 'First Class' or Segment = 'consumer'
ORDER BY Quantity DESC;

SELECT  *
FROM Orders_table
WHERE Quantity > 5 and Ship_Mode = 'Same Day'
ORDER BY Quantity DESC;

----------------Pattern matching like operators-----------

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'c%' -- first letter should be 'C' (default case insensitive) after that you can have anything

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'C%'

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'chris%' -- must start with 'chris' 

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like '%d' -- name ending with 'd'. Anything can be there before 'd' but must end with 'd'

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like '%ven%' -- start with anything, end with anything but in between there should be 'ven'

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'a%a'

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'c%'

SELECT order_id, order_date, customer_name, UPPER(Customer_Name) as name_upper -- upper function makes all the characters upper case for better filteration
FROM Orders_table
WHERE UPPER(Customer_Name) like 'A%A' 

SELECT order_id, order_date, customer_name, UPPER(Customer_Name) as name_upper -- upper function makes all the characters upper case for better filteration
FROM Orders_table
WHERE UPPER(Customer_Name) like '__A%'  -- third character must be 'A' 

SELECT order_id, order_date, customer_name, UPPER(Customer_Name) as name_upper -- upper function makes all the characters upper case for better filteration
FROM Orders_table
WHERE UPPER(Customer_Name) like 'A%_' ESCAPE '%' -- If I have a '%' in the name then we can use 'escape %' to find the '%' or any special character in the name

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'c[al]%' -- [al] means the second character can be 'a' or 'l'

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'c[^al]%' -- [^al] means second character can be anything but 'a' and 'l'

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Customer_Name like 'c[a-o]%' -- [a-o] means second character can be anything from 'a' to 'o'. like a,b,c,d,e,f,g,h,i,j,k,l,m,o

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Order_ID like 'ca-20[1-2][0-1]%' -- so third number can be [1 or 2] and fourth can be [0 or 1]

SELECT order_id, order_date, customer_name
FROM Orders_table
WHERE Order_ID like 'ca-202[1-2]%' -- fourth number can be [1 or 2]

--------------- Creating New Column -----------------
/*
CAST function create (seeing in output) a new column if we want to change the 
datatype of a particular column.
*/ 

SELECT *, profit/sales as ratio, profit + sales as total 
FROM Orders_table

SELECT *, profit/sales as ratio,GETDATE(), profit + sales as total 
FROM Orders_table  -- GETDATE gives current date and time. 

SELECT CAST(Order_date as DATETIME) as order_date_new, *
FROM Orders_table 



-------------------Assignment------------------------

-- Q1) write a sql to get all the orders where customers name has "a" as second character and "d" as fourth character (58 rows)

SELECT *
FROM Orders_table
WHERE Customer_Name LIKE '_a_d%' ;

-- Q2) write a sql to get all the orders placed in the month of dec 2020 (352 rows) 
SELECT *
FROM Orders_table
WHERE order_date between '2020-12-01' and '2020-12-31'; 

-- Q3) write a query to get all the orders where ship_mode is neither in 'Standard Class' nor in 'First Class' and ship_date is after nov 2020 (944 rows)

SELECT *
FROM Orders_table
WHERE Ship_Mode NOT IN ('Standard Class', 'First Class') AND Ship_Date > '2020-11-30'

-- Q4) write a query to get all the orders where customer name neither start with "A" and nor ends with "n" (9815 rows)

SELECT *
FROM Orders_table
WHERE Customer_Name NOT LIKE 'a%n'

-- Q5)  write a query to get all the orders where profit is negative (1871 rows)

SELECT *
FROM Orders_table
WHERE Profit < 0;

-- Q6) write a query to get all the orders where either quantity is less than 3 or profit is 0 (3348)

SELECT *
FROM Orders_table
WHERE Quantity < 3 OR Profit = 0

-- Q7) your manager handles the sales for South region and he wants you to create a report of all the orders in his region where some discount is provided to the customers (815 rows)

SELECT *
FROM Orders_table
WHERE Region = 'South' AND Discount > 0; 

-- Q8) write a query to find top 5 orders with highest sales in furniture category 

SELECT TOP 5 *
FROM Orders_table
WHERE Category = 'Furniture'
ORDER BY sales DESC

-- Q9) write a query to find all the records in technology and furniture category for the orders placed in the year 2020 only (1021 rows)

SELECT *
FROM Orders_table
WHERE Category IN ('Technology','Furniture') AND Order_Date BETWEEN '2020-01-01' and '2020-12-31'

-- Q10) write a query to find all the orders where order date is in year 2020 but ship date is in 2021 (33 rows)

SELECT *
FROM Orders_table
WHERE Order_Date BETWEEN '2020-01-01' and '2020-12-31' AND Ship_Date BETWEEN '2021-01-01' and '2021-12-31'

