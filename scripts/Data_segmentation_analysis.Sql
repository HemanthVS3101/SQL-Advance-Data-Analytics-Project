--DATA SEGMENTATION
/* Segment products into cost ranges and counthow many products fall into each segment */
WITH cost_segment AS (
SELECT
product_key,
product_name,
product_cost,
CASE WHEN product_cost < 100 THEN 'Below 100'
	 WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
	 Else 'Above 1000'
	 END as cost_range
From gold.dim_products)

Select cost_range,
Count(cost_range) as total_products
From cost_segment
group by cost_range
order by total_products desc

--CUSTOMER SEGMENTATION
WITH customer_segment AS (
SELECT 
cs.customer_key as customer_key,
SUM(sl.sales_amount) as total_sales,
MIN(sl.order_date) as first_order,
MAX(sl.order_date) as last_order,
DATEDIFF( month, MIN(sl.order_date), MAX(sl.order_date)) as lifespan
From gold.fact_sales as sl
LEFT JOIN gold.dim_customers as cs
ON sl.customer_key = cs.customer_key
Group by cs.customer_key
)
Select customer_type, count(customer_type) as total_customers
From(
SELECT
customer_key,
CASE WHEN lifespan >= 12 AND total_sales >= 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	 ELSE 'New'
	 END as customer_type
From customer_segment) as t
group by customer_type
