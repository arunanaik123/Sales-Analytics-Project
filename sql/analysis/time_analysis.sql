/*
=============================================================
                    TIME ANALYSIS
=============================================================

Objective:
Analyze sales performance over time to identify monthly
trends, growth patterns, seasonality, quarterly performance,
and yearly business growth.

=============================================================
*/

-- ==========================================================
-- KPI 1 - Monthly Revenue Trend
-- Business Question:
-- How does monthly revenue change over time?
-- ==========================================================

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTH(o.order_date) AS sales_month_no,
    MONTHNAME(o.order_date) AS sales_month,
    ROUND(SUM(od.sales),2) AS revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date),
    MONTHNAME(o.order_date)
ORDER BY
    sales_year,
    sales_month_no;

-- Result:
-- Visualization (Line Chart) clearly shows monthly revenue trend.


-- ==========================================================
-- KPI 2 - Month-over-Month Revenue Growth
-- Business Question:
-- Is revenue growing or declining compared to the previous month?
-- ==========================================================

SELECT
    sales_year,
    sales_month,
    revenue,
    ROUND(previous_month,2) AS previous_month_revenue,
    ROUND(
        ((revenue - previous_month) /
        NULLIF(previous_month,0))*100,2
    ) AS growth_percent,

    CASE
        WHEN previous_month IS NULL THEN 'N/A'
        WHEN revenue > previous_month THEN 'Growing'
        WHEN revenue < previous_month THEN 'Declining'
        ELSE 'Stable'
    END AS sales_trend

FROM
(
    SELECT *,
           LAG(revenue)
           OVER(ORDER BY sales_year,sales_month_no)
           AS previous_month
    FROM
    (
        SELECT
            YEAR(o.order_date) AS sales_year,
            MONTH(o.order_date) AS sales_month_no,
            MONTHNAME(o.order_date) AS sales_month,
            SUM(od.sales) AS revenue
        FROM Orders o
        JOIN Order_Details od
            ON o.order_number = od.order_number
        GROUP BY
            YEAR(o.order_date),
            MONTH(o.order_date),
            MONTHNAME(o.order_date)
    ) x
) t;

-- Result:
-- Shows monthly sales growth and identifies growing and declining periods.


-- ==========================================================
-- KPI 3 - Best and Worst Sales Months
-- Business Question:
-- Which months consistently generate the highest and lowest revenue?
-- ==========================================================

SELECT
    MONTHNAME(o.order_date) AS sales_month,
    ROUND(SUM(od.sales),2) AS revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
GROUP BY
    MONTH(o.order_date),
    MONTHNAME(o.order_date)
ORDER BY revenue DESC;

-- Result:
-- Highest revenue months appear at the top,
-- while lowest-performing months appear at the bottom.
-- Visualization recommended using a column chart.


-- ==========================================================
-- KPI 4 - Quarterly Revenue Analysis
-- Business Question:
-- Which quarter contributes the highest revenue?
-- ==========================================================

SELECT
    QUARTER(o.order_date) AS sales_quarter,
    ROUND(SUM(od.sales),2) AS revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
GROUP BY
    QUARTER(o.order_date)
ORDER BY revenue DESC;

-- Result:
-- Quarter 4 generated the highest revenue
-- ($3,874,780.01).


-- ==========================================================
-- KPI 5 - Year-over-Year Revenue Analysis
-- Business Question:
-- Which year generated the highest revenue?
-- ==========================================================

SELECT
    YEAR(o.order_date) AS sales_year,
    ROUND(SUM(od.sales),2) AS revenue
FROM Orders o
JOIN Order_Details od
    ON o.order_number = od.order_number
GROUP BY
    YEAR(o.order_date)
ORDER BY revenue DESC;

-- Result:
-- 2004 generated the highest annual revenue
-- ($4,724,162.60).
