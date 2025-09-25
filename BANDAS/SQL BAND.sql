USE bands;
 
SELECT mn.musician_name,
       SUM(a.sales_amount) AS total_sales,
       CASE
         WHEN SUM(a.sales_amount) >= 33273156 THEN 'Alta'
         WHEN SUM(a.sales_amount) >= 16636539 THEN 'Media'
         ELSE 'Baja'
       END AS categoria
FROM musician m
JOIN musician_name mn ON m.musician_id = mn.musician_id
JOIN band_musician bm ON m.musician_id = bm.musician_id
JOIN band b ON bm.band_id = b.band_id
JOIN album a ON b.band_id = a.band_id
WHERE bm.musician_status = 'current'
GROUP BY mn.musician_name
ORDER BY total_sales DESC;

use bands;
SELECT b.band_name, t.year AS best_year, t.albums AS albums, t.ventas AS ventas
FROM (
  SELECT a.band_id,
         YEAR(a.release_date) AS year,
         COUNT(*) AS albums,
         COALESCE(SUM(a.sales_amount),0) AS ventas,
         ROW_NUMBER() OVER (
           PARTITION BY a.band_id
           ORDER BY COALESCE(SUM(a.sales_amount),0) DESC
         ) AS rn
  FROM album a
  WHERE a.release_date IS NOT NULL
  GROUP BY a.band_id, YEAR(a.release_date)
) AS t
JOIN band b ON b.band_id = t.band_id
WHERE t.rn = 1
ORDER BY t.v DESC, b.band_name;

 
 use bands;
SELECT
  b.band_name,
  s90.albums_90s,
  s90.sales_90s,
  ROUND(100 * s90.sales_90s / NULLIF(sall.sales_total, 0), 1) AS pct_sobre_total
FROM band b
JOIN (
  -- Ventas y álbumes de cada banda en los 90s
  SELECT
    a.band_id,
    COUNT(*) AS albums_90s,
    SUM(COALESCE(a.sales_amount,0)) AS sales_90s
  FROM album a
  WHERE a.release_date BETWEEN '1990-01-01' AND '1999-12-31'
  GROUP BY a.band_id
) AS s90 ON s90.band_id = b.band_id
JOIN (
  -- Ventas totales históricas por banda (todos los años)
  SELECT
    a.band_id,
    SUM(COALESCE(a.sales_amount,0)) AS sales_total
  FROM album a
  GROUP BY a.band_id
) AS sall ON sall.band_id = b.band_id
ORDER BY s90.sales_90s DESC, b.band_name
LIMIT 5;

use bands;
SELECT MIN(mn.musician_name) AS musician_name, bm.musician_id, COUNT(DISTINCT a.album_id) AS albums_cnt
FROM band_musician bm
JOIN album a ON a.band_id = bm.band_id
LEFT JOIN musician_name mn ON mn.musician_id = bm.musician_id
WHERE LOWER(bm.musician_status) = 'current'
GROUP BY bm.musician_id
ORDER BY albums_cnt DESC
LIMIT 1;


