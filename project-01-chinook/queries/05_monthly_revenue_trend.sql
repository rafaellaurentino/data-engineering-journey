/*

What is monthly revenue over the full time range in the data — 
is there a growth or decline trend?

*/

SELECT
    DATE_TRUNC('month', i.invoice_date) AS month,
    SUM(i.total) AS monthly_revenue
FROM invoice i
GROUP BY month
ORDER BY month

/*

The monthly revenue remained relatively constant throughout the analyzed period, 
ranging only between 35 and 38. Therefore, there is no evidence of growth or decline..

*/