--Task 1
WITH CTE_year_month AS
(
SELECT  
extract(year from created_at) as year,
extract(month from created_at) as month,
count(distinct user_id) as total_user,
sum(order_id) as total_order
FROM `bigquery-public-data.thelook_ecommerce.orders` 
where status IN ('Complete')
and created_at BETWEEN '2019-01-01 00:00:00' AND '2022-04-30 23:59:59'
GROUP BY year, month
)
SELECT
    year || '-' || LPAD(CAST(month AS STRING), 2, '0') AS month_year, 
    total_user,
    total_order
FROM CTE_year_month
ORDER BY month_year;

/*Insight: New customer has increased steadily, depend on inscreasing new customer total orders also insceased*/

--Task 2
WITH avg_value AS (
SELECT 
EXTRACT(YEAR FROM oi.created_at) AS year,
EXTRACT(MONTH FROM oi.created_at) AS month,
COUNT(DISTINCT oi.user_id) AS distinct_users,
sum(oi.sale_price * o.num_of_item) / sum(oi.order_id) AS average_order_value
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN bigquery-public-data.thelook_ecommerce.orders AS o
ON oi.order_id = o.order_id
where oi.status IN ('Complete', 'Shipped')
and oi.created_at BETWEEN '2019-01-01 00:00:00' AND '2022-04-30 23:59:59'
Group by year, month)
SELECT 
  year || '-' || LPAD(CAST(month AS STRING),2,'0') AS month_year,
  distinct_users, 
  average_order_value
FROM avg_value
ORDER BY month_year;

/*Insight: New customer has increased steadily, average sale value also insceased*/

--Task 3 window function
WITH age_status AS 
(
SELECT
first_name,last_name,gender,age,
rank() over(partition by gender order by age ASC) AS min_age,
rank() over(partition by gender order by age DESC) AS max_age
FROM bigquery-public-data.thelook_ecommerce.users
WHERE created_at BETWEEN '2019-01-01 00:00:00' AND '2022-04-30 23:59:59')

SELECT
first_name,last_name,gender,age,
CASE
  WHEN min_age = 1 then 'youngest'  
  WHEN max_age = 1 then  'oldest'
END AS tag
FROM age_status
WHERE min_age = 1 OR max_age = 1

--Task 3 Union
WITH cte AS (
SELECT first_name,last_name,gender,age
    FROM bigquery-public-data.thelook_ecommerce.users
    WHERE created_at BETWEEN '2019-01-01 00:00:00' AND '2022-04-30 23:59:59')

,age_status AS (
SELECT gender,
  MIN(age) AS min_age,
  MAX(age) AS max_age
FROM cte
GROUP BY gender
),

Youngest_Customers AS (
SELECT
first_name,last_name,df.gender,age,
 'youngest' AS tag
FROM cte df
JOIN age_status ast ON df.gender = ast.gender
WHERE df.age = ast.min_age
),

Oldest_Customers AS (
SELECT
first_name,last_name,df.gender,age,
  'oldest' AS tag
FROM cte df
JOIN age_status ast ON df.gender = ast.gender
WHERE df.age = ast.max_age
)

SELECT * FROM Youngest_Customers
UNION ALL
SELECT * FROM Oldest_Customers
ORDER BY gender, tag;
/*coun*/
--Window function
WITH age_status AS 
(
SELECT
first_name,last_name,gender,age,
rank() over(partition by gender order by age ASC) AS min_age,
rank() over(partition by gender order by age DESC) AS max_age
FROM bigquery-public-data.thelook_ecommerce.users
WHERE created_at BETWEEN '2019-01-01 00:00:00' AND '2022-04-30 23:59:59')
)

SELECT 
    'youngest' AS tag,
    COUNT(*) AS count_of_customers
FROM age_status
WHERE  min_age = 1

UNION ALL

SELECT 
    'oldest' AS tag,
    COUNT(*) AS count_of_customers
FROM age_status
WHERE  max_age = 1;
---
SELECT 
    'youngest' AS tag,
    COUNT(*) AS count_of_customers
FROM Youngest_Customers

UNION ALL

SELECT 
    'oldest' AS tag,
    COUNT(*) AS count_of_customers 
FROM Oldest_Customers;
/*Insight: Youngest 12 yo qty 992, oldest 70 yo qty 996*/
--Taak 4
WITH detail_infor AS 
(
SELECT 
EXTRACT(YEAR FROM oi.created_at) AS year,
EXTRACT(MONTH FROM oi.created_at) AS month,
ii.product_id, 
ii.product_name,
SUM(o.num_of_item * oi.sale_price) AS total_sale,
SUM(o.num_of_item * ii.cost) AS total_cost,
SUM(o.num_of_item * oi.sale_price) - SUM(o.num_of_item * ii.cost) AS profit
FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
JOIN bigquery-public-data.thelook_ecommerce.inventory_items AS ii
  ON oi.product_id = ii.product_id
JOIN bigquery-public-data.thelook_ecommerce.orders AS o
  ON o.order_id = oi.order_id
WHERE oi.status = 'Complete'
GROUP BY year, month, ii.product_id, ii.product_name
)
, ranked_infor AS
(
SELECT
CONCAT(CAST(year AS STRING), '-', LPAD(CAST(month AS STRING), 2, '0')) AS month_year,
product_id, product_name,
total_sale AS sales,
total_cost AS cost,
profit,
DENSE_RANK() OVER (PARTITION BY year, month ORDER BY profit DESC) AS rank_per_month
FROM detail_infor
)
SELECT
*
FROM ranked_infor
WHERE rank_per_month <= 5
ORDER BY month_year, rank_per_month;

--Task 5
WITH main_table AS
(
SELECT
EXTRACT(DATE FROM o.created_at) AS dates,
ii.product_category,
SUM(oi.sale_price * o.num_of_item) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
JOIN bigquery-public-data.thelook_ecommerce.orders AS o 
ON oi.order_id = o.order_id
JOIN bigquery-public-data.thelook_ecommerce.inventory_items AS ii
ON ii.product_id = oi.product_id
WHERE o.status = 'Complete'
GROUP BY dates, ii.product_category
)
SELECT 
*
FROM main_table
where dates BETWEEN DATE_ADD('2022-04-15', INTERVAL -3 MONTH) AND '2022-04-15'
order by dates DESC




