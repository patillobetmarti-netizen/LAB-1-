-- Ejercicio 1 – Consultas básicas
-- Contactos de oficina: Mostrar códigos de oficina y teléfono.
SELECT officeCode, phone
FROM offices;

-- Detectives de correo electrónico: Empleados con emails terminados en .es.
SELECT employeeNumber, firstName, lastName, email
FROM employees
WHERE email LIKE '%.es';

-- Estado de confusión: Clientes sin información estatal (state NULL).
SELECT customerNumber, customerName, contactLastName, contactFirstName, state
FROM customers
WHERE state IS NULL;

-- Grandes gastadores: Pagos mayores a $20,000.
SELECT customerNumber, checkNumber, paymentDate, amount
FROM payments
WHERE amount > 20000;

-- Grandes gastadores de 2005: Pagos > $20,000 realizados en 2005.
SELECT customerNumber, checkNumber, paymentDate, amount
FROM payments
WHERE amount > 20000
  AND YEAR(paymentDate) = 2005;

-- Detalles distintos: Filas únicas en orderdetails según productCode.
SELECT DISTINCT productCode
FROM orderdetails;

-- Estadísticas globales de compradores: Número de compras por país.
SELECT country, COUNT(*) AS total_orders
FROM customers
JOIN orders USING (customerNumber)
GROUP BY country
ORDER BY total_orders DESC;

-- Ejercicio 2 – Consultas intermedias
-- Descripción de línea de producto más larga:
SELECT productLine, MAX(CHAR_LENGTH(textDescription)) AS max_length
FROM productlines;

-- Recuento de clientes por oficina:
SELECT o.officeCode, o.city, COUNT(c.customerNumber) AS customers_count
FROM offices o
LEFT JOIN employees e ON e.officeCode = o.officeCode
LEFT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY o.officeCode, o.city
ORDER BY customers_count DESC, o.officeCode;

-- Día de mayores ventas de autos:
SELECT DAYNAME(orderDate) AS day_of_week, COUNT(*) AS total_orders
FROM orders
GROUP BY DAYNAME(orderDate)
ORDER BY total_orders DESC
LIMIT 1;

-- Corrección de territorios faltantes:
SELECT officeCode,
       CASE 
           WHEN territory IS NULL THEN 'USA'
           ELSE territory
       END AS territory_corrected
FROM offices;

-- Estadísticas empleados Patterson (2004 y 2005):
SELECT YEAR(o.orderDate) AS order_year,
       MONTH(o.orderDate) AS order_month,
       AVG(od.priceEach * od.quantityOrdered) AS avg_cart_amount,
       SUM(od.quantityOrdered) AS total_items
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
WHERE e.lastName = 'Patterson'
  AND YEAR(o.orderDate) IN (2004, 2005)
GROUP BY YEAR(o.orderDate), MONTH(o.orderDate)
ORDER BY YEAR(o.orderDate), MONTH(o.orderDate);

-- Ejercicio 3 – Subconsultas
-- Análisis de compras anuales (Patterson, 2004 y 2005):
SELECT year, month,
       AVG(cart_total) AS avg_cart_amount,
       SUM(total_items) AS total_items
FROM (
    SELECT YEAR(o.orderDate) AS year,
           MONTH(o.orderDate) AS month,
           SUM(od.priceEach * od.quantityOrdered) AS cart_total,
           SUM(od.quantityOrdered) AS total_items
    FROM orders o
    JOIN customers c ON o.customerNumber = c.customerNumber
    JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    WHERE e.lastName = 'Patterson'
      AND YEAR(o.orderDate) IN (2004, 2005)
    GROUP BY o.orderNumber
) AS monthly_totals
GROUP BY year, month
ORDER BY year, month;

-- Viaje a la oficina – oficinas con empleados que atienden clientes sin state:
SELECT DISTINCT o.officeCode, o.city, o.country
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE c.state IS NULL;