--	.:Using the Sakila database to demonstrate/practice SQL queries:.	--

	# USE sakila

--	1a. Display the first and last names of all actors from the table actor.
	
	DESCRIBE sakila.actor;

	SELECT first_name, last_name
	FROM sakila.actor
	ORDER BY last_name, first_name ASC

--	1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

	SELECT UPPER(CONCAT_WS(" ", first_name, last_name)) AS "Actor Name"
	FROM sakila.actor
	ORDER BY last_name, first_name ASC;

#######################################################################################################################
/*
	2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
	What is one query would you use to obtain this information?
*/

	SELECT actor_id, first_name, last_name
	FROM sakila.actor
	WHERE first_name = "Joe";

--	2b. Find all actors whose last name contain the letters GEN:

	SELECT actor_id, first_name, last_name
	FROM sakila.actor
	WHERE last_name LIKE "%GEN%"
	ORDER BY last_name, first_name ASC;

--	2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

	SELECT actor_id, first_name, last_name
	FROM sakila.actor
	WHERE last_name LIKE "%LI%"
	ORDER BY last_name, first_name ASC;


--	2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

	SELECT country_id, country
	FROM sakila.country
	WHERE country IN ("Afghanistan", "Bangladesh", "China");

#######################################################################################################################

--	3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

	ALTER TABLE sakila.actor 
	ADD description BLOB;

--	3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

   	ALTER TABLE sakila.actor 
	DROP COLUMN	description; 

#######################################################################################################################

--	4a. List the last names of actors, as well as how many actors have that last name.
	
	SELECT last_name, COUNT(last_name)
	FROM sakila.actor
	GROUP BY last_name
	ORDER BY COUNT(last_name) DESC;

--	4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

	SELECT last_name, COUNT(last_name)
	FROM sakila.actor
	GROUP BY last_name
    HAVING COUNT(last_name) >= 2
	ORDER BY COUNT(last_name) DESC;

--	4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

	SELECT actor_id, first_name, last_name
	FROM sakila.actor
    WHERE last_name = "WILLIAMS";

	UPDATE sakila.actor
	SET first_name = "HARPO"
	WHERE actor_id = 172;

	SELECT actor_id, first_name, last_name
	FROM sakila.actor
	WHERE actor_id = 172;

/*
	4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
	It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
*/

	UPDATE sakila.actor 
	SET first_name = CASE 
		WHEN first_name = 'HARPO' 
			THEN 'GROUCHO' 
		END
	WHERE actor_id = 172;



#######################################################################################################################

--	5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
--		Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

	DESCRIBE sakila.address;

	SHOW COLUMNS FROM sakila.address;

	EXPLAIN sakila.address;

	SHOW CREATE TABLE misc_db.address;

#######################################################################################################################

--	6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
	
	DESCRIBE sakila.staff;

	DESCRIBE sakila.address;

	SELECT staff.first_name, staff.last_name, address.address 
	FROM sakila.staff 
	INNER JOIN sakila.address 
	ON (staff.staff_id = address.address_id);

--	6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

	DESCRIBE sakila.payment;

	SELECT sum(payment.amount) AS "Total", staff.first_name, staff.last_name
	FROM sakila.payment
	INNER JOIN sakila.staff
	ON staff.staff_id = payment.staff_id
	WHERE payment.payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59'
	GROUP BY payment.staff_id;

--	6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

	DESCRIBE sakila.film_actor;

	DESCRIBE sakila.film;
	
	SELECT film.film_id, film.title, count(film_actor.film_id) AS "N of actors in film"
	FROM sakila.film 
	INNER JOIN sakila.film_actor 
	ON film.film_id = film_actor.film_id 
	GROUP BY film.film_id
    ORDER BY COUNT(film_actor.film_id) DESC;


--	6d. How many copies of the film Hunchback Impossible exist in the inventory system?

	DESCRIBE sakila.inventory;

	SELECT film.title AS "Book Title", count(*) AS "Number of Copies"
	FROM sakila.film
	JOIN sakila.inventory
	ON film.film_id = inventory.film_id
	WHERE film.title LIKE '%hunchback impossible%'
	GROUP BY inventory.film_id;

--	6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

	DESCRIBE sakila.customer;

	SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS "Total"
	FROM sakila.payment 
	INNER JOIN sakila.customer 
	ON (payment.customer_id = customer.customer_id)
	GROUP BY payment.customer_id
	ORDER BY customer.last_name ASC;

#######################################################################################################################

/*	
	7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
	As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
	Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
*/

	SELECT film.title
	FROM sakila.film
	WHERE ((film.title LIKE 'k%') OR (film.title LIKE 'q%')) 
		AND language_id 
		IN (SELECT language_id
			FROM sakila.language
			WHERE name = 'english');

--	7b. Use subqueries to display all actors who appear in the film Alone Trip.

	USE sakila

	SELECT first_name, last_name
	FROM actor
	WHERE actor_id 
		in (select actor_id
			from film_actor
			where film_id
				in (select film_id 
					from film 
					where title = 'alone trip'));

--	7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
	
	use sakila

	select cu.first_name, cu.last_name, cu.email
	from customer cu
		join address a on cu.address_id = a.address_id
	    join city ci on ci.city_id = a.city_id
	    join country co on co.country_id = ci.country_id
	where co.country = 'canada';

--	7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

	use sakila

	select *
	from film
	where film_id in
		(select film_id
		from film_category
		where category_id in
			(select category_id
			from category
			where name = 'family'));

--	7e. Display the most frequently rented movies in descending order.

	use sakila

	select i.film_id, f.title, count(r.inventory_id) AS num_rentals
	from rental r
		join inventory i on i.inventory_id = r.inventory_id
		join film f on i.film_id = f.film_id
	group by i.film_id
	order by num_rentals desc;

--	7f. Write a query to display how much business, in dollars, each store brought in.

use sakila

select staff_id store, sum(amount) total_business
from payment
group by staff_id;

--	7g. Write a query to display for each store its store ID, city, and country.

use sakila

select store_id, city, country
from store
	join address on store.address_id = address.address_id
	join city on address.city_id = city.city_id
    join country on city.country_id = country.country_id;

--	7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

use sakila

select c.name, sum(amount) 'gross_revenue'
from payment p
	join rental r on p.rental_id = r.rental_id
	join inventory i on r.inventory_id = i.inventory_id
	join film_category f on i.film_id = f.film_id
    join category c on f.category_id = c.category_id
group by c.category_id
order by sum(amount) desc;

#######################################################################################################################

--	8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

use sakila

create view top_five_genres as
	select c.name, sum(amount) 'gross_revenue'
	from payment p
		join rental r on p.rental_id = r.rental_id
		join inventory i on r.inventory_id = i.inventory_id
		join film_category f on i.film_id = f.film_id
		join category c on f.category_id = c.category_id
	group by c.category_id
	order by sum(amount) desc;

--	8b. How would you display the view that you created in 8a?

use sakila

select *
from top_five_genres;

--	8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

use sakila

drop view if exists top_five_genres;