-- Create Database
DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

-- Create Schema (In MySQL you can use database as schema or simulate it via table prefixes)
-- Here, we'll skip schema creation since MySQL uses databases directly

-- Create dim_customers table
CREATE TABLE dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE NULL,
    create_date DATE NULL
);

-- Create dim_products table
CREATE TABLE dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE NULL
);

-- Create fact_sales table
CREATE TABLE fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE NULL,
    shipping_date DATE NULL,
    due_date DATE NULL,
    sales_amount INT,
    quantity TINYINT,
    price INT
);

-- Load data into dim_customers
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gold.dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(customer_key, customer_id, customer_number, first_name, last_name, country, marital_status, gender, @birthdate, @create_date)
SET 
birthdate = NULLIF(@birthdate, ''),
create_date = NULLIF(@create_date, '');


-- Load data into dim_products
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gold.dim_products.csv'
INTO TABLE dim_products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Load data into fact_sales
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gold.fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(order_number, product_key, customer_key, @order_date, @shipping_date, @due_date, sales_amount, quantity, price)
SET 
order_date = NULLIF(@order_date, ''),
shipping_date = NULLIF(@shipping_date, ''),
due_date = NULLIF(@due_date, '');

