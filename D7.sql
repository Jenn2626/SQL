--EX1
SELECT NAME
FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME, 3), ID;

--EX2
SELECT 
user_id,
CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;

--EX3
SELECT 
  manufacturer, 
  CONCAT( '$', ROUND(SUM(total_sales) / 1000000), ' million') AS sales
FROM pharmacy_sales 
GROUP BY manufacturer 
ORDER BY SUM(total_sales) DESC, manufacturer;

--EX4
SELECT 
EXTRACT(month from submit_date ) AS month, 
product_id AS product,
ROUND(AVG(stars),2) as avg_stars
FROM reviews
GROUP BY EXTRACT(month from submit_date ), product_id
ORDER BY month ASC,product;

--EX5
SELECT
sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date )= '8'
AND EXTRACT(YEAR FROM sent_date )= '2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--EX6
SELECT
tweet_id
FROM Tweets 
WHERE LENGTH(content)>15;

--EX7
SELECT
activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;

--EX8
SELECT COUNT(joining_date) AS number_of_employees
FROM employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-07-31';

--EX9
SELECT
POSITION('a' IN first_name) AS position
FROM WORKER
WHERE first_name = 'Amitah';

--EX10
select 
SUBSTRING(title, LENGTH(winery)+2, 4)
from winemag_p2
WHERE COUNTRY ='Macedonia';


