--EX1
WITH main_transaction AS 
(
SELECT 
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
SUM(spend) AS curr_year_spend
FROM 
user_transactions
GROUP BY 
EXTRACT(YEAR FROM transaction_date),
product_id
ORDER BY     
product_id
)

SELECT 
year,
product_id,
curr_year_spend,
LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year) AS prev_year_spend,
ROUND(100*(curr_year_spend-LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year))
/LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year),2) AS yoy_rate
FROM main_transaction;

--EX2
WITH card_launches AS (
SELECT 
card_name,
FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) 
AS launch_issued_amount
FROM monthly_cards_issued
)
SELECT 
card_name,
launch_issued_amount AS issued_amount
FROM card_launches
GROUP BY card_name,
issued_amount
ORDER BY issued_amount DESC;

--EX3 WITH LEAD
WITH lead_trs AS
(
SELECT 
user_id,
spend,
LEAD(spend,2) OVER(PARTITION BY user_id ORDER BY transaction_date)
AS third_spend,
LEAD(transaction_date,2) OVER(PARTITION BY user_id ORDER BY transaction_date)
AS third_transaction_date
FROM transactions)

SELECT
user_id,
third_spend AS spend,
third_transaction_date AS transaction_date
FROM lead_trs
WHERE third_spend IS NOT NULL

--EX3 WIH ROW _NUMBER
WITH rank_trs AS
(
SELECT 
user_id,
spend,
transaction_date,
row_number () OVER(PARTITION BY user_id ORDER BY transaction_date)
AS third_trans
FROM transactions)

SELECT
user_id,
spend,
transaction_date
FROM rank_trs
WHERE third_trans = 3

--EX4
WITH main_trs AS 
(
SELECT 
user_id,
transaction_date,
COUNT(product_id) OVER (PARTITION BY user_id, transaction_date) AS purchase_count,
MAX(transaction_date) OVER (PARTITION BY user_id) AS the_most_recent_transaction
FROM user_transactions
)

SELECT
the_most_recent_transaction AS transaction_date,
user_id,
purchase_count
FROM main_trs
WHERE transaction_date = the_most_recent_transaction
GROUP BY 
the_most_recent_transaction, user_id, purchase_count
ORDER BY 
the_most_recent_transaction;

--EX5
WITH tweet_lag AS
(
SELECT
user_id,
tweet_date,
tweet_count,
LAG(tweet_count, 1) OVER (PARTITION BY user_id ORDER BY tweet_date) 
AS prev_count_1,
LAG(tweet_count, 2) OVER (PARTITION BY user_id ORDER BY tweet_date) 
AS prev_count_2
FROM tweets)

SELECT
user_id,
tweet_date,
ROUND((tweet_count + COALESCE(prev_count_1, 0) + COALESCE(prev_count_2, 0)) / 
(CASE
  WHEN prev_count_1 IS NULL AND prev_count_2 IS NULL THEN 1
  WHEN prev_count_1 IS NULL OR prev_count_2 IS NULL THEN 2
  ELSE 3
  END::numeric),  2) AS rolling_avg_3d
FROM tweet_lag
ORDER BY
user_id, 
tweet_date;

--EX6

WITH Repeated_Payments AS
(
SELECT
transaction_id,
merchant_id,
credit_card_id,
amount,
transaction_timestamp,
LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount 
ORDER BY transaction_timestamp) AS prev_timestamp
FROM transactions
)
SELECT
COUNT(transaction_id) AS payment_count
FROM Repeated_Payments
WHERE EXTRACT(EPOCH FROM (transaction_timestamp - prev_timestamp)) <= 600;

--EX7
WITH spend_ranking AS
(
SELECT 
  category, 
  product, 
  SUM(spend) AS total_spend,
  RANK() OVER(PARTITION BY category ORDER BY  SUM(spend) DESC)
  AS ranking
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product
)
SELECT 
  category, 
  product, 
  total_spend 
FROM spend_ranking 
WHERE ranking <= 2 
ORDER BY category, ranking;

--EX8
WITH top_10 AS (
SELECT 
  a.artist_name,
  COUNT(b.song_id) AS song_count,
  DENSE_RANK() OVER (ORDER BY COUNT(b.song_id) DESC) AS artist_rank
  FROM artists AS a 
    JOIN songs AS b 
    ON a.artist_id = b.artist_id
    JOIN global_song_rank AS c 
    ON c.song_id = b.song_id
  WHERE c.rank <= 10
  GROUP BY a.artist_name
)

SELECT 
  artist_name,
  artist_rank
FROM top_10
WHERE artist_rank <= 5

    

