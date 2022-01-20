-- 1)  Write a query to display for each store its store ID, city, and country.
SELECT S.store_id, Ci.city, Co.country
FROM sakila.store S 
INNER JOIN sakila.address A USING(address_id)
INNER JOIN sakila.city Ci USING(city_id)
INNER JOIN sakila.country Co USING(country_id) 
GROUP BY S.store_id;

-- 2) Write a query to display how much business, in dollars, each store brought in.
SELECT S.store_id, SUM(P.amount)
FROM sakila.store S
INNER JOIN sakila.customer C USING(store_id)
INNER JOIN sakila.payment P USING(customer_id)
GROUP BY S.store_id;

-- 3) Which film categories are longest?
SELECT Cat.name, ROUND(AVG(F.length),2) AS avg_length
FROM sakila.category Cat
INNER JOIN sakila.film_category Fc USING(category_id)
INNER JOIN sakila.film F USING(film_id)
GROUP BY Cat.name
ORDER BY AVG(F.length) DESC;

-- 4) Display the most frequently rented movies in descending order.
SELECT F.title, COUNT(R.rental_id) AS times_rented
FROM sakila.film F 
INNER JOIN sakila.inventory I USING(film_id)
INNER JOIN sakila.rental R USING(inventory_id)
GROUP BY F.title
ORDER BY  COUNT(R.rental_id) DESC;

-- 5) List the top five genres in gross revenue in descending order.
-- PAYMENT -> RENTAL -> INVENTORY -> FILM_CATEGORY -> CATEGORY
SELECT C.name, SUM(P.amount) AS total_earnings
FROM sakila.payment P
INNER JOIN sakila.rental USING(rental_id)
INNER JOIN sakila.inventory USING(inventory_id)
INNER JOIN sakila.film_category USING(film_id)
INNER JOIN sakila.category C USING(category_id)
GROUP BY C.name
ORDER BY SUM(P.amount) DESC
LIMIT 5;

-- 6) Is "Academy Dinosaur" available for rent from Store 1?
-- This query says that there are 4 Items in the inventory for store 1, wether they are rented or not
SELECT COUNT(I.inventory_id) AS available_copies
FROM sakila.inventory I 
JOIN sakila.film F USING(film_id)
WHERE I.store_id = 1 AND F.title = 'Academy Dinosaur'
GROUP BY I.store_id;

-- This query shows that every rented copy of the movie has been returned
SELECT COUNT(I.inventory_id)
FROM sakila.inventory I 
JOIN sakila.film F USING(film_id)
right JOIN sakila.rental R USING(inventory_id)
WHERE I.store_id = 1 AND F.title = 'Academy Dinosaur' -- AND R.return_date IS not NULL
GROUP BY I.inventory_id;


-- 7) Get all pairs of actors that worked together.
SELECT CONCAT(A1.first_name, ' ', A1.last_name) AS actor1, CONCAT(A2.first_name, ' ', A2.last_name) AS actor2
FROM sakila.film_actor FA1
JOIN sakila.actor A1 USING(actor_id)
JOIN sakila.film_actor FA2 ON (FA1.actor_id <> FA2.actor_id) AND (FA1.film_id = FA2.film_id)
JOIN sakila.actor A2 ON A2.actor_id = FA2.actor_id
GROUP BY FA1.actor_id;

-- 8) Get all pairs of customers that have rented the same film more than 3 times.
-- This query fetches all without the more than 3 times condition
SELECT CONCAT(C1.first_name, ' ', C1.last_name) AS customer1, CONCAT(C2.first_name, ' ', C2.last_name) AS customer2
FROM sakila.rental R1
JOIN sakila.customer C1 USING(customer_id) 
JOIN sakila.rental R2 ON (R1.inventory_id = R2.inventory_id) AND (R1.customer_id <> R2.customer_id)
JOIN sakila.customer C2 ON C2.customer_id = R2.customer_id
GROUP BY R1.inventory_id
-- HAVING COUNT(R1.inventory_id) >= 3
order by customer1, customer2;


-- 9) For each film, list actor that has acted in the most films.
SELECT FA.film_id, CONCAT(A.first_name, ' ', A.last_name) AS actor
FROM sakila.film_actor FA
JOIN sakila.actor A USING(actor_id)
ORDER BY FA.film_id