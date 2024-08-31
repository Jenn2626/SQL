--Tak1

SELECT COUNT(*) AS missing_year
FROM products
WHERE year_added IS NULL;

--Task 2

WITH median_values AS 
(
    -- Calculate the median values for weight and price
    SELECT 
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY REPLACE(weight, ' grams', '')::DECIMAL(10, 2)) AS median_weight,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price::DECIMAL(10, 2)) AS median_price
    FROM 
        products
)
SELECT 
    product_id,
    COALESCE(product_type, 'Unknown') AS product_type,
    COALESCE(REPLACE(brand, '-', 'Unknown'), 'Unknown') AS brand,
    COALESCE(ROUND(REPLACE(weight, ' grams', '')::DECIMAL(10, 2), 2), (SELECT median_weight FROM median_values)) AS weight,
    COALESCE(ROUND(price::DECIMAL(10, 2), 2), (SELECT median_price FROM median_values)) AS price,
    COALESCE(average_units_sold, 0) AS average_units_sold,
    COALESCE(year_added, 2022) AS year_added,
    COALESCE(UPPER(stock_location), 'Unknown') AS stock_location
FROM 
    products;

--Task 3

SELECT product_type,
	MIN(price) AS min_price,
	MAX(price) AS max_price
FROM products
GROUP BY product_type;

--Task 4

SELECT 
	product_id, 
	price, 
	average_units_sold
FROM products
WHERE average_units_sold > 10 
AND product_type IN ('Meat', 'Dairy');
