--PJ2.2.1
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
--Total profit
ROUND((TPV - total_cost),2) AS total_profit,
-- Profit to Cost Ratio as percentage
ROUND(((TPV - total_cost) / total_cost) * 100, 2) || '%'AS profit_to_cost_ratio
FROM main_data
--PJ2.2.2
WITH combine_amount AS 
(SELECT
oi.*, 
o.num_of_item,
oi.sale_price* o.num_of_item AS amount
FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
JOIN bigquery-public-data.thelook_ecommerce.orders AS o
  ON oi.order_id = o.order_id)

, main_table AS(
SELECT *FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, id, num_of_item, product_id ORDER BY created_at) AS dup_flag
FROM combine_amount)AS a
WHERE dup_flag = 1)
,first_purchase AS(
SELECT
user_id,
amount,
MIN(created_at) OVER(PARTITION BY user_id) AS first_purchase_date,
created_at
FROM main_table)
, index_table AS(
SELECT
user_id,
amount,
FORMAT_TIMESTAMP('%Y-%m', first_purchase_date) AS cohort_date,
created_at,
(EXTRACT(YEAR FROM created_at)- EXTRACT(YEAR FROM first_purchase_date)) * 12 + 
(EXTRACT(MONTH FROM created_at)- EXTRACT(MONTH FROM first_purchase_date)) +1 AS index
FROM first_purchase)
, count_table AS (
SELECT
cohort_date,
index,
count(distinct user_id) AS cnt,
SUM(amount) AS total_amount
FROM index_table
GROUP BY cohort_date,
index)
--COHORT CHART (PIVOT TABLE)
, customer_cohort AS (
SELECT
cohort_date,
SUM(CASE WHEN index =1 then cnt else 0 end) AS m1,
SUM(CASE WHEN index =2 then cnt else 0 end) AS m2,
SUM(CASE WHEN index =3 then cnt else 0 end) AS m3,
SUM(CASE WHEN index =4 then cnt else 0 end) AS m4
FROM count_table
GROUP BY cohort_date
ORDER BY cohort_date)
--RETENTION COHORT
SELECT
cohort_date,
(100-round(m1/m1 * 100, 2)) || '%' AS m1,
(100-round(m2/m1 * 100, 2)) || '%' AS m2,
(100-round(m3/m1 * 100, 2)) || '%' AS m3,
(100-round(m4/m1 * 100, 2)) || '%' AS m4
FROM customer_cohort
--CHURN COHORT





