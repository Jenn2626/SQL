--EX1
SELECT
    B.Continent,
    FLOOR(AVG(A.Population)) AS Avg_City_Population
FROM CITY AS A
INNER JOIN COUNTRY AS B
ON A.CountryCode = B.Code
GROUP BY B.Continent;

--EX2
SELECT 
  ROUND(CAST(COUNT(texts.email_id) AS DECIMAL)
    /COUNT(DISTINCT emails.email_id),2) AS confirm_rate
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND texts.signup_action = 'Confirmed'; 

--EX3
SELECT 
  age.age_bucket, 
  
  ROUND(
    100.0 * SUM(CASE WHEN activities.activity_type = 'send' THEN activities.time_spent ELSE 0 END) / 
    (SUM(CASE WHEN activities.activity_type = 'send' THEN activities.time_spent ELSE 0 END) +
     SUM(CASE WHEN activities.activity_type = 'open' THEN activities.time_spent ELSE 0 END)),
    2
  ) AS send_perc,
  
  ROUND(
    100.0 * SUM(CASE WHEN activities.activity_type = 'open' THEN activities.time_spent ELSE 0 END) / 
    (SUM(CASE WHEN activities.activity_type = 'send' THEN activities.time_spent ELSE 0 END) +
     SUM(CASE WHEN activities.activity_type = 'open' THEN activities.time_spent ELSE 0 END)),
    2
  ) AS open_perc
  
FROM activities
JOIN age_breakdown AS age 
ON activities.user_id = age.user_id 
AND activities.activity_type IN ('send', 'open') 
GROUP BY age.age_bucket;

---EX4
WITH supercloud_cust AS (
  SELECT 
  customers.customer_id, 
  COUNT(DISTINCT products.product_category) AS product_count
  FROM customer_contracts AS customers
  JOIN products 
  ON customers.product_id = products.product_id
  GROUP BY customers.customer_id
)

SELECT customer_id
FROM supercloud_cust
WHERE product_count = (
  SELECT COUNT(DISTINCT product_category) FROM products
);

--EX5
SELECT 
mng.employee_id,
mng.name,
COUNT(epm.employee_id) AS reports_count,
ROUND(AVG(epm.age)) AS average_age

FROM Employees AS mng
JOIN Employees AS epm
ON mng.employee_id = epm.reports_to
GROUP BY mng.employee_id, mng.name
ORDER BY mng.employee_id;

--EX6
SELECT 
Products.product_name,
sum(Orders.unit) AS unit

FROM Products 
LEFT JOIN Orders
ON Products.product_id = Orders.product_id
Where extract(year from orders.order_date)= 2020 
AND extract(month from orders.order_date )= 2
  
Group by Products.product_name
having sum(Orders.unit) >= 100;

--EX7
SELECT 
pages.page_id

FROM pages
LEFT JOIN page_likes AS likes
ON pages.page_id = likes.page_id
WHERE likes.page_id IS NULL
ORDER BY pages.page_id ASC

--Mid course test
--EX1
SELECT 
	DISTINCT replacement_cost
FROM public.film
ORDER BY replacement_cost;

--EX2
SELECT 
CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'LOW'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'MEDIUM'
	ELSE 'HIGH'
END AS cost_category,
COUNT (*)AS film_count
	
FROM public.film
GROUP BY cost_category;

--EX3
SELECT 
	A.title,
	A.length, 
	C.name as category_name
	
FROM public.film AS A
JOIN public.film_category AS B 
ON A.film_id = B.film_id
JOIN public.category AS C
ON B.category_id = C.category_id
  
WHERE C.name IN('Drama','Sports')
ORDER BY A.length DESC;

--EX4
SELECT 
	C.name as category_name,
	COUNT(*) AS film_count
FROM public.film AS A
JOIN public.film_category AS B 
ON A.film_id = B.film_id
JOIN public.category AS C
ON B.category_id = C.category_id
GROUP BY C.name
ORDER BY film_count DESC;

--EX5
SELECT
A.first_name || ' ' ||A.last_name AS actor_name,
count(*) as film_count
	
FROM public.actor AS A
JOIN public.film_actor AS B
ON A.actor_id = B. actor_id
GROUP BY A.first_name, A.last_name
ORDER BY film_count DESC

--EX6
SELECT
count(*) as quantity
FROM public.address AS address 
LEFT JOIN public.customer AS customer
ON customer.address_id= address.address_id
WHERE customer.customer_id IS NULL;

--EX7
SELECT 
	public.city.city,
	SUM(public.payment.amount) AS total_revenue
	
FROM public.city
JOIN public.address
ON city.city_id= address.city_id
JOIN public.customer
ON address.address_id= customer.address_id
JOIN public.payment
ON payment.customer_id= customer.customer_id

GROUP BY public.city.city
ORDER BY total_revenue DESC;

--EX8
SELECT 
	public.city.city || ',' || ' ' || 
	public.country.country AS city_country,
	SUM(public.payment.amount) AS total_revenue
	
FROM public.city
JOIN public.address
ON city.city_id= address.city_id
JOIN public.customer
ON address.address_id= customer.address_id
JOIN public.payment
ON payment.customer_id= customer.customer_id
JOIN public.country
ON city.country_id= country.country_id

GROUP BY city_country
ORDER BY total_revenue DESC;
	
