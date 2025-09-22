--  Seleccione todos los actores con el nombre Scarlett
SELECT * 
FROM actor
WHERE first_name = 'Scarlett';

-- Seleccione todos los actores con el apellido Johansson
SELECT * 
FROM actor
WHERE last_name = 'Johansson';

-- ¿Cuántas películas están disponibles para alquilar?
SELECT COUNT(DISTINCT film_id) AS films_available
FROM inventory;

-- ¿Cuántas películas se han alquilado?
SELECT COUNT(DISTINCT inventory_id) AS films_rented
FROM rental;

-- Cuál es el período de alquiler más corto y más largo?
SELECT MIN(rental_duration) AS shortest_rental, 
       MAX(rental_duration) AS longest_rental
FROM film;

-- ¿Cuál es la duración más corta y más larga de una película?
SELECT MIN(length) AS min_duration,
       MAX(length) AS max_duration
FROM film;

-- ¿Cuál es la duración media de una película?
SELECT AVG(length) AS avg_duration
FROM film;

-- Duración promedio en formato (horas, minutos)
SELECT FLOOR(AVG(length) / 60) AS hours,
       ROUND(AVG(length) % 60) AS minutes
FROM film;

-- ¿Cuántas películas duran más de 3 horas?
SELECT COUNT(*) AS films_over_3h
FROM film
WHERE length > 180;

-- Formatee el nombre y el correo electrónico de clientes
SELECT CONCAT(first_name, ' ', UPPER(last_name), ' - ', email) AS formatted_contact
FROM customer;

-- ¿Cuál es la longitud del título más largo de una película?
SELECT MAX(LENGTH(title)) AS max_title_length
FROM film;
 