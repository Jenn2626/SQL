--Task 1
SELECT 
    id:: NUMERIC AS id,
    COALESCE(location, 'Unknown') AS location,
    CASE
        WHEN total_rooms BETWEEN 1 AND 400 THEN total_rooms
        ELSE 100
    END AS total_rooms,
    CASE
        WHEN staff_count IS NOT NULL THEN staff_count
        ELSE total_rooms * 1.5
    END AS staff_count,
    CASE
        WHEN opening_date = '-' THEN '2023'
        WHEN opening_date BETWEEN '2000' AND '2023' THEN opening_date
        ELSE '2023'
    END AS opening_date,
    CASE
        WHEN target_guests IS NULL THEN 'Leisure'
        WHEN LOWER(target_guests) LIKE 'b%' THEN 'Business'
        ELSE target_guests END AS target_guests
FROM 
    public.branch;

--Task 2
SELECT 
	service_id, 
	branch_id,
	ROUND(AVG(time_taken), 2) AS avg_time_taken,
	MAX(time_taken) AS max_time_taken
FROM public.request
GROUP BY 
	service_id, 
	branch_id;

--Task 3
SELECT

    s.description AS description,

    b.id AS id,

    b.location AS location,

    r.id AS request_id,

    r.rating AS rating

FROM

    request r

    JOIN branch b ON b.id = r.branch_id

    JOIN service s ON r.service_id = s.id

WHERE

    s.description IN ('Meal', 'Laundry')

    AND b.location IN ('EMEA', 'LATAM');

--Task 4
SELECT 
	service_id,
	branch_id,
	ROUND(AVG(rating), 2) AS avg_rating
FROM public.request
GROUP BY 
	service_id,
	public.request.branch_id
HAVING AVG(rating) < 4.5;
