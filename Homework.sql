USE sakila; 

-- Question 1A
SELECT first_name, last_name 
FROM actor;

-- Question 1B 
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor;

-- Question 2A
SELECT actor_id, first_name, last_name
FROM actor 
WHERE first_name = "Joe";

-- Question 2B
SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";

-- Question 2C
SELECT *
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

-- Question 2D 
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- Question 3A 
ALTER TABLE actor
ADD COLUMN description BLOB; -- BLOB = Binary Large Object (used to store very large values)

-- Question 3B
ALTER TABLE actor
DROP COLUMN description; 

-- Question 4A 
SELECT last_name, COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name; 

-- Question 4B 
SELECT last_name, COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name
HAVING last_name_count >= 2; 

-- Question 4C
UPDATE actor
SET first_name = "Harpo"
WHERE last_name = "Williams" AND first_name = "Groucho"; 

-- Question 4D
UPDATE actor
SET first_name = "Groucho"
WHERE first_name = "Harpo"; 

-- Question 5
SHOW CREATE TABLE address;

-- Question 6A
SELECT first_name, last_name, address
FROM staff INNER JOIN address on staff.address_id = address.address_id;

-- Question 6B 
SELECT staff.staff_id, first_name, last_name, SUM(amount) 
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment_date >= '2005-08-01' AND payment_date <= '2005-08-31'
GROUP BY staff.staff_id; 

-- Question 6C
SELECT title AS "Film" , COUNT(actor_id) AS "Number of Actors" 
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY title; 

-- Question 6D
SELECT title AS "Film", COUNT(inventory_id) AS "Number of Copies" 
FROM inventory INNER JOIN film ON inventory.film_id = film.film_id 
WHERE title = "Hunchback Impossible"; 

-- Question 6E 
SELECT first_name, last_name, SUM(amount)
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name; 

-- Question 7A
SELECT title 
FROM film 
WHERE (title LIKE "K%" OR title LIKE "Q%") AND language_id in
(
	SELECT language_id
    FROM language
    WHERE name = "English"
);

-- Question 7B
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor
WHERE actor_id IN
(
	SELECT actor_id 
    FROM film_actor 
    WHERE film_id IN
    (
		SELECT film_id 
        FROM film
        WHERE title = "Alone Trip"
	)
);

-- Question 7C
SELECT CONCAT(first_name, ' ', last_name) AS 'Customer Name', 
email AS 'Email Address'
FROM customer INNER JOIN address ON 
customer.address_id = address.address_id INNER JOIN city ON
address.city_id = city.city_id INNER JOIN country ON
city.country_id = country.country_id 
WHERE country.country = 'Canada';

-- Question 7D
SELECT film.title
FROM film INNER JOIN film_category ON film.film_id = film_category.film_id 
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- Question 7E 
SELECT film.title 'Title', COUNT(film.title) '# Rentals'
FROM film INNER JOIN inventory ON film.film_id = inventory.film_id 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(film.title) DESC;

-- Question 7F
SELECT store.store_id 'Store', SUM(payment.amount) 'Revenue ($)'
FROM  payment INNER JOIN staff ON payment.staff_id = staff.staff_id 
INNER JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id; 

-- Question 7G
SELECT store.store_id 'Store', city.city 'City', country.country 'Country'
FROM store INNER JOIN address ON store.address_id = address.address_id 
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id; 

-- Question 7H
SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Revenue'
FROM category INNER JOIN film_category ON 
category.category_id = film_category.category_id INNER JOIN  inventory ON 
film_category.film_id = inventory.film_id INNER JOIN rental ON 
inventory.inventory_id = rental.inventory_id INNER JOIN payment ON 
rental.rental_id = payment.rental_id 
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- Question 8A
CREATE VIEW top_five_genres as 
(
		SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Revenue'
		FROM category INNER JOIN film_category ON 
		category.category_id = film_category.category_id INNER JOIN  inventory ON 
		film_category.film_id = inventory.film_id INNER JOIN rental ON 
		inventory.inventory_id = rental.inventory_id INNER JOIN payment ON 
		rental.rental_id = payment.rental_id 
		GROUP BY category.name
		ORDER BY SUM(payment.amount) DESC
		LIMIT 5
); 

-- Question 8B
SELECT *
FROM top_five_genres;

-- Question 8C
DROP VIEW sakila.top_five_genres;