/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/
WITH yearly_product_sales AS (
    SELECT 
        YEAR(order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM 
        fact_sales f
    LEFT JOIN 
        dim_products p ON f.product_key = p.product_key
    WHERE 
        order_date IS NOT NULL
    GROUP BY 
        YEAR(order_date), p.product_name
)
SELECT 
order_year,
product_name,
current_sales,
ROUND(AVG(current_sales) OVER (PARTITION BY product_name)) AS avg_sales,
current_sales-ROUND(AVG(current_sales) OVER (PARTITION BY product_name)) as diff_avg,
CASE
	WHEN current_sales-ROUND(AVG(current_sales) OVER (PARTITION BY product_name))>0 THEN 'ABOVE AVG'
    WHEN current_sales-ROUND(AVG(current_sales) OVER (PARTITION BY product_name))<0 THEN 'BELOW AVG'
    ELSE 'AVG'
END AS avg_change,
lag(current_sales) over(partition by product_name order by order_year) as pre_sales,
current_sales-lag(current_sales) over(partition by product_name order by order_year) as diff_pre,
CASE
	WHEN current_sales-lag(current_sales) over(partition by product_name order by order_year)>0 THEN 'INCREASE'
    WHEN current_sales-lag(current_sales) over(partition by product_name order by order_year)<0 THEN 'DECRESASE'
    ELSE 'NO CHANGE'
END as prev_change
FROM yearly_product_sales
order by product_name,order_year;
