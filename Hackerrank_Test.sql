SELECT
a.employee_ID,
a.name
FROM employee_information AS a
JOIN last_quarter_bonus AS b
ON a.employee_ID= b.employee_ID
WHERE a.division = 'HR'
AND b.bonus >=5000
