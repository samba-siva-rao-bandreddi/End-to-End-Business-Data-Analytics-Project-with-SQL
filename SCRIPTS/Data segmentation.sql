/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/
with product_segments as
(
select 
product_key,
product_name,
cost,
CASE
	WHEN cost<100 THEN 'Below 100'
    WHEN COST between 100 AND 500 THEN '100-500'
	WHEN COST between 500 AND 1000 THEN '500-1000'
    ELSE 'Above 1000'
END cost_range
from dim_products)
select 
cost_range,
count(product_key) as total_products
from product_segments
group by cost_range
order by total_products desc;



/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
with customer_spending as(
select 
c.customer_key,
sum(f.sales_amount) as total_sales,
min(f.order_date) as first_order,
max(order_date) as last_order,
TIMESTAMPDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
from fact_sales f
left join dim_customers c
on f.customer_key=c.customer_key
group by c.customer_key)

select
customer_segment,
count(customer_key) as total_customers
from(
select 
customer_key,
CASE
	WHEN LIFESPAN>=12 AND TOTAL_SALES>5000 THEN 'VIP'
    WHEN LIFESPAN>=12 AND TOTAL_SALES<=5000 THEN 'REGULAR'
    ELSE 'NEW' 
END Customer_segment
from customer_spending) t
group by customer_segment
order by total_customers desc;

	












