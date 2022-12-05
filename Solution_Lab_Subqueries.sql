USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(i.store_id), f.title
FROM film f
JOIN inventory i 
USING (film_id)
WHERE f.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT title FROM film
WHERE length > (
  SELECT avg(length)
  FROM film
);

 -- 3. Use subqueries to display all actors who appear in the film Alone Trip.
 
 SELECT actor.first_name, actor.last_name FROM actor
 WHERE actor_id IN (
	SELECT actor_id FROM film_actor
    WHERE film_id in (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'));
 
 -- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
 -- Identify all movies categorized as family films.
 
 SELECT f.title FROM film f WHERE film_id IN (
 SELECT film_id FROM film_category WHERE 
 category_id in (SELECT category_id 
 FROM category cat
 WHERE cat.name IN ('Family')));
 
 -- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
 -- Note that to create a join, you will have to identify the correct tables with their primary 
 -- keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email FROM customer WHERE address_id IN (
SELECT address_id FROM address WHERE city_id IN (
SELECT city_id from city WHERE country_id 
IN (SELECT country_id FROM country WHERE country IN ('Canada'))));


SELECT first_name, last_name, email FROM customer
JOIN address
USING (address_id)
JOIN city 
USING (city_id)
JOIN country c
USING (country_id)
WHERE c.country IN ('Canada');


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the 
-- actor that has acted in the most number of films. First you will have to find the most prolific 
-- actor and then use that actor_id to find the different films that he/she starred.

-- I CAN'T USE "LIMIT" INSIDE A NESTED QUERY IN MY VERSION OF MYSQL, SO HAVE TO DO THE FIRST ONE SEPARATE

SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(actor_id) DESC
LIMIT 1;

SELECT title from FILM where film_id IN (
SELECT film_id FROM film_actor WHERE actor_id IN ('107'));


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to 
-- find the most profitable customer ie the customer that has made the largest sum of payments

-- SAME ISSUE WITH LIMIT IN NESTED FUNCTION ON WINDOWS, SO SEPARATE (customer_id most profitable=526)
SELECT customer_id FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC LIMIT 1;

SELECT title FROM film WHERE film_id IN (
SELECT film_id FROM inventory WHERE inventory_id IN (
SELECT inventory_id FROM rental where customer_id IN ('526')));

-- 8. Customers who spent more than the average payments.

CREATE TEMPORARY TABLE avg_payment_customers AS (SELECT customer_id, AVG(amount) AS AVG_Amount FROM payment GROUP BY customer_id);
SELECT * FROM avg_payment_customers;

SELECT first_name, last_name FROM customer WHERE customer_id IN (
SELECT customer_id FROM avg_payment_customers WHERE AVG_Amount > (SELECT AVG(amount) FROM payment));