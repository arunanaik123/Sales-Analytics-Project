-- ===========================================
-- Categories Table
-- ===========================================
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    product_line VARCHAR(50) NOT NULL UNIQUE
);


-- ===========================================
-- Products Table
-- ===========================================
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    product_code VARCHAR(50) NOT NULL UNIQUE,
    msrp DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);

-- ===========================================
-- Customers Table
-- ===========================================
CREATE TABLE Customers (

    customer_id INT PRIMARY KEY AUTO_INCREMENT,

    customer_company_name VARCHAR(100) NOT NULL,

    contact_first_name VARCHAR(50),

    contact_last_name VARCHAR(50),

    phone VARCHAR(20) NOT NULL,

    address_line1 VARCHAR(255) NOT NULL,

    address_line2 VARCHAR(255),

    city VARCHAR(50) NOT NULL,

    state VARCHAR(50) NOT NULL,

    postal_code VARCHAR(20) NOT NULL,

    country VARCHAR(50) NOT NULL,

    territory VARCHAR(50) NOT NULL

);

-- ===========================================
-- Orders Table
-- ===========================================
CREATE TABLE Orders (
    order_number INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    deal_size VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

-- ===========================================
-- Order_Details Table
-- ===========================================
CREATE TABLE Order_Details (

    order_number INT NOT NULL,

    order_line_number INT NOT NULL,

    product_id INT NOT NULL,

    quantity INT NOT NULL,

    price_each DECIMAL(10,2) NOT NULL,

    sales DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_number, order_line_number),

    FOREIGN KEY (order_number)
        REFERENCES Orders(order_number),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)

);