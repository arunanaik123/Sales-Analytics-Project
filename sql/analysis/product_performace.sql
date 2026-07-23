/*
=============================================================
                 PRODUCT PERFORMANCE ANALYSIS
=============================================================

Objective:
Analyze product and category performance to identify the
highest revenue generators, best-selling products,
customer demand, pricing strategy, and product contribution
towards total company revenue.

=============================================================
*/

-- ==========================================================
-- KPI 1 - Highest Revenue Generating Product
-- Business Question:
-- Which individual products generate the highest revenue?
-- ==========================================================

SELECT
    p.product_code,
    c.product_line,
    SUM(od.sales) AS total_revenue
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_code,
    c.product_line
ORDER BY total_revenue DESC;

-- Result:
-- Identifies the highest revenue generating products.


-- ==========================================================
-- KPI 2 - Highest Revenue Generating Product Category
-- Business Question:
-- Which product category generates the highest revenue?
-- ==========================================================

SELECT
    c.product_line AS category_name,
    SUM(od.sales) AS total_revenue
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    c.product_line
ORDER BY total_revenue DESC;

-- Result:
-- Classic Cars generated the highest revenue.


-- ==========================================================
-- KPI 3 - Highest Quantity Sold by Product Category
-- Business Question:
-- Which product category has the highest customer demand?
-- ==========================================================

SELECT
    c.product_line AS category_name,
    SUM(od.quantity) AS total_quantity
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    c.product_line
ORDER BY total_quantity DESC;

-- Result:
-- Classic Cars sold the highest quantity.


-- ==========================================================
-- KPI 4 - Highest Quantity Sold by Product
-- Business Question:
-- Which individual products sold the highest quantity?
-- ==========================================================

SELECT
    p.product_code,
    c.product_line,
    SUM(od.quantity) AS total_quantity
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_code,
    c.product_line
ORDER BY total_quantity DESC;

-- Result:
-- Identifies the highest selling products by quantity.


-- ==========================================================
-- KPI 5 - Average Selling Price vs MSRP
-- Business Question:
-- How does the average selling price compare with MSRP?
-- ==========================================================

SELECT
    p.product_code,
    c.product_line,
    p.msrp,
    ROUND(AVG(od.price_each),2) AS average_selling_price,
    ROUND(p.msrp - AVG(od.price_each),2) AS average_discount
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_code,
    c.product_line,
    p.msrp
ORDER BY average_discount DESC;

-- Result:
-- Shows products receiving the largest average discount.


-- ==========================================================
-- KPI 6 - Product Category Performance Over Time
-- Business Question:
-- How does each product category perform over time?
-- ==========================================================

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTHNAME(o.order_date) AS sales_month,
    c.product_line,
    SUM(od.sales) AS total_revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    YEAR(o.order_date),
    MONTHNAME(o.order_date),
    c.product_line;

-- Result:
-- Visualization required to compare category trends across years.


-- ==========================================================
-- KPI 7 - Best Performing Product in Each Category
-- Business Question:
-- Which product generates the highest revenue within each category?
-- ==========================================================

SELECT *
FROM
(
    SELECT *,
           RANK() OVER
           (
               PARTITION BY product_line
               ORDER BY total_revenue DESC
           ) AS ranked
    FROM
    (
        SELECT
            c.product_line,
            p.product_code,
            SUM(od.sales) AS total_revenue
        FROM Order_Details od
        JOIN Products p
            ON od.product_id = p.product_id
        JOIN Categories c
            ON p.category_id = c.category_id
        GROUP BY
            c.product_line,
            p.product_code
    ) t
) x
WHERE ranked = 1;

-- Result:
-- Displays the top revenue generating product in every category.


-- ==========================================================
-- KPI 8 - Pareto Analysis (80/20 Rule)
-- Business Question:
-- Which products contribute approximately 80% of total revenue?
-- ==========================================================

SELECT *
FROM
(
    SELECT
        product_code,
        revenue,
        running_total,
        ROUND((running_total / total_revenue) * 100,2) AS cumulative_percent
    FROM
    (
        SELECT *,
               SUM(revenue) OVER
               (
                   ORDER BY revenue DESC, product_code
               ) AS running_total,
               SUM(revenue) OVER() AS total_revenue
        FROM
        (
            SELECT
                p.product_code,
                SUM(od.sales) AS revenue
            FROM Order_Details od
            JOIN Products p
                ON od.product_id = p.product_id
            GROUP BY
                p.product_code
        ) t
    ) x
) d
WHERE cumulative_percent <= 80;

-- Result:
-- Products contributing nearly 80% of total company revenue.


-- ==========================================================
-- KPI 9 - Lowest Revenue Generating Products
-- Business Question:
-- Which products generate the lowest revenue?
-- ==========================================================

SELECT
    p.product_code,
    c.product_line,
    SUM(od.sales) AS revenue
FROM Order_Details od
JOIN Products p
    ON od.product_id = p.product_id
JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_code,
    c.product_line
ORDER BY revenue ASC
LIMIT 10;

-- Result:
-- Bottom 10 revenue generating products.


-- ==========================================================
-- KPI 10 - Revenue Contribution by Product Category
-- Business Question:
-- What percentage of total revenue does each product category contribute?
-- ==========================================================

SELECT *,
       ROUND((revenue / total_revenue) * 100,2) AS revenue_contribution
FROM
(
    SELECT *,
           SUM(revenue) OVER() AS total_revenue
    FROM
    (
        SELECT
            c.product_line,
            SUM(od.sales) AS revenue
        FROM Order_Details od
        JOIN Products p
            ON od.product_id = p.product_id
        JOIN Categories c
            ON p.category_id = c.category_id
        GROUP BY
            c.product_line
    ) t
) x
ORDER BY revenue_contribution DESC;

-- Result:
-- Displays each product category's percentage contribution to total revenue.

-- ==========================================================
-- KPI 11 - Overall Deal Size Performance
-- Business Question:
-- Which deal size generates the highest revenue and order volume?
-- ==========================================================

SELECT
    deal_size,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales),2) AS total_revenue
FROM Order_Details
GROUP BY deal_size
ORDER BY total_revenue DESC;

-- Result:
-- Medium deal size generates the highest revenue and sales volume.

-- ==========================================================
-- KPI 12 - Dominant Deal Size by Product Category
-- Business Question:
-- Which deal size contributes the highest revenue within each product category?
-- ==========================================================

SELECT
    product_line,
    deal_size,
    revenue
FROM
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY product_line
               ORDER BY revenue DESC
           ) AS rn
    FROM
    (
        SELECT
            c.product_line,
            od.deal_size,
            ROUND(SUM(od.sales),2) AS revenue
        FROM Orders o
        JOIN Order_Details od
            ON o.order_number = od.order_number
        JOIN Products p
            ON od.product_id = p.product_id
        JOIN Categories c
            ON p.category_id = c.category_id
        GROUP BY
            c.product_line,
            od.deal_size
    ) t
) x
WHERE rn = 1;

-- Result:
-- Medium deal size is the highest revenue contributor across every product category.