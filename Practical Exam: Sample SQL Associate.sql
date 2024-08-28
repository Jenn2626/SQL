--Task 1
SELECT DISTINCT

CAST(id AS NUMERIC) AS id,

COALESCE(CAST(customer_id AS NUMERIC), 0) AS customer_id,

COALESCE(category, 'Other') AS category,

COALESCE(REPLACE(status, '-', 'Resolved'), 'Resolved') AS status,

CASE

WHEN EXTRACT(YEAR FROM creation_date) = 2023 THEN creation_date

ELSE '2023-01-01'

END AS creation_date,

COALESCE(CAST(response_time AS NUMERIC), 0) AS response_time,

ROUND(COALESCE(LEFT(resolution_time, POSITION(' ' IN resolution_time) - 1)::NUMERIC, 0), 2) AS resolution_time

FROM support;

--Task 2
SELECT category,
ROUND(MIN(response_time), 2) AS min_response,
ROUND(MAX(response_time), 2) AS max_response
FROM public.support
GROUP BY public.support.category

--Task3
select

b.rating,

coalesce(b.customer_id,0) customer_id,

a.category,

a.response_time

from survey b

join support a

on
a.customer_id =b.customer_id

where a.category in ('Bug','Installation Problem')
