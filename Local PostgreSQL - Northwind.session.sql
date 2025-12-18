/*
Creator: Sander Oostrom
Created On: 2024-06-12
Query Name: 1996 Revenue Performance Analyses Sample Data
Data Source: Self Created PostgreSQL DB Containing Sample Data Schema Northwind
Objective: Creating a performance analyses output for Tableau to calculate total net and discounted revenue
           per employee, supplier and region for the 1996 fiscal year, excluding regions ('RJ', 'DF').
*/

WITH cte1_imports AS (SELECT c.customer_id, c.company_name AS customer_name, c.region, c.country, o.order_date, o.order_id, od.product_id, od.unit_price, od.quantity,
                             od.discount, p.product_name, cat.category_name,cat.description, e.first_name, e.last_name, s.company_name AS supplier_name
                      FROM orders AS o
                      LEFT JOIN order_details AS od ON o.order_id = od.order_id                                        
                      LEFT JOIN products AS p ON od.product_id = p.product_id
                      LEFT JOIN customers AS c ON o.customer_id = c.customer_id  
                      LEFT JOIN employees AS e ON o.employee_id = e.employee_id
                      LEFT JOIN suppliers AS s ON p.supplier_id = s.supplier_id
                      LEFT JOIN categories AS cat ON p.category_id = cat.category_id),

     cte2_transform AS (SELECT customer_id, customer_name, region, order_date, order_id, product_id, unit_price, quantity,
                             discount, country, supplier_name, product_name, category_name, description AS category_description, ROUND((quantity * unit_price)) AS net_revenue,
                             (ROUND((quantity * unit_price) * (1 - discount))) AS revenue_after_discount, CONCAT(first_name,' ', last_name) AS full_name
                        FROM cte1_imports
                        WHERE region IS NOT NULL AND
                              order_date >= '1996-01-01' AND order_date < '1996-12-31' AND
                              region NOT IN ('RJ', 'DF')
                      )
                                              
SELECT * FROM cte2_transform ;