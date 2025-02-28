-- ====================================================================================
-- BASIC SELECT --

-- #H1 Select all data
SELECT *
FROM public.customer c ;

-- #H2 Select customer_id, first_name, last_name columns from tracks
SELECT customer_id, first_name, last_name, email 
FROM public.customer c ;

-- #H3 Select customer_id, first_name, last_name columns from tracks
SELECT customer_id, first_name, last_name, create_date 
FROM public.customer c ;

-- #H4 Find unique compose
SELECT DISTINCT first_name
FROM public.customer c;

-- EXERCISE ---
-- #INSTRUCTION
-- 1. Write a query to retrieve all columns from the `film` table.
--    Make sure to use the `SELECT *` syntax.
-- QUERY HERE!
SELECT * FROM public.film;

-- #INSTRUCTION
-- 2. Write a query to retrieve the film title, description, and release year for all films.
--    from the `film` table.
-- QUERY HERE!
SELECT title, description, release_year
FROM public.film;

-- #INSTRUCTION
-- 3. Write a query to retrieve distinct values of the `last_name` column from the `customer` table.
-- QUERY HERE!
SELECT DISTINCT last_name 
FROM public.customer;

-- ====================================================================================
-- WHERE CLAUSE -- 

-- #H4 Find the customer_id and address_id columns for the customer whose email is 'susan.wilson@sakilacustomer.org' in the customer table.
SELECT *
FROM public.film c
WHERE LOWER(description) NOT LIKE '%mexico'
-- WHERE email = 'susan.wilson@sakilacustomer.org' ;

-- #H5 Retrieve the customer_id, first_name, last_name, and email columns from the customer table for customers 
-- whose customer_id is less than or equal to 5.
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE customer_id <= 5 ;

-- #H6 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers whose email addresses contain the word 'kelly'."
SELECT customer_id, first_name, last_name, active, email 
FROM public.customer c
WHERE email LIKE '%kelly%' ;

SELECT *
FROM public.customer c
WHERE email NOT IN ('denise.kelly@sakilacustomer.org','kelly.torres@sakilacustomer.org')

-- #H7 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers whose customer_id is between 20 and 40 (inclusive)."
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE customer_id BETWEEN 20 AND 40;

-- #H8 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers who are associated with store 1.
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE store_id in (1) ;

-- #H9 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers who do not have an email address (i.e., where the email is NULL).
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE email IS NULL ;

-- #H9 Retrieve the customer_id, first_name, last_name, active status, and email columns from the customer table 
-- for customers whose email is not NULL and whose customer_id is between 10 and 30 (inclusive)
SELECT customer_id, first_name, last_name, active, email
FROM public.customer c
WHERE email IS NOT NULL 
AND customer_id BETWEEN 10 AND 30
;

-- EXERCISE ---
-- #INSTRUCTION
-- 1. Write a query to retrieve the `customer_id` and `address_id` columns for the customer 
--    whose email is 'wesley.bull@sakilacustomer.org'.
-- QUERY HERE!
SELECT customer_id, address_id
FROM customer
WHERE email LIKE '%wesley.bull%'
;

select customer_id, address_id from public.customer c
where email = 'wesley.bull@sakilacustomer.org'
;

-- #INSTRUCTION
-- 2. Write a query to find all films with a rental rate greater than 15.00.
-- QUERY HERE!

select * 
from public.film f
where rental_rate > 15.00
;
-- #INSTRUCTION
-- 3. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers whose email addresses contain the word 'terry'.
-- QUERY HERE!

SELECT customer_id, first_name, last_name, active, email
FROM public.customer
WHERE email LIKE '%terry%';

select customer_id, first_name, last_name, active, email
from public.customer c
where email like '%terry%';

-- #INSTRUCTION
-- 4. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers whose `customer_id` is between 100 and 200 (inclusive).
-- QUERY HERE!

select customer_id, first_name, last_name, active, email
from public.customer c
where customer_id between 100 and 200;

-- #INSTRUCTION
-- 5. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers who are associated with store_id 2 .
-- QUERY HERE!

select customer_id, first_name, last_name, active, email
from public.customer c
where store_id = 2;

