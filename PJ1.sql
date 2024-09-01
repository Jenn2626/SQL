--1 Change data type
--change data type column ordernumber from varchar to interger
ALTER TABLE public.sales_dataset_rfm_prj
ALTER column ordernumber TYPE INTEGER USING (ordernumber::INTEGER);

--change data type column quantityordered from varchar to interger
ALTER TABLE public.sales_dataset_rfm_prj
ALTER column quantityordered TYPE INTEGER USING (quantityordered::INTEGER);

--change data type column priceeach from varchar to numeric
ALTER TABLE public.sales_dataset_rfm_prj
ALTER column priceeach TYPE NUMERIC USING (priceeach::NUMERIC);

--change data type column orderlinenumber from varchar to integer
ALTER TABLE public.sales_dataset_rfm_prj
ALTER column orderlinenumber TYPE INTEGER USING (orderlinenumber::INTEGER);

--change data type column sales from varchar to numeric
ALTER TABLE public.sales_dataset_rfm_prj
ALTER column sales TYPE NUMERIC USING (sales::NUMERIC);

--change data type column orderdate from varchar to numeric
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE TIMESTAMP USING (orderdate::TIMESTAMP);

--2. Check NULL/BLANK (‘’) : ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT *
FROM public.sales_dataset_rfm_prj
WHERE 
    ordernumber IS NULL OR
    quantityordered IS NULL OR
    priceeach IS NULL OR
    orderlinenumber IS NULL OR
    sales IS NULL OR
    orderdate IS NULL;

--3 Add CONTACTLASTNAME, CONTACTFIRSTNAME from CONTACTFULLNAME
-- Add new columns
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(100),
ADD COLUMN CONTACTFIRSTNAME VARCHAR(100);

-- Update new columns with CONTACTLASTNAME, CONTACTFIRSTNAME FROM CONTACTFULLNAME
--Determine '-' POSITION('-' IN contactfullname)
UPDATE public.sales_dataset_rfm_prj
SET
    CONTACTLASTNAME = substring(CONTACTFULLNAME FROM 1 FOR position('-' IN CONTACTFULLNAME) - 1),
    CONTACTFIRSTNAME = substring(CONTACTFULLNAME FROM position('-' IN CONTACTFULLNAME) + 1);

-- Standardize the format: first letter uppercase, rest lowercase
UPDATE public.sales_dataset_rfm_prj
SET
    CONTACTFIRSTNAME = initcap(lower(CONTACTFIRSTNAME)),
    CONTACTLASTNAME = initcap(lower(CONTACTLASTNAME));
--OR USE ||
UPDATE public.sales_dataset_rfm_prj
SET
    CONTACTFIRSTNAME = upper(substring(CONTACTFIRSTNAME FROM 1 FOR 1)) || lower(substring(CONTACTFIRSTNAME FROM 2)),
    CONTACTLASTNAME = upper(substring(CONTACTLASTNAME FROM 1 FOR 1)) || lower(substring(CONTACTLASTNAME FROM 2));

-- 4 QTR_ID, MONTH_ID, YEAR_ID FROM ORDERDATE 
--Add new columns
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID INTEGER,
ADD COLUMN MONTH_ID INTEGER,
ADD COLUMN YEAR_ID INTEGER;

--Extract
UPDATE public.sales_dataset_rfm_prj
SET
    QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

-- Find outlier for QUANTITYORDERED
--Find outlier
WITH cte AS (
SELECT ordernumber,quantityordered, 
	(SELECT AVG(quantityordered)
FROM public.sales_dataset_rfm_prj) AS avg_qty,
	(SELECT STDDEV(quantityordered)
FROM public.sales_dataset_rfm_prj) AS stddev_qty
FROM public.sales_dataset_rfm_prj
	)
	cte_outlier AS(
SELECT ordernumber,quantityordered, 
	(quantityordered-avg_qty) / stddev_qty AS z_code
FROM cte
	where abs((quantityordered-avg_qty) / stddev_qty) >3)

-- Update outlier
Update public.sales_dataset_rfm_prj
set quantityordered = (SELECT AVG(quantityordered)
FROM public.sales_dataset_rfm_prj)
where quantityordered IN (SELECT quantityordered FROM cte_outlier),





