--CHANGE OVER TIME
SELECT 
DATETRUNC( month, order_date) as order_date,
SUM(sales_amount) as total_sales,
SUM(quantity) as total_quantity,
COUNT(DISTINCT(customer_key)) as total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
Group by DATETRUNC( month, order_date)
Order by order_date
