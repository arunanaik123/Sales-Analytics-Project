/*
=============================================================
                 CUSTOMER SALES ANALYSIS
=============================================================

Objective:
Analyze customer purchasing behavior to identify the
highest-value customers, regional performance,
customer concentration, and customer segmentation.

=============================================================
*/

-- ==========================================================
-- KPI 1 - Top Revenue Generating Customers
-- Business Question:
-- Which customers generate the highest revenue?
-- ==========================================================

SELECT
    c.customer_company_name AS customer_name,
    ROUND(SUM(od.sales),2) AS total_revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_company_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Result:
-- Euro Shopping Channel generated the highest revenue ($912,294.11).


-- ==========================================================
-- KPI 2 - Customers with Highest Number of Orders
-- Business Question:
-- Which customers place the highest number of orders?
-- ==========================================================

SELECT
    c.customer_company_name AS customer_name,
    COUNT(o.order_number) AS total_orders
FROM Orders o
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_company_name
ORDER BY total_orders DESC;

-- Result:
-- Euro Shopping Channel placed the highest number of orders (26).


-- ==========================================================
-- KPI 3 - Average Order Value by Customer
-- Business Question:
-- Which customers spend the most on each order?
-- ==========================================================

SELECT
    c.customer_company_name AS customer_name,
    ROUND(SUM(od.sales),2) AS total_revenue,
    COUNT(DISTINCT o.order_number) AS total_orders,
    ROUND(SUM(od.sales) / COUNT(DISTINCT o.order_number),2) AS average_order_value
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.customer_company_name
ORDER BY average_order_value DESC;

-- Result:
-- Average order value varies significantly across customers.


-- ==========================================================
-- KPI 4 - Revenue by Country
-- Business Question:
-- Which countries generate the highest revenue?
-- ==========================================================

SELECT
    c.country,
    ROUND(SUM(od.sales),2) AS total_revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- Result:
-- USA generated the highest revenue followed by Spain and France.


-- ==========================================================
-- KPI 5 - Revenue by Territory
-- Business Question:
-- Which sales territories perform best?
-- ==========================================================

SELECT
    c.territory,
    ROUND(SUM(od.sales),2) AS total_revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.territory
ORDER BY total_revenue DESC;

-- Result:
-- EMEA generated the highest revenue followed by NA, APAC and Japan.


-- ==========================================================
-- KPI 6 - Customer Distribution by Country
-- Business Question:
-- Which countries have the highest number of customers?
-- ==========================================================

SELECT
    c.country,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM Customers c
GROUP BY c.country
ORDER BY total_customers DESC;

-- Result:
-- USA has the highest number of customers followed by France.


-- ==========================================================
-- KPI 7 - Highest Average Order Value Customers
-- Business Question:
-- Which customers spend the most per order?
-- ==========================================================

SELECT
    c.customer_company_name AS customer_name,
    ROUND(SUM(od.sales) / COUNT(DISTINCT o.order_number),2) AS average_order_value
FROM Orders o
JOIN Customers c
    ON c.customer_id = o.customer_id
JOIN Order_Details od
    ON od.order_number = o.order_number
GROUP BY c.customer_company_name
ORDER BY average_order_value DESC;

-- Result:
-- Vida Sport Ltd has the highest average order value ($58,856.78).


-- ==========================================================
-- KPI 8 - Pareto Analysis (80/20 Rule)
-- Business Question:
-- Which customers contribute approximately 80% of total revenue?
-- ==========================================================

SELECT *
FROM
(
    SELECT
        customer_name,
        revenue,
        cumulative,
        ROUND((cumulative / total_revenue) * 100,2) AS cumulative_percent
    FROM
    (
        SELECT *,
               SUM(revenue) OVER(ORDER BY revenue DESC, customer_name) AS cumulative,
               SUM(revenue) OVER() AS total_revenue
        FROM
        (
            SELECT
                c.customer_company_name AS customer_name,
                SUM(od.sales) AS revenue
            FROM Orders o
            JOIN Customers c
                ON c.customer_id = o.customer_id
            JOIN Order_Details od
                ON od.order_number = o.order_number
            GROUP BY c.customer_company_name
        ) t
    ) x
) d
WHERE cumulative_percent <= 80;

-- Result:
-- 56 customers generate approximately 80% of total company revenue.


-- ==========================================================
-- KPI 9 - Revenue Contribution by Customer
-- Business Question:
-- What percentage of total revenue does each customer contribute?
-- ==========================================================

SELECT
    customer_name,
    revenue,
    ROUND((revenue / total_revenue) * 100,2) AS revenue_contribution
FROM
(
    SELECT *,
           SUM(revenue) OVER() AS total_revenue
    FROM
    (
        SELECT
            c.customer_company_name AS customer_name,
            SUM(od.sales) AS revenue
        FROM Orders o
        JOIN Customers c
            ON c.customer_id = o.customer_id
        JOIN Order_Details od
            ON od.order_number = o.order_number
        GROUP BY c.customer_company_name
    ) t
) x
ORDER BY revenue_contribution DESC;

-- Result:
-- Euro Shopping Channel contributes 9.09% of total revenue.


-- ==========================================================
-- KPI 10 - Customer Segmentation
-- Business Question:
-- How can customers be segmented based on revenue contribution?
-- ==========================================================

SELECT
    customer_segmentation,
    COUNT(*) AS total_customers
FROM
(
    SELECT *,
           CASE
               WHEN revenue_contribution >= 5 THEN 'Platinum'
               WHEN revenue_contribution >= 2 THEN 'Gold'
               WHEN revenue_contribution >= 1 THEN 'Silver'
               ELSE 'Bronze'
           END AS customer_segmentation
    FROM
    (
        SELECT
            customer_name,
            revenue,
            ROUND((revenue / total_revenue) * 100,2) AS revenue_contribution
        FROM
        (
            SELECT *,
                   SUM(revenue) OVER() AS total_revenue
            FROM
            (
                SELECT
                    c.customer_company_name AS customer_name,
                    SUM(od.sales) AS revenue
                FROM Orders o
                JOIN Customers c
                    ON c.customer_id = o.customer_id
                JOIN Order_Details od
                    ON od.order_number = o.order_number
                GROUP BY c.customer_company_name
            ) t
        ) x
    ) y
) z
GROUP BY customer_segmentation;

-- Result:
-- Platinum : 2 Customers
-- Gold      : 1 Customer
-- Silver    : 35 Customers
-- Bronze    : 54 Customers