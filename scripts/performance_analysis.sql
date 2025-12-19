--PERFORMANCE ANALYSIS
/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
WITH yearly_product_sales as
(
SELECT 
YEAR(order_date) as order_date,
pr.product_name as product_name,
SUM(sales_amount) as current_sales
FROM gold.fact_sales as sl
LEFT JOIN gold.dim_products as pr
ON sl.product_key = pr.product_key
WHERE order_date IS NOT NULL
Group by YEAR(order_date), pr.product_name
)
SELECT order_date, 
product_name, 
current_sales,
AVG(current_sales) Over (Partition by product_name) as avg_Sales,
current_sales - AVG(current_sales) Over (Partition by product_name) as avg_difference,
CASE WHEN current_sales - AVG(current_sales) Over (Partition by product_name) > 0 THEN 'Above Avg'
	 WHEN current_sales - AVG(current_sales) Over (Partition by product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END as	avg_change,
LAG(current_sales) OVER (Partition by product_name Order by order_date) as py_sales,
CASE WHEN LAG(current_sales) OVER (Partition by product_name Order by order_date) > current_sales THEN 'Increase'
	 WHEN LAG(current_sales) OVER (Partition by product_name Order by order_date) < current_sales THEN 'Decrease'
	 ELSE 'No Change'
END as	py_change
From yearly_product_sales
Order by product_name, YEAR(order_date)
