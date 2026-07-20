Categories
| Column       | Data Type | Description                                 |
| ------------ | --------- | ------------------------------------------- |
| category_id  | INT       | Unique identifier for each product category |
| product_line | VARCHAR   | Product category name                       |

Products
| Column       | Data Type | Description                         |
| ------------ | --------- | ----------------------------------- |
| product_id   | INT       | Unique identifier                   |
| category_id  | INT       | References Categories table         |
| product_code | VARCHAR   | Product code                        |
| msrp         | DECIMAL   | Manufacturer Suggested Retail Price |

Customers
| Column             | Data Type | Description     |
| ------------------ | --------- | --------------- |
| customer_id        | INT       | Unique customer |
| customer_name      | VARCHAR   | Customer name   |
| phone              | VARCHAR   | Contact number  |
| contact_first_name | VARCHAR   | First name      |
| contact_last_name  | VARCHAR   | Last name       |
| address_line1      | VARCHAR   | Address         |
| address_line2      | VARCHAR   | Address         |
| city               | VARCHAR   | City            |
| state              | VARCHAR   | State           |
| postal_code        | VARCHAR   | Postal code     |
| country            | VARCHAR   | Country         |
| territory          | VARCHAR   | Sales territory |

Orders
| Column       | Data Type | Description            |
| ------------ | --------- | ---------------------- |
| order_number | INT       | Order ID               |
| customer_id  | INT       | Customer placing order |
| order_date   | DATE      | Date of purchase       |
| status       | VARCHAR   | Order status           |
| qtr_id       | INT       | Quarter                |
| month_id     | INT       | Month                  |
| year_id      | INT       | Year                   |
| deal_size    | VARCHAR   | Small / Medium / Large |

Orders_Details
| Column            | Data Type | Description                  |
| ----------------- | --------- | ---------------------------- |
| order_number      | INT       | FK to Orders                 |
| order_line_number | INT       | Line number within the order |
| product_id        | INT       | FK to Products               |
| quantity          | INT       | Quantity ordered             |
| price_each        | DECIMAL   | Unit selling price           |
| sales             | DECIMAL   | Total sales amount           |
