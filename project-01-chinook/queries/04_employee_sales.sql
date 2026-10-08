/*
Which sales employee (via the support_rep_id on customers) 
has the highest total sales attributed to their customers?
*/


/*
taking a look at the tables we can see that the customer table has a column called
support_rep_id telling which employee was responsible for that costomer by that id
and that column is linked to the employee_id
*/

SELECT
    e.first_name,
    e.last_name,
    SUM(i.total) total_revenue
FROM employee e
JOIN customer c
    ON c.support_rep_id = e.employee_id
JOIN invoice i
    ON i.customer_id = c.customer_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_revenue DESC;


-- if we wanted to know how many customers were served by each employee
SELECT
    e.first_name,
    e.last_name,
    COUNT(c.customer_id) AS total_customers
FROM employee e
JOIN customer c
    ON c.support_rep_id = e.employee_id
GROUP BY e.employee_id;