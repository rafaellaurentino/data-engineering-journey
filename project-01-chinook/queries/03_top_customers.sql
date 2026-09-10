/*
Who are the top 5 customers by total amount spent, and which country are they from?
*/

SELECT
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_gasto,
    c.country
FROM customer c
JOIN invoice i
    ON i.customer_id = c.customer_id
GROUP BY c.customer_id,c.first_name, c.last_name, c.country
ORDER BY total_gasto DESC
LIMIT 5;

--Agrupar por c.customer_id garante que cada cliente seja único, 
--mesmo que nomes se repitam.
