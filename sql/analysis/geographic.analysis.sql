/*
=============================================================
                 GEOGRAPHIC ANALYSIS
=============================================================

Objective:
Analyze geographical sales performance to identify the
highest revenue-generating countries and cities, measure
regional demand, evaluate customer spending patterns,
and understand the revenue contribution of each market.

=============================================================
*/

-- ==========================================================
-- KPI 1 - Revenue by Country
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
-- USA generated the highest revenue ($3,627,982.83).


-- ==========================================================
-- KPI 2 - Revenue by City
-- Business Question:
-- Which cities generate the highest revenue?
-- ==========================================================

SELECT
    c.city,
    ROUND(SUM(od.sales),2) AS total_revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- Result:
-- Madrid generated the highest revenue ($1,082,551.44).


-- ==========================================================
-- KPI 3 - Orders by Country
-- Business Question:
-- Which countries place the highest number of orders?
-- ==========================================================

SELECT
    c.country,
    COUNT(DISTINCT o.order_number) AS total_orders
FROM Orders o
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_orders DESC;

-- Result:
-- USA placed the highest number of orders (112).


-- ==========================================================
-- KPI 4 - Average Order Value by Country
-- Business Question:
-- Which countries spend the most per order?
-- ==========================================================

SELECT
    c.country,
    ROUND(SUM(od.sales),2) AS total_revenue,
    COUNT(DISTINCT o.order_number) AS total_orders,
    ROUND(SUM(od.sales) / COUNT(DISTINCT o.order_number),2) AS average_order_value
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY average_order_value DESC;

-- Result:
-- Switzerland recorded the highest average order value
-- ($58,856.78 across 2 orders).


-- ==========================================================
-- KPI 5 - Revenue Contribution by Country
-- Business Question:
-- What percentage of total company revenue does each country contribute?
-- ==========================================================

SELECT
    country,
    revenue,
    ROUND((revenue / total_revenue) * 100,2) AS revenue_contribution
FROM
(
    SELECT *,
           SUM(revenue) OVER() AS total_revenue
    FROM
    (
        SELECT
            c.country,
            SUM(od.sales) AS revenue
        FROM Orders o
        JOIN Order_Details od
            ON o.order_number = od.order_number
        JOIN Customers c
            ON c.customer_id = o.customer_id
        GROUP BY c.country
    ) t
) x
ORDER BY revenue_contribution DESC;

-- Result:
-- USA contributes approximately 36.16% of total company revenue.