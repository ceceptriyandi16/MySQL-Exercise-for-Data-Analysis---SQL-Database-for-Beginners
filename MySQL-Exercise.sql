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