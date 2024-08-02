---EX1
SELECT NAME
FROM CITY
WHERE Population > 120000
AND CountryCode = 'USA';

---EX2
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN';

---EX3
SELECT CITY, STATE
FROM STATION;

---EX4
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY,1) IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u');

---EX5
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%a' 
   OR CITY LIKE '%e' 
   OR CITY LIKE '%i' 
   OR CITY LIKE '%o' 
   OR CITY LIKE '%u' 
   OR CITY LIKE '%A' 
   OR CITY LIKE '%E' 
   OR CITY LIKE '%I' 
   OR CITY LIKE '%O' 
   OR CITY LIKE '%U';

---EX6
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY,1) NOT IN('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u');

---EX7
SELECT NAME
FROM EMPLOYEE
ORDER BY NAME;

---EX8
SELECT NAME
FROM EMPLOYEE
WHERE SALARY > 2000 
AND MONTHS < 10
ORDER BY EMPLOYEE_ID ASC;

---EX9
SELECT PRODUCT_ID
FROM PRODUCTS
WHERE low_fats = 'Y'
AND recyclable = 'Y';

---EX10
SELECT NAME
FROM CUSTOMER
WHERE referee_id <> 2
OR referee_id IS NULL;

---EX11
SELECT NAME, POPULATION, AREA
FROM WORLD
WHERE AREA >= 3000000
OR POPULATION >= 25000000;

---EX12
SELECT DISTINCT AUTHOR_ID as ID
FROM VIEWS 
WHERE author_id = viewer_id
ORDER BY author_id ASC

---EX13
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL
ORDER BY part, assembly_step;

---EX14
select * from lyft_drivers
where yearly_salary <= 30000 
or yearly_salary >= 70000;

---EX15
select advertising_channel from uber_advertising
Where money_spent > 100000 
And year = 2019;