-- #INSTRUCTION
-- 6. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers who do not have an email address (i.e., where the store_id is NULL).
-- QUERY HERE!

select customer_id, first_name, last_name, active, email
from public.customer c
where email is NULL

-- #INSTRUCTION
-- 7. Write a query to retrieve the `customer_id`, `first_name`, `last_name`, `active`, and `email` columns 
--    for customers whose stpre is not NULL and whose `customer_id` is between 50 and 70 (inclusive).
-- QUERY HERE!

select customer_id, first_name, last_name, active, email
from public.customer c
where email is not null and customer_id between '50' and '70'


-- ====================================================================================
-- AGGREGATE FUNCTIONS -- 
-- metrics .. 

-- #H10 Find the total number of customers in each store from the customer table.
SELECT store_id, COUNT(customer_id) AS total_customers
FROM public.customer
GROUP BY store_id;

-- #H11 Find the average (AVG) number of customers per store (store_id) from the customer table, but only for stores that have more than 300 customers."
SELECT store_id, AVG(customer_id) AS avg_customers
FROM public.customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;
;

-- EXERCISE ---
--#INSTRUCTION
-- 1. Find the total number of films (COUNT) in the film table where the film was released on 2021.
--QUERY HERE!
select count(film_id) as "TOTAL FILM" 
from film
where release_year = '2021';

--#INSTRUCTION
-- 2. Find the daily average (AVG) amount of payment by customer. (AoV) Average of Value, 
--QUERY HERE!
SELECT customer_id,
AVG(amount),
staff_id
FROM public.payment
GROUP BY 1,staff_id;

-- ====================================================================================
-- CONDITIONAL STATEMENT -- 

-- Categorize customers into 5 clusters based on their customer_id. The clusters should be defined as follows:
-- Cluster 1: customer_id between 1 and 100
-- Cluster 2: customer_id between 101 and 200
-- Cluster 3: customer_id between 201 and 300
-- Cluster 4: customer_id between 301 and 400
-- Cluster 5: customer_id greater than 500"
SELECT customer_id, first_name, last_name, active, email,
       CASE 
           WHEN customer_id BETWEEN 101 AND 200 THEN 
		   		CASE 
		   			WHEN email LIKE '%terry%' THEN first_name
				END 
           WHEN customer_id BETWEEN 101 AND 200 THEN 'Cluster 2'
           WHEN customer_id BETWEEN 201 AND 300 THEN 'Cluster 3'
           WHEN customer_id BETWEEN 301 AND 400 THEN 'Cluster 4'
           WHEN customer_id > 500 THEN 'Cluster 5'
           ELSE 'Other' -- For customer_id <= 500 but not in the specified range
       END AS customer_cluster
FROM public.customer;

-- EXERCISE ---
--#INSTRUCTION
-- Categorize film ratings into 4 categories:
-- "Teenager" : films with ratings PG
-- "Young Adult" : films with ratings G
-- "Adult": films with ratings NC
-- "All Ages": film with rating R
--QUERY HERE!
SELECT DISTINCT rating, 
CASE 
	WHEN rating::TEXT LIKE 'G%' THEN 'Young Adult'
	WHEN rating::TEXT LIKE 'PG%' THEN 'Teenager'
	WHEN rating::TEXT LIKE 'NC%' THEN 'Adult'
	WHEN rating::TEXT LIKE 'R%' THEN 'All Ages'
END AS rating_category
FROM public.film;

-- ====================================================================================
-- SQL JOIN -- 

-- Retrieve all customers along with their associated address information. If a customer does not have an associated address, the address fields should be NULL
SELECT c.customer_id, c.first_name, c.last_name, a.address, a.district, a.city_id, a.postal_code
FROM public.customer c
-- FULL JOIN public.address a ON c.address_id = a.address_id;

SELECT c.customer_id, c.email, c.store_id, s.store_id , s.address_id
FROM public.store s
LEFT JOIN public.customer c ON c.store_id = s.store_id
ORDER BY customer_id DESC
;

-- Retrieve the details of customers along with the store they are associated with. Only include customers who are linked to store_id = 1.
SELECT c.customer_id, c.first_name, c.last_name, s.store_id, s.manager_staff_id, s.address_id
FROM public.customer c
INNER JOIN public.store s ON c.store_id = s.store_id AND s.store_id = 1;

