--EX1
SELECT
  SUM (CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_reviews,
  SUM (CASE WHEN device_type IN ('tablet', 'phone') THEN 1  ELSE 0  END) AS mobile_views
FROM viewership;

--EX2
SELECT x, y , z,
CASE 
WHEN x + y > z and x + z > y and y + z > x then 'Yes'
else 'No'
End as triangle
from triangle;

--EX3
SELECT 
ROUND((SUM(CASE WHEN call_category = 'n/a' OR call_category IS NULL THEN 1 ELSE 0 END) * 100.0)
/ COUNT(*), 1) AS uncategorised_call_pct
FROM callers;

--EX4
SELECT name
FROM Customer
WHERE 
referee_id IS NULL 
OR referee_id <> 2;

--EX5
SELECT survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived;
