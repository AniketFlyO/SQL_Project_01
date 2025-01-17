--SQL Project_1
--Retail Analysis
create database sql_project_1;


--CREATE TABLE
create table retail_sales 
		(
				transactions_id	int PRIMARY KEY,
				sale_date		date,
				sale_time		time,
				customer_id		int,
				gender			varchar(15),
				age				int,
				category		varchar(15),
				quantity			int,
				price_per_unit	float,
				cogs			float,
				total_sale 		float
		);

alter table retail_sales rename column "quantiy" to "quantity";

select count(*) from retail_sales;

select * from retail_sales;

--Data Exploration and cleaning
select * from retail_sales
where 
	sale_date is null
	or
	sale_time is null
	or 
	customer_id is null
	or
	gender is null
	or
	age is null
	or 
	category is null
	or 
	quantity is null
	or
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null
	;

--Data cleaning
delete from retail_sales
where sale_date is null
	or
	sale_time is null
	or 
	customer_id is null
	or
	gender is null
	or
	age is null
	or 
	category is null
	or 
	quantity is null
	or
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null
	;

--Data Exploration
--Total sales
select count(*) as total_sales from retail_sales;
--

--Total customers
select count(distinct customer_id) as total_customers from retail_sales;

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity 
--	   sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where 
to_char(sale_date, 'yyyy-mm')= '2022-11'
and category = 'Clothing'
and quantity >= 4 ;
		
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as net_sale, count(total_sale) as net_orders
from retail_sales
group by category;

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender, category, count(transactions_id)
from retail_sales
group by gender, category;

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select max(average), year
from 
(
select avg(total_sale) as average ,extract(year from sale_date ) as year, extract(month from sale_date) as month
from retail_sales
group by year, month
order by year, month
) as all_avg
group by year




SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id, sum(total_sale) as total_sales
from retail_sales
group by total_sale, customer_id
order by total_sale desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select customers, category
from 
	(select distinct(customer_id) as customers, count(customer_id) as sumofcust, category
	from retail_sales
	group by customers, category
	order by customers) as all_cust
where sumofcust = 3;
	
select sums, customer_id
from 
(select  count(customer_id)as sums, customer_id
from 
	(select customer_id, category
	from retail_sales
	group by customer_id, category
	order by customer_id) 
							as sumc
							group by customer_id)
							as sumb
where sums = 3;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

