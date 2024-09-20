--Revenue by ProductLine, Year and DealSize?
SELECT 
productline, year_id, dealsize, 
SUM(quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj
GROUP BY productline, year_id, dealsize
ORDER BY year_id;
--What is the best selling month of the year?
SELECT
month_id,revenue,
ROW_NUMBER()OVER(ORDER BY revenue desc ) as order_number
FROM
(SELECT
month_id,
SUM(quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj
GROUP BY month_id) As a;
--Which product line had the best saling in November?
SELECT
month_id,productline,revenue,
ROW_NUMBER()OVER(ORDER BY revenue desc ) as order_number
FROM
(SELECT
month_id,productline,
SUM(quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj
WHERE month_id = 11
GROUP BY month_id,productline
) As a;
--What is the best selling product in the UK each year?
SELECT
year_id, productline,revenue,
RANK() OVER( PARTITION BY year_id ORDER BY revenue DESC ) as Rank
FROM
(SELECT
year_id, productline,
SUM(quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj
WHERE country ='UK'
GROUP BY year_id, productline
ORDER BY year_id) AS a;
--Who is the best customer, analysis based on RFM
SELECT
year_id, productline,revenue,
RANK() OVER( PARTITION BY year_id ORDER BY revenue DESC ) as Rank
FROM
(SELECT
year_id, productline,
SUM(quantityordered*priceeach) AS revenue
FROM public.sales_dataset_rfm_prj
WHERE country ='UK'
GROUP BY year_id, productline
ORDER BY year_id) AS a;
--Who is the best customer, analysis based on RFM
WITH customer_rfm AS
(
SELECT 
customername,
current_date - Max(orderdate) as R,
COUNT(DISTINCT customername)as F,
SUM(sales) as M
FROM public.sales_dataset_rfm_prj
GROUP BY customername)
, rfm_score AS(
SELECT customername,
ntile(5) over(order by R DESC) as R_score,
ntile(5) over(order by F ) as F_score,
ntile(5) over(order by M ) as M_score
FROM customer_rfm)
, rfm_final AS (
SELECT 
customername,
CAST(R_score AS VARCHAR) || CAST(F_score AS VARCHAR) || CAST(M_score AS VARCHAR) as rfm_score
FROM rfm_score)

SELECT
segment, count(*)
FROM (
SELECT
a.customername, b.segment
FROM rfm_final AS a
JOIN public.segment_score AS b ON a.rfm_score = b.scores) a
GROUP BY segment
ORDER BY count(*);


