SELECT 
    *
FROM
    countries.countries
WHERE
    (POPULATION between 100000000 and 200000000
		or AREA_KM2 >5000000)
	and
   (name not like '% %');

use hr


SELECT 
    *
FROM
    customer_orders.order_items
WHERE
    QUANTITY >= 4 AND UNIT_PRICE >= 49;
select * from information_schema.table_constraints where table_schema = 'hr' and table_name = 'dept';
create table hr.sales_people as select EMP_NO, E_NAME, JOB, MGR, HIRE_DATE, (SAL+COMM) AS TOTAL_PAY, DEPT_NO FROM HR.EMP WHERE 1=0;
INSERT INTO HR.SALES_PEOPLE (EMPNO, ENAME, JOB, MGR, HIREDATE, TOTAL_PAY, DEPTNO)
SELECT EMP_NO, E_NAME, JOB, MGR, HIRE_DATE, (SAL + COMM) AS TOTAL_PAY, DEPT_NO
FROM HR.EMP
WHERE JOB = 'senior salesman';
UPDATE HR.SALES_PEOPLE
SET JOB = 'SENIOR SALESMAN'
WHERE TOTAL_PAY > 2000;
Error Code: 1109. Unknown table 'TABLES_CONSTRAINTS' in information_schema


SELECT 
    *, round(unit_price * quantity, 1) AS line_item_amout
FROM
    customer_orders.order_items;
    
select * from customer_orders.customers;
SELECT
	full_name,
     substring_index(full_name, ' ' ,1) as first_name,
     substring_index(full_name, ' ' ,-1) as last_name,
     concat(
     substring_index(full_name, ' ' ,1), ' ',
     substring_index(full_name, ' ' ,-1)
     )as formatted_name
FROM
    customer_orders.customers;

SELECT 
    name,
    population,
    area_km2,
    population/AREA_KM2 as density,
    case 
		when population/area_km2 > 500 then 'hight'
        when population/area_km2 > 100 then 'medium'
        else 'low'
	end as density_cat
FROM
    countries.countries
WHERE population/NULLIF(area_km2,0) > 500;
SELECT 
    name,
    population,
    area_km2,
    population / area_km2 AS density,
    CASE 
        WHEN population / area_km2 < 500 THEN 'Low'
        WHEN population / area_km2 BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'High'
    END AS density_category
FROM countries.countries;
SELECT 
    REGION_ID, 
    ROUND(AVG(population), 2) AS average_pplation
FROM
    countries.countries
GROUP BY region_id;
SELECT * FROM countries.countries;
SELECT 
    CUSTOMER_ID, count(*) AS total_order
FROM
    customer_orders.orders
GROUP BY customer_id
order by total_order desc;
SELECT 
    LEFT(full_name,
        LOCATE(' ', full_name) - 1) AS first_name,
    COUNT(*) AS most_common_name
FROM
    customer_orders.customers
GROUP BY first_name
ORDER BY most_common_name DESC;
SELECT * FROM customer_orders.order_items;
SELECT 
    order_id,
    SUM(unit_price * quantity) AS order_amount
FROM customer_orders.order_items
GROUP BY order_id
ORDER BY order_amount DESC limit 10;
SELECT 
	region_id,
    sum(population) as total_populasi,
    sum(area_km2) as total_area,
    sum(population/AREA_KM2) as density
FROM countries.countries
group by REGION_ID
order by density desc;

create schema assigment_schema;
CREATE TABLE assigment_schema.movie_ratings (
    movie VARCHAR(255),
    genre VARCHAR(255),
    rating NUMERIC
);

ALTER TABLE assigment_schema.movie_ratings
MODIFY COLUMN rating DECIMAL(3,1);
insert into assigment_schema.movie_ratings
	value
	('the shawshank redemption', 'drama', 9,3),
    ('the godfather', 'crime', 9,2);
INSERT INTO assigment_schema.movie_ratings (movie, genre, rating)
VALUES
  ('the godfatr',            'drama', 0);
  
alter table assigment_schema.movie_ratings modify column movie varchar(255) unique;
select * from assigment_schema.movie_ratings;
SHOW CREATE TABLE assigment_schema.movie_ratings;
DESCRIBE assigment_schema.movie_ratings;

alter table assigment_schema.movie_ratings
	add check (rating >0);
drop table movie_ratings;

CREATE TABLE assigment_schema.hr_emp AS
SELECT * FROM HR.EMP;
CREATE TABLE assigment_schema.hr_dept AS
SELECT * FROM HR.DEPT;
select * from assigment_schema.HR_dept;
alter table assigment_schema.hr_dept
add primary key (DEPT_ID);
ALTER TABLE assigment_schema.HR_EMP
ADD CONSTRAINT fk_DEPT
FOREIGN KEY (DEPT_NO)
REFERENCES assigment_schema.HR_DEPT(DEPT_ID);

INSERT INTO assigment_schema.hr_emp
VALUES
  (1234, 'test', 'test', 1234, '1980-01-01', 1000, 0, 100);
SELECT * FROM hr.emp;
SELECT * FROM hr.dept;

