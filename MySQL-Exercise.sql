USE mavenmovies;

/* 24. (QUERYING TABLES) I'm going to send an email letting our customers know there has been a management change.
Could you pull a list of the first name, last name, and email of each of our customers? */
SELECT 
	first_name, last_name, email
FROM customer;

/* 27. (SELECT DISTINCT) My understanding is that we have titles that we rent for durations of 3, 5, or 7 days.
Could you pull the records of our films and see if there are any other rental durations? */
SELECT DISTINCT
	rental_duration
FROM film;

/* 31. (WHERE CLAUSES) I'd like to look at payment records for our long-term customers to learn about their purchase patterns.
Could you pull all payments from our first 100 customers (based on customer ID)? */
SELECT
	customer_id, rental_id, amount, payment_date
FROM payment
WHERE customer_id <= 100;

/* (WHERE & AND) 34. The payment data you gave me on our first 100 customers was great - thank you!
Now I'd love to see just payments over $5 for those same customers, since January 1, 2006. */
SELECT
	customer_id, rental_id, amount, payment_date
FROM payment
WHERE customer_id <= 100
	AND amount > 5
    AND payment_date > '2006-01-01';
    
/* 37. (WHERE & OR) The data you shared previously on customers 42, 53, 60, and 75 was good to see.
Now, could you please write a query to pull all payments from those specific customers, along with payments
over $5, from any customer? */
SELECT
	customer_id, rental_id, amount, payment_date
FROM payment
WHERE amount > 5
	OR customer_id = 42
    OR customer_id = 53 
    OR customer_id = 60
    OR customer_id = 75;

-- another way
SELECT
	customer_id, rental_id, amount, payment_date
FROM payment
WHERE amount > 5
	OR customer_id IN (42,53,60,75);
    
/* 42. (LIKE W/ WILDCARDS) We need to understand the special features in out films. Could you pull a list of films which include a
Behind the Scenes special feature? */
SELECT
	title, special_features
FROM film 
WHERE special_features LIKE '%Behind the Scenes%';

/* 47. (GROUP BY) I need to get a quick overview of how long our movies tend to be rented out for.
Could you please pull a count of titles sliced by rental duration? */
SELECT
	rental_duration,
    COUNT(film_id) AS films_with_this_rental_duration
FROM film
GROUP BY rental_duration;

/* 51. (AGGREGATE FUNCTIONS) I'm wondering if we charge more for a rental when the replacement cost is higher.
Can you help me pull a count of films, aling with the average, min, and max rerntal rate, grouped by replacement
cost? */
SELECT
	replacement_cost,
	COUNT(film_id) AS number_of_films,
    MIN(rental_rate) AS cheapest_rental,
    MAX(rental_rate) AS most_expensive_rental,
    AVG(rental_rate) AS average_rental
FROM film
GROUP BY replacement_cost;

/* 55. I'd like to talk to customers that have not rented much from us to understand if there is something we
could be doing better. Could you pull a list of customer_ids with less than 15 rentals all-time? */
SELECT
	customer_id,
    COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY customer_id
	HAVING total_rentals < 15;

/* 59. (ORDER BY) I'd like to see if our longest films also tend to be our most expensive rentals.
Could you pull me a list of all films titles along with their lengths and rental rates, and sort them from longest
to shortes? */
SELECT
	title,
    length,
    rental_rate
FROM film
ORDER BY length DESC;

--
--
--

SELECT DISTINCT
	title,
    CASE
		WHEN rental_duration <= 4 THEN 'rental_too_short'
        WHEN rental_rate >= 3.99 THEN 'too_expensive'
        WHEN rating IN ('NC-17','R') THEN 'too_adult'
        WHEN length NOT BETWEEN 60 AND 90 THEN 'too_short_or_too_long'
        WHEN description LIKE '%Shark%' THEN 'nope_has_sharks'
        ELSE 'great_reco_for_my_niece'
	END AS fit_for_recommendation,
    CASE
		WHEN description LIKE '%Shark%' THEN 'nope_has_sharks'
        WHEN length NOT BETWEEN 60 AND 90 THEN 'too_short_or_too_long'
        WHEN rating IN ('NC-17','R') THEN 'too_adult'
		WHEN rental_duration <= 4 THEN 'rental_too_short'
        WHEN rental_rate >= 3.99 THEN 'too_expensive'
        ELSE 'great_reco_for_my_niece'
	END AS reordered_reco
