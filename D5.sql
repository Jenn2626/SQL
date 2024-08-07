--EX1
SELECT DISTINCT CITY
FROM STATION
WHERE ID%2 = 0;

--EX2
SELECT  
(COUNT(CITY) - COUNT(DISTINCT CITY) ) AS DIFFERENCE
FROM STATION;
--EX4

SELECT 
ROUND(CAST(SUM(item_count * order_occurrences) AS DECIMAL) / SUM(order_occurrences), 1) AS mean
FROM items_per_order;

--EX5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT( skill) = 3
ORDER BY candidate_id ASC;

--EX7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

--EX8
SELECT 
  manufacturer,
  COUNT(DRUG) AS drug_count,
  ABS(SUM(cogs - total_sales)) AS total_loss
FROM 
  pharmacy_sales
WHERE total_sales < cogs
GROUP BY 
  manufacturer
ORDER BY total_loss DESC;

---EX9
SELECT
    id , movie, description, rating  
FROM Cinema
WHERE id % 2 <> 0
and description <> 'boring'
order by rating desc

--EX10
SELECT 
    teacher_id,
COUNT(DISTINCT subject_id) AS cnt
from Teacher 
group by teacher_id

--EX11
SELECT 
 user_id, 
 COUNT( user_id)AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id ASC

--EX12
SELECT
class
FROM Courses
GROUP BY class
HAVING COUNT(class) >= 5

--EX6
SELECT 
  user_id,
  EXTRACT(DAY FROM (MAX(post_date) - MIN(post_date))) AS days_between
FROM posts
WHERE EXTRACT(YEAR FROM post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) >= 2
