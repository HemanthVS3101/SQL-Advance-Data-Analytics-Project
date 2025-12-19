--CUMULATIVE ANALYSIS
--CALCULATE TOTAL SALES PER MONTH AND RUNNING TOTAL SALES OVER TIME
SELECT order_date,total_sales,average_price,
SUM(total_sales) OVER (PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) as running_total,
AVG(average_price) OVER (PARTITION BY DATETRUNC(YEAR, order_date) ORDER BY order_date) as moving_average
FROM(
SELECT 
DATETRUNC( month, order_date) as order_date,
SUM(sales_amount) as total_sales,
AVG(price) as average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
Group by DATETRUNC( month, order_date)) as t
