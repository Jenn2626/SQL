--EX1
WITH cte_count_job AS
(
SELECT 
company_id,
title,
description,
COUNT(job_id) AS count_job
FROM job_listings
GROUP BY
company_id,
title,
description
)
SELECT 
COUNT(DISTINCT company_id) AS duplicate_companies
FROM cte_count_job 
WHERE count_job >= 2;

--EX2
WITH total_product AS
(
SELECT
category,
product,
SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY 
category,
product
)

SELECT 
a.category,
a.product,
a.total_spend
FROM total_product a
JOIN total_product b
  ON a.category = b.category
  AND a.total_spend <= b.total_spend
GROUP BY
a.category,
a.product,
a.total_spend
HAVING COUNT(b.product) <= 2
ORDER BY a.category, a.total_spend DESC;

--EX3
WITH call_record AS
(
SELECT
policy_holder_id,
COUNT(case_id) AS count_call
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
)

SELECT 
COUNT(policy_holder_id) AS policy_holder_count
FROM call_record;

--EX4
SELECT page_id
FROM pages
WHERE page_id NOT IN (
  SELECT page_id
  FROM page_likes
  WHERE page_id IS NOT NULL
);
--EX5
WITH Previous_Month_Users AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE event_type IN ('sign-in', 'like', 'comment')
      AND event_date >= '2022-06-01'
      AND event_date < '2022-07-01'
),
Current_Month_Users AS (
    SELECT DISTINCT user_id
    FROM user_actions
    WHERE event_type IN ('sign-in', 'like', 'comment')
      AND event_date >= '2022-07-01'
      AND event_date < '2022-08-01'
)
SELECT 7 AS month, COUNT(*) AS monthly_active_users
FROM Current_Month_Users
WHERE user_id IN (SELECT user_id FROM Previous_Month_Users);

--EX6
WITH all_trans AS (
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,  
        country,
        COUNT(*) AS trans_count,
        SUM(amount) AS trans_total_amount
    FROM Transactions
    GROUP BY month, country
),
approved_trans AS (
    SELECT
        DATE_FORMAT(trans_date, '%Y-%m') AS month,  
        country,
        COUNT(*) AS approved_count,
        SUM(amount) AS approved_total_amount
    FROM Transactions
    WHERE state = 'approved'
    GROUP BY month, country
)
SELECT 
    a.month,
    a.country,
    a.trans_count,
    COALESCE(b.approved_count, 0) AS approved_count,  
    a.trans_total_amount,
    COALESCE(b.approved_total_amount, 0) AS approved_total_amount 
FROM all_trans AS a
LEFT JOIN approved_trans AS b
    ON a.month = b.month
    AND a.country = b.country
ORDER BY a.month, a.country;

--EX7
WITH first_year_sale AS
(
SELECT
 product_id,
 MIN(year) AS first_year
FROM Sales
GROUP BY product_id
)
SELECT
b.product_id,
b.first_year,
a.quantity,
a.price
FROM Sales AS a
JOIN first_year_sale AS b
 ON a.product_id = b.product_id
 AND a.year = b.first_year;

--EX8
SELECT
customer_id
FROM Customer
GROUP BY Customer_id
HAVING COUNT(DISTINCT product_key)= (SELECT COUNT(*) FROM Product);

--EX9
SELECT
    emp.employee_id
FROM Employees AS emp
LEFT JOIN Employees AS mng
ON emp.manager_id = mng.employee_id
WHERE emp.salary < 30000
  AND emp.manager_id IS NOT NULL
  AND mng.employee_id IS NULL
ORDER BY emp.employee_id;

--EX9 C2
SELECT employee_id
FROM Employees
WHERE salary < 30000
  AND manager_id IS NOT NULL
  AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id;

--EX10
WITH cte_count_job AS
(
SELECT 
company_id,
title,
description,
COUNT(job_id) AS count_job
FROM job_listings
GROUP BY
company_id,
title,
description
)
SELECT 
COUNT(DISTINCT company_id) AS duplicate_companies
FROM cte_count_job 
WHERE count_job >= 2

--EX11
(SELECT name AS results
FROM Users
JOIN MovieRating 
ON MovieRating.user_id = Users.user_id
GROUP BY name
ORDER BY COUNT(MovieRating.movie_id) DESC, name ASC
LIMIT 1)

UNION ALL

(SELECT title AS results
FROM Movies
JOIN MovieRating
ON MovieRating.movie_id = Movies.movie_id
WHERE EXTRACT(YEAR FROM MovieRating.created_at) = 2020
AND EXTRACT(MONTH FROM MovieRating.created_at) = 2
GROUP BY title
ORDER BY AVG(MovieRating.rating) DESC, title ASC
LIMIT 1)

--EX12
WITH count_friend AS 
(
SELECT
user_id,
COUNT(*) AS num
FROM 
(
(SELECT requester_id AS user_id
FROM RequestAccepted)
UNION ALL
(SELECT accepter_id AS user_id
FROM RequestAccepted)
) AS all_friend
GROUP BY user_id
)
SELECT 
user_id AS id,
num
FROM count_friend
WHERE num = 
(SELECT 
MAX(num) AS max_num
FROM count_friend);



