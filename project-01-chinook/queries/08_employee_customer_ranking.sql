/*

Rank each employee's customers by how much they've spent 
(window function), and find each employee's single highest-spending customer.

*/

--Rank each employee's customers by how much they've spent 


WITH employee_customer_rank AS (
                    SELECT
                        e.first_name AS employee_firstname,
                        e.last_name AS employee_lastname,
                        c.first_name AS customer_firstname,
                        c.last_name AS customer_lastname,
                        SUM(i.total) AS total,
                        RANK() OVER(PARTITION BY e.employee_id ORDER BY SUM(i.total) DESC) AS rank_customers
                    FROM employee e
                    JOIN customer c
                        ON e.employee_id = c.support_rep_id
                    JOIN invoice i
                        ON i.customer_id = c.customer_id
                    GROUP BY e.first_name, e.last_name, c.first_name, c.last_name, c.customer_id, e.employee_id
)


SELECT
    *
FROM employee_customer_rank
WHERE rank_customers = 1;