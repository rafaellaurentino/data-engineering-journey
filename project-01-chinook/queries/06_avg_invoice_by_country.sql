/*

For each country, what is the average invoice total? 
Which country has the highest average order value?

*/

SELECT
    *
FROM invoice;
--after we o took a look at the invoice table, we can see that we´ll be needing only

--Which country has the highest average order value?
SELECT
    i.billing_country,
    AVG(i.total) AS avg
FROM invoice i
GROUP BY i.billing_country
ORDER BY avg DESC;
-- The country with highest average order value is chile with 6.66