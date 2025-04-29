/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- Total_sales as Order by year
select 
year(order_date),
sum(sales_amount) as total_sales
from fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date) ;

-- Number of Distinct Customers AND Total Quantity by Year
select 
year(order_date),
sum(sales_amount) as total_sales,
count( Distinct customer_key) as Total_customers,
sum(quantity) as Total_quantity
from fact_sales
where order_date is not null
group by year(order_date)
order by year(order_date) ;


-- BY MONTH
select 
month(order_date) as order_by_month,
sum(sales_amount) as total_sales,
count( Distinct customer_key) as Total_customers,
sum(quantity) as Total_quantity
from fact_sales
where order_date is not null
group by month(order_date)
order by month(order_date) ;


select 
 DATE_FORMAT(order_date, '%Y-%m-01') as order_by_month,
sum(sales_amount) as total_sales,
count( Distinct customer_key) as Total_customers,
sum(quantity) as Total_quantity
from fact_sales
where order_date is not null
group by  DATE_FORMAT(order_date, '%Y-%m-01')
order by  DATE_FORMAT(order_date, '%Y-%m-01') ;



select 
 DATE_FORMAT(order_date, '%Y-%b') as order_by_month,
sum(sales_amount) as total_sales,
count( Distinct customer_key) as Total_customers,
sum(quantity) as Total_quantity
from fact_sales
where order_date is not null
group by  DATE_FORMAT(order_date, '%Y-%b')
order by  DATE_FORMAT(order_date, '%Y-%b') ;

















