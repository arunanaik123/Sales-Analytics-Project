-- ============================================
-- Insert Categories
-- ============================================

INSERT INTO Categories (product_line)

SELECT DISTINCT
    PRODUCTLINE
FROM Sales_Raw;

-- ============================================
-- Insert Products
-- ============================================

INSERT INTO Products (category_id, product_code, msrp)

SELECT DISTINCT
    c.category_id,
    s.PRODUCTCODE,
    s.MSRP
FROM Sales_Raw AS s
JOIN Categories AS c
ON s.PRODUCTLINE = c.product_line;

-- ============================================
-- Insert Customers
-- ============================================

INSERT INTO Customers (
    customer_company_name,
    contact_first_name,
    contact_last_name,
    phone,
    address_line1,
    address_line2,
    city,
    state,
    postal_code,
    country,
    territory
)

SELECT DISTINCT
    CUSTOMERNAME,
    CONTACTFIRSTNAME,
    CONTACTLASTNAME,
    PHONE,
    ADDRESSLINE1,
    ADDRESSLINE2,
    CITY,
    STATE,
    POSTALCODE,
    COUNTRY,
    TERRITORY
FROM Sales_Raw;

-- ============================================
-- Insert Orders
-- ============================================

INSERT INTO Orders
(
    order_number,
    customer_id,
    order_date,
    status
)

SELECT DISTINCT
    s.ORDERNUMBER,
    c.customer_id,
    STR_TO_DATE(s.ORDERDATE,'%m/%d/%Y %H:%i'),
    s.STATUS

FROM Sales_Raw AS s

JOIN Customers AS c
ON c.customer_company_name = s.CUSTOMERNAME;

-- ============================================
-- Insert Order_Details
-- ============================================

INSERT INTO Order_Details
(
    order_number,
    order_line_number,
    product_id,
    quantity,
    price_each,
    sales,
    deal_size
)

SELECT
    s.ORDERNUMBER,
    s.ORDERLINENUMBER,
    p.product_id,
    s.QUANTITYORDERED,
    s.PRICEEACH,
    s.SALES,
    s.DEALSIZE
FROM Sales_Raw s
JOIN Products p
ON s.PRODUCTCODE = p.product_code;
