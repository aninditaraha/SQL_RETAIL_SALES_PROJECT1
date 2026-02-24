---SQL Retail  Sales Analysis -P1
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
     (
	     transactions_id INT PRIMARY KEY,
		 sale_date DATE,
		 sale_time TIME,
		 customer_id INT,
		 gender VARCHAR(15),
		 age INT,
		 category VARCHAR(15),
		 quantiy INT,
		 price_per_unit FLOAT,
		 cogs FLOAT,
		 total_sale FLOAT
		 );
BULK INSERT retail_sales
FROM 'C:\Users\ANINDITA\Downloads\SQL - Retail Sales Analysis_utf .csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

SELECT * FROM retail_sales;

SELECT COUNT (*)
FROM retail_sales;


SELECT * FROM retail_sales
WHERE transactions_id IS NULL


SELECT * FROM retail_sales
WHERE sale_date IS NULL


SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR 
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
cogs is null
OR
total_sale IS NULL;

DELETE FROM retail_sales
WHERE
transactions_id IS NULL
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR 
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
cogs is null
OR
total_sale IS NULL;

---DATA EXPLORATION
--HOW MANY SALES WE HAVE

SELECT COUNT (*) AS total_sale From retail_sales;

--How many uniq cutomer we have
 SELECT COUNT (DISTINCT customer_id) AS total_sale From retail_sales;
 --how many uniq catagery we have
 SELECT COUNT (DISTINCT category) AS total_sale From retail_sales;
 
 SELECT DISTINCT category FROM retail_sales;

 ---Data Analysis and Business Key Problems and ansewrs
 ---1)Write a SQL query to retrieve all columns for sales made on '2022-11-05:

 SELECT * FROM retail_sales
 WHERE sale_date = '2022-11-05';

 ---2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022:
  SELECT * FROM retail_sales
  WHERE category = 'Clothing'
  AND 
  FORMAT (sale_date, 'yyyy-MM') = '2022-11'
  AND
  quantiy >=4

--3)Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT category, 
SUM(total_sale) AS total_sales,
COUNT (*) AS total_orders
FROM retail_sales
GROUP BY category;

--4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
AVG(AGE) as AVG_AGE
FROM retail_sales
WHERE category ='Beauty'

--5)Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
 WHERE total_sale > 1000

--6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT gender, category,
COUNT (*) as total_transactions
FROM retail_sales
GROUP BY category, gender;

--7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT YEAR, MONTH, avg_sale FROM 
(
SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER(PARTITION BY YEAR(sale_date)
	ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS T1
WHERE rank =1
--ORDER BY YEAR(sale_date), rank;


 --8)Write a SQL query to find the top 5 customers based on the highest total sales **

 SELECT TOP 5 customer_id,
 SUM(total_sale) as TOTAL_SALES
 FROM retail_sales
 GROUP BY customer_id
 ORDER BY 2 DESC

 --9)Write a SQL query to find the number of unique customers who purchased items from each category.:
 
SELECT  COUNT (DISTINCT customer_id) AS CNT_UNIQUE_CS,
 category
FROM retail_sales
GROUP BY category

--10)Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH HOURLY_SALES AS
(
SELECT *,
CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'MORNING'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
    ELSE 'EVENING'
END AS SHIFT
FROM retail_sales
)
SELECT SHIFT, COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALES 
GROUP BY SHIFT;

---END OF PROJECT