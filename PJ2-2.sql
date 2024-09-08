-- Create a VIEW named vw_ecommerce_analyst
CREATE OR REPLACE VIEW vw_ecommerce_analyst AS
WItH main_data AS 
(
SELECT
EXTRACT(YEAR FROM oi.created_at) AS year,
FORMAT_TIMESTAMP('%Y-%m', oi.created_at) AS month,
p.category AS product_category,
ROUND(SUM(oi.sale_price * o.num_of_item),2) AS TPV,
COUNT(DISTINCT oi.order_id) AS TPO,
ROUND(SUM(p.cost * o.num_of_item),2) AS total_cost,
FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
JOIN bigquery-public-data.thelook_ecommerce.orders AS o
ON oi.order_id= o.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS p
ON oi.id = p.id

GROUP BY year,month,product_category
)
SELECT
year,month,product_category,
TPV,TPO,
--Revenue Growth as percentage
ROUND(((TPV - LAG(TPV) OVER (ORDER BY month)) / LAG(TPV) OVER (ORDER BY month)) * 100, 2) || '%' AS revenue_growth,
-- Order Growth as percentage
ROUND(((TPO - LAG(TPO) OVER (ORDER BY month)) / LAG(TPO) OVER (ORDER BY month)) * 100, 2) || '%' AS order_growth,
total_cost,
--Totl profit
ROUND((TPV - total_cost),2) AS total_profit,
-- Profit to Cost Ratio as percentage
ROUND(((TPV - total_cost) / total_cost) * 100, 2) || '%'AS profit_to_cost_ratio
FROM main_data
