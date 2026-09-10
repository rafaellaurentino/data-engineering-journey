/*

Which genre generates the most total revenue? 
Which generates the most units sold (is it the same genre — why or why not)?

*/

--Which genre generates the most total revenue? 
SELECT
    g.name,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM genre AS g
JOIN track AS t
    ON g.genre_id = t.genre_id
JOIN invoice_line AS il
    ON il.track_id = t.track_id
GROUP BY g.name
ORDER BY total_revenue DESC;


--Which generates the most units sold (is it the same genre — why or why not)?
SELECT
    g.name,
    COUNT(il.invoice_line_id) AS total_sold
FROM track t
JOIN invoice_line il
    ON t.track_id = il.track_id
JOIN genre g
    ON g.genre_id = t.genre_id
GROUP BY g.name
ORDER BY total_sold DESC;

/*
So yes, they are the same. The genre rock had a total revenue of 826.65 and a total of 835 units sold.
Probably because it´s the genre with more avaible tracks and also pretty popular,
then leads both in volume and in value
*/