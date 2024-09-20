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

