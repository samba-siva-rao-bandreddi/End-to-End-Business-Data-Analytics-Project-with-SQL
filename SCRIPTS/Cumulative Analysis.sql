/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
select
order_date,
total_amount,
avg_price,
sum(total_amount) over(order by order_date) as running_total_sales,
avg(avg_price) over(order by order_date) as moving_avg_sales
from(
select 
DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
sum(sales_amount) as total_amount,
avg(price) as avg_price
from 
fact_sales
where order_date is not null
group by DATE_FORMAT(order_date, '%Y-01-01')

)t