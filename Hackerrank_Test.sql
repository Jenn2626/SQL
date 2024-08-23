--Merit Rewards
SELECT
a.employee_ID,
a.name
FROM employee_information AS a
JOIN last_quarter_bonus AS b
ON a.employee_ID= b.employee_ID
WHERE a.division = 'HR'
AND b.bonus >=5000,

--Country codes
SELECT
a.customer_id,
a.name,
'+' || b.country_code ||a.phone_number
FROM customers AS a
JOIN country_codes AS b
ON a.country = b.country
ORDER BY a.customer_id;