FROM film;

/* 65. (CASE) I'd like to know which store each customer goes to, and whether or not they are active.
Could you pull a list of first and last names of all customers, and label them as either 'store 1 active', 'store 1 inactive',
'store 2 active', or 'store 2 inactive'? */
-- SELECT * FROM customer;
SELECT
	first_name, last_name,
    CASE
		WHEN store_id = 1 AND active = 1 THEN 'store 1 active'
        WHEN store_id = 1 AND active = 0 THEN 'store 1 inactive'
        WHEN store_id = 2 AND active = 1 THEN 'store 2 active'
        WHEN store_id = 2 AND active = 0 THEN 'store 2 inactive'
        ELSE "There's wrong, please check your logic!"
    END AS store_and_status
FROM customer;

--
--
--

SELECT * FROM inventory;
SELECT
	film_id,
    COUNT(
		CASE
			WHEN store_id = 1 THEN inventory_id
            ELSE NULL
		END
    ) AS store_1_copies,
    COUNT(
		CASE
			WHEN store_id = 2 THEN inventory_id
            ELSE NULL
        END
    ) AS store_2_copies,
    COUNT(inventory_id) AS total_copies
FROM inventory
GROUP BY film_id;

/* 69. (COUNT & CASE / PIVOTING) I'm curious how many inactive customers we have at each store.
Could you please create a table to count the number of customers broken down by store_id (in rows), and active status
(in columns)? */
-- SELECT * FROM customer;
SELECT
	store_id,
    COUNT(
		CASE
			WHEN active = 1 THEN customer_id
            ELSE NULL
        END
    ) AS active_status,
    COUNT(
		CASE
			WHEN active = 0 THEN customer_id
            ELSE NULL
        END
    ) AS inactive_status
FROM customer
GROUP BY store_id;

/* 81. (INNER JOIN) Can you pull for me a list of each film we have in inventory?
I would like to see the film's title, description, and the store_id value associated with each item, and its inventory_id. */
SELECT * FROM film;
SELECT * FROM inventory;
SELECT
	inventory.inventory_id, inventory.store_id,
	film.title, film.description
FROM film
	INNER JOIN inventory
		ON inventory.film_id = film.film_id;

/* 85. (LEFT JOIN) One of our investors is interested in the films we carry and how many actors are listed for each film title.
Can you pull a list of all titles, and figure out how many actors are associated with each title? */
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT
	film.title,
    COUNT(actor_id) AS number_of_actors
FROM film
	LEFT JOIN film_actor
		ON film.film_id = film_actor.film_id
GROUP BY film.title;

/* 91. (BRIDGING) Customers often ask which films their favorite actors appear in. It would be great to have a list of
all actors, with each title that they appear in. Could you please pull that for me? */
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT
	actor.first_name, actor.last_name,
    film.title
FROM actor
	INNER JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
	INNER JOIN film
		ON film_actor.film_id = film.film_id
ORDER BY actor.last_name, actor.first_name;

/* 94. (Multi-Condition JOIN) The manager from store 2 is working on expanding our film collection there.
Could you pull a list of distinct titles and their descriptions, currently available in inventory at store 2? */
SELECT * FROM film;
SELECT * FROM inventory;
SELECT DISTINCT
	film.title, film.description
FROM film
	INNER JOIN inventory
		ON film.film_id = inventory.film_id
WHERE inventory.store_id = 2; -- 'WHERE' can change with 'AND'

--
--
--

SELECT 
	'advisor' AS type,
    first_name,
    last_name
FROM advisor
UNION
SELECT
	'investor' AS type,
    first_name,
    last_name
FROM investor;

/* 98. (UNION) We will be hosting a meeting with all of our staff and advisor soon.
Could you pull one list of all staff and advisor names, and include a column nothing whether they are a staff member or
advisor? */
SELECT
	'advisor' AS type,
    first_name,
    last_name
FROM advisor
UNION
SELECT
	'staff' AS type,
    first_name,
    last_name
FROM staff;