SELECT 
    *
FROM
    hr.emp
        JOIN
    hr.dept ON hr.emp.dept_no = hr.dept.dept_id;
select
	t1.name as country,
	t1.population,
	t1.area_km2,
	t2.name as region,
	t3.name as sub_region
from countries.countries as t1
left join countries.regions as t2
on t1.region_id = t2.id
left join countries.sub_regions as t3
on t1.sub_region_id = t3.id;
select
	t1.name as country,
    t1.population,
    t1.area_km2,
    t2.name as region,
    t3.name as sub_region
from countries.countries as t1
left join countries.regions as t2
on t1.region_id = t2.id
left join countries.sub_regions as t3
on t1.sub_region_id = t3.id
where t1.population > 100000000;

select * from hr.emp
union
select * from hr.emp;
select * from hr.emp
cross join hr.dept;

-- creating dept_2 table
create table hr.dept_2 as 
select * from hr.dept where dept_id <> 10;

-- selecing records from dept_2 and emp
select * from hr.dept_2;
select * from hr.emp;

-- full outer join using left join, right join and union
select * from hr.emp as t1
left join hr.dept_2 as t2
on t1.dept_no = t2.dept_id
union
select * from hr.emp as t1
right join hr.dept_2 as t2
on t1.dept_no = t2.dept_id;

-- dropping dept_2 table
drop table hr.dept_2;

SELECT 
    *
FROM
    COUNTRIES.COUNTRIES
WHERE POPULATION = (SELECT 
						MAX(POPULATION)
					FROM
						COUNTRIES.COUNTRIES);

-- create view
CREATE VIEW countries.population AS
SELECT 
	t1.name as country,
	t4.region_name,
	t5.sub_region_name,
	t1.population as country_population,
	t2.region_population,
	t3.sub_region_population
FROM COUNTRIES.COUNTRIES as t1
JOIN (SELECT REGION_ID, SUM(POPULATION) as region_population FROM COUNTRIES.COUNTRIES GROUP BY REGION_ID) as t2
ON t1.sub_region_id = t2.region_id
JOIN (SELECT SUB_REGION_ID, SUM(POPULATION) as sub_region_population FROM COUNTRIES.COUNTRIES GROUP BY SUB_REGION_ID) as t3
ON t1.sub_region_id = t3.sub_region_id
JOIN (SELECT id, name AS region_name  FROM COUNTRIES.REGIONS) as t4
ON t1.region_id = t4.id
JOIN (SELECT id, name AS sub_region_name  FROM COUNTRIES.SUB_REGIONS) as t5
ON t1.sub_region_id = t5.id;

-- query the view
select * from countries.population;


-- information schema
select * from information_schema.views where table_schema = 'COUNTRIES';


-- update view
CREATE OR REPLACE VIEW countries.population AS
SELECT 
	t1.name as country,
	t4.region_name as region,
	t5.sub_region_name as sub_region,
	t1.population as country_population,
	t2.region_population,
	t3.sub_region_population
FROM COUNTRIES.COUNTRIES as t1
JOIN (SELECT REGION_ID, SUM(POPULATION) as region_population FROM COUNTRIES.COUNTRIES GROUP BY REGION_ID) as t2
ON t1.sub_region_id = t2.region_id
JOIN (SELECT SUB_REGION_ID, SUM(POPULATION) as sub_region_population FROM COUNTRIES.COUNTRIES GROUP BY SUB_REGION_ID) as t3
ON t1.sub_region_id = t3.sub_region_id
JOIN (SELECT id, name AS region_name  FROM COUNTRIES.REGIONS) as t4
ON t1.region_id = t4.id
JOIN (SELECT id, name AS sub_region_name  FROM COUNTRIES.SUB_REGIONS) as t5
ON t1.sub_region_id = t5.id;

-- drop view
DROP VIEW countries.population;

SELECT 
    region_id,
    avg(population) as ratarata
FROM
    countries.countries
group by population;

SELECT 
    AVG(population) AS avg_population
FROM countries.countries;
create view countries.jawa as
SELECT 
    t1.name as country,
	t1.population as country_population,
    t2.avg_population
FROM countries.countries as t1
join(SELECT 
    AVG(population) AS avg_population
FROM countries.countries) as t2
WHERE population > (
    SELECT AVG(population) 
    FROM countries.countries
);
SELECT 
    name AS country,
    population
FROM countries.countries
WHERE population > (
    SELECT AVG(population) 
    FROM countries.countries
);
drop view countries.jawa;
SELECT 
    t2.name as region_name,
    sum(t1.population) as populasi
FROM
    countries.countries as t1
    left join countries.regions as t2
    on t1.region_id = t2.id
    group by t2.name
    order by populasi desc;
SELECT * FROM countries.countries;
select * from customer_orders.customers;
select * from customer_orders.orders;
SELECT 
    t2.full_name,
    t1.total_orders
FROM
(SELECT 
		CUSTOMER_ID,
		COUNT(*) AS total_orders
FROM customer_orders.orders 
where order_status = 'complete'
group by CUSTOMER_ID) as t1
left join customer_orders.customers as t2
on t1.customer_id = t2.customer_id
order by total_orders desc
limit 10;
select * from customer_orders.customers;
select * from customer_orders.orders;
select * from customer_orders.products;
-- step 1: data exploration
select * from customer_orders.order_items;
select * from customer_orders.orders;
select * from customer_orders.products;




-- step 2: join order_items, orders and products tables 
SELECT 
    t1.order_id,
    t1.quantity,
    t2.order_status,
    t2.order_datetime,
    t3.product_name
FROM customer_orders.order_items as t1
LEFT JOIN customer_orders.orders as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.products as t3
ON t1.product_id = t3.product_id;





-- step 3: extract the year from order_datetime
SELECT 
    t1.order_id,
    t1.quantity,
    t2.order_status,
    date_format(str_to_date(t2.order_datetime,'%m/%d/%Y %H:%i'), '%Y') as order_year,
    t3.product_name
FROM customer_orders.order_items as t1
LEFT JOIN customer_orders.orders as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.products as t3
ON t1.product_id = t3.product_id;





-- step 4: filtering to return records for COMPLETE orders only
SELECT 
    t1.order_id,
    t1.quantity,
    t2.order_status,
    date_format(str_to_date(t2.order_datetime,'%m/%d/%Y %H:%i'), '%Y') as order_year,
    t3.product_name
FROM customer_orders.order_items as t1
LEFT JOIN customer_orders.orders as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.products as t3
ON t1.product_id = t3.product_id
WHERE t2.order_status = 'COMPLETE';





-- step 5: group and aggregate subquery
SELECT
sq1.product_name,
sq1.order_year,
sum(sq1.quantity) as units_sold
FROM
(SELECT 
    t1.order_id,
    t1.quantity,
    t2.order_status,
    date_format(str_to_date(t2.order_datetime,'%m/%d/%Y %H:%i'), '%Y') as order_year,
    t3.product_name
FROM customer_orders.order_items as t1
LEFT JOIN customer_orders.orders as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.products as t3
ON t1.product_id = t3.product_id
WHERE t2.order_status = 'COMPLETE') as sq1
GROUP BY
sq1.product_name, sq1.order_year;





-- step 6: create the view
CREATE VIEW customer_orders.vw_product_sales AS
SELECT
sq1.product_name,
sq1.order_year,
sum(sq1.quantity) as units_sold
FROM
(SELECT 
    t1.order_id,
    t1.quantity,
    t2.order_status,
    date_format(str_to_date(t2.order_datetime,'%m/%d/%Y %H:%i'), '%Y') as order_year,
    t3.product_name
FROM customer_orders.order_items as t1
LEFT JOIN customer_orders.orders as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.products as t3
ON t1.product_id = t3.product_id
WHERE t2.order_status = 'COMPLETE') as sq1
GROUP BY
sq1.product_name, sq1.order_year;





select * from customer_orders.vw_product_sales;
-- step 1: data exploration
select * from customer_orders.order_items;
select * from customer_orders.orders;
select * from customer_orders.stores;




-- step 2: join order_items, orders and stores tables 
SELECT 
  t3.store_name,
  date_format(str_to_date(t1.order_datetime,'%m/%d/%Y %H:%i'), '%Y-%m') as month_year,
	t1.order_status,
	t2.quantity * t2.unit_price as line_item_amount
FROM customer_orders.orders as t1
LEFT JOIN customer_orders.order_items as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.stores as t3
ON t1.store_id = t3.store_id;





-- step 3: group and aggregate subquery
SELECT
	sq1.store_name,
    sq1.month_year,
    sq1.order_status,
    sum(sq1.line_item_amount) as sales_amount
FROM
(SELECT 
    t3.store_name,
    date_format(str_to_date(t1.order_datetime,'%m/%d/%Y %H:%i'), '%Y-%m') as month_year,
	t1.order_status,
	t2.quantity * t2.unit_price as line_item_amount
FROM customer_orders.orders as t1
LEFT JOIN customer_orders.order_items as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.stores as t3
ON t1.store_id = t3.store_id) sq1
GROUP BY sq1.store_name, sq1.month_year, sq1.order_status;





-- step 4: create the view
CREATE VIEW customer_orders.vw_store_sales AS
SELECT
	sq1.store_name,
    sq1.month_year,
    sq1.order_status,
    sum(sq1.line_item_amount) as sales_amount
FROM
(SELECT 
    t3.store_name,
    date_format(str_to_date(t1.order_datetime,'%m/%d/%Y %H:%i'), '%Y-%m') as month_year,
	t1.order_status,
	t2.quantity * t2.unit_price as line_item_amount
FROM customer_orders.orders as t1
LEFT JOIN customer_orders.order_items as t2
ON t1.order_id = t2.order_id
LEFT JOIN customer_orders.stores as t3
ON t1.store_id = t3.store_id) sq1
GROUP BY sq1.store_name, sq1.month_year, sq1.order_status;





select * from customer_orders.vw_store_sales;