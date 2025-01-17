## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
select * from retail_sales
where sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or category is null or quantity is null or price_per_unit is null or cogs is null or total_sale is null
	;

--Data cleaning
delete from retail_sales
where sale_date is null or sale_time is null or customer_id is null or gender is null or age is null or category is null or quantity is null or price_per_unit null
or cogs is null or total_sale is null
	;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retail_sales
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_sales 
where 
to_char(sale_date, 'yyyy-mm')= '2022-11'
and category = 'Clothing'
and quantity >= 4 ;
		
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,sum(total_sale) as net_sale, count(total_sale) as net_orders
from retail_sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * 
from retail_sales
where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select gender, category, count(transactions_id)
from retail_sales
group by gender, category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select max(average), year
from 
(
select avg(total_sale) as average ,extract(year from sale_date ) as year, extract(month from sale_date) as month
from retail_sales
group by year, month
order by year, month
) as all_avg
group by year
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id, sum(total_sale) as total_sales
from retail_sales
group by total_sale, customer_id
order by total_sale desc
limit 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
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
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```