-- Create a Cartesian product of all customers and all stores. This will show all possible combinations of customers and stores
SELECT c.customer_id, c.first_name
, s.store_id, s.manager_staff_id, s.address_id
FROM public.customer c
CROSS JOIN public.store s;

SELECT DISTINCT date_trunc('day', dd):: date, store_id
FROM generate_series
        ( '2025-01-01'::timestamp 
        , '2025-01-31'::timestamp
        , '1 day'::interval) dd
CROSS JOIN public.store s
ORDER BY 1
;

-- EXERCISE ---
--#INSTRUCTION
--1. Write a query to join the film and film_category tables to show the category name for each film.
--QUERY HERE!

--#INSTRUCTION
--2.Join the rental, inventory, and film tables to show the film title, rental duration, and customer name for each rental.
--QUERY HERE!

--#INSTRUCTION
--3.Join the film, film_actor, and actor tables to show the film title and all actors who have appeared in that film.
--QUERY HERE!

-- ====================================================================================
-- UNION STATEMENT -- 

-- Retrieve a list of first_name from the customer table and a list of first_name from the actor table. Combine both lists into a single result set."
SELECT first_name || ' ' || last_name AS name, 'customer 1' AS type
FROM public.customer
WHERE customer_id BETWEEN 1 AND 5
UNION 
SELECT first_name || ' ' || last_name AS name, 'customer 2' AS type 
FROM public.customer
WHERE customer_id BETWEEN 20 AND 25
;

---- EXERCISE ---
--#INSTRUCTION
-- Combine data from the customer, staff, and actor tables into a single result set.
--QUERY HERE!

-- ====================================================================================
-- SUBQUERY  -- 

-- Combine data from the customer and actor tables into a single result set. For each record, create a new column is_customer 
-- that indicates whether the record belongs to a customer (1) or not (0). Additionally, merge the first_name and last_name columns into a single name column 
-- and assign a type label ('customer' or 'actor') based on the source table.

SELECT *, CASE WHEN type ='customer' THEN 1 ELSE 0 END AS is_customer
FROM (
    SELECT customer_id AS id, first_name || ' ' || last_name AS name, 'customer' AS type
    FROM (
		SELECT *
		FROM public.customer 
		WHERE customer_id BETWEEN 202 AND 210
	)
    UNION
    SELECT actor_id AS id, first_name || ' ' || last_name AS name, 'actor' AS type 
    FROM public.actor
) x ;

-- CTE 
WITH t_source AS (
SELECT *
FROM public.customer 
WHERE customer_id BETWEEN 202 AND 210
),

t_data AS( 
SELECT customer_id AS id, first_name || ' ' || last_name AS name, 'customer' AS type
FROM t_source
UNION
SELECT actor_id AS id, first_name || ' ' || last_name AS name, 'actor' AS type 
FROM public.actor
)

SELECT *, CASE WHEN type ='customer' THEN 1 ELSE 0 END AS is_customer 
FROM t_data ;


-- EXERCISE ---
--#INSTRUCTION
-- Combine data from the customer, staff, and actor tables into a single result set. For each record, create a new column is_customer 
-- that indicates whether the record belongs to a actor (1) or not (0). Additionally, merge the first_name and last_name columns into a single name column 
-- and assign a type label ('customer', 'actor', or 'staff) based on the source table.
--QUERY HERE!


-- ====================================================================================
-- OTHER QUERY  -- 
-- COALESCE()
-- IF(customer_id = 1, 'first register', 'others')
-- GREATEST(timestamp 1, timestamp 2) // Bukan Agregasi
-- MAX_BY(rental_id, rental_date)
-- MIN_BY()

SELECT *, CASE WHEN type ='customer' THEN 1 ELSE 0 END AS is_customer
FROM (
    SELECT customer_id AS id, first_name || ' ' || last_name AS name, 'customer' AS type
    FROM public.customer
    UNION
    SELECT actor_id AS id, first_name || ' ' || last_name AS name, 'actor' AS type 
    FROM public.actor
) x 
ORDER BY 1 ASC, 2 DESC
;

SELECT *
FROM public.rental