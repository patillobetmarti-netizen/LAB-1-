-- 1. Total gastado por cada cliente
SELECT s.customer_id, SUM(m.price) AS total_gastado
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- 2. Días visitados por cliente
SELECT customer_id, COUNT(DISTINCT order_date) AS dias_visitados
FROM sales
GROUP BY customer_id;
 
-- 3. Primer artículo comprado por cada cliente
SELECT s.customer_id, s.order_date, m.product_name, m.price
FROM sales s
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date = (
    SELECT MIN(order_date)
    FROM sales
    WHERE customer_id = s.customer_id
);
 
-- 4. Artículo más comprado en el menú
SELECT m.product_name, COUNT(*) AS veces_comprado
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY veces_comprado DESC
LIMIT 1;
 
-- 5. Artículo más popular por cliente
SELECT customer_id, product_name, COUNT(*) AS veces
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY customer_id, product_name
HAVING COUNT(*) = (
    SELECT MAX(contador)
    FROM (
        SELECT COUNT(*) AS contador
        FROM sales s2
        WHERE s2.customer_id = s.customer_id
        GROUP BY s2.product_id
    ) t
);
 
-- 6. Primer artículo después de ser miembro
SELECT s.customer_id, m.product_name, s.order_date
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date = (
    SELECT MIN(order_date)
    FROM sales
    WHERE customer_id = s.customer_id
      AND order_date >= mb.join_date
);
 
-- 7. Artículo justo antes de ser miembro
SELECT s.customer_id, m.product_name, s.order_date
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date = (
    SELECT MAX(order_date)
    FROM sales
    WHERE customer_id = s.customer_id
      AND order_date < mb.join_date
);
 
-- 8. Total artículos y gasto antes de ser miembro
SELECT s.customer_id,
       COUNT(*) AS total_articulos,
       SUM(m.price) AS total_gastado
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;
 
-- 9. Puntos con regla normal (sólo miembros después de join_date)
SELECT s.customer_id,
       SUM(CASE 
              WHEN m.product_name = 'sushi' THEN m.price * 20
               ELSE m.price * 10
           END
       ) AS puntos
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date >= mb.join_date
GROUP BY s.customer_id;
 
-- 10. Puntos con primera semana doble
SELECT s.customer_id,
       SUM(CASE 
               WHEN s.order_date BETWEEN mb.join_date AND DATE_ADD(mb.join_date, INTERVAL 6 DAY)
                    THEN m.price * 20
               WHEN m.product_name = 'sushi' THEN m.price * 20
               ELSE m.price * 10
           END
       ) AS puntos
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date >= mb.join_date
  AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id;
 