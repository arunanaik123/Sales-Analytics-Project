# ⚙️ Project Setup Guide

This guide explains how to set up the project from importing the raw dataset into MySQL to building the Power BI dashboards.

---

# Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/SALES-ANALYTICS-PROJECT.git
cd SALES-ANALYTICS-PROJECT
```

---

# Step 2: Install Required Software

Install the following tools before running the project:

- MySQL Server
- MySQL Workbench
- Python 3.10+
- Jupyter Notebook
- Power BI Desktop
- VS Code (Optional)

---

# Step 3: Install Python Libraries

Open Terminal inside the project folder.

```bash
pip install pandas
pip install matplotlib
pip install sqlalchemy
pip install pymysql
```

Or install everything together:

```bash
pip install pandas matplotlib sqlalchemy pymysql
```

---

# Step 4: Create the Database

Open MySQL Workbench and execute:

```
sql/01_create_database.sql
```

This creates the database:

```
sales_analytics
```

---

# Step 5: Create Tables

Execute:

```
sql/02_create_tables.sql
```

This creates all normalized tables:

- Customers
- Orders
- Order_Details
- Products
- Categories

---

# Step 6: Create Staging Table

Execute:

```
sql/03_create_staging_table.sql
```

The staging table stores the raw sales dataset before normalization.

---

# Step 7: Import Raw Dataset

Import the raw dataset

```
data/raw/sales_data.csv
```

into the staging table using MySQL Workbench's **Table Data Import Wizard**.

---

# Step 8: Normalize the Data

Execute:

```
sql/05_normalize_data.sql
```

The script separates the staging table into normalized relational tables.

---

# Step 9: Verify the Data

Check that the processed tables contain data.

Example:

```sql
SELECT * FROM Customers LIMIT 10;
SELECT * FROM Orders LIMIT 10;
SELECT * FROM Order_Details LIMIT 10;
SELECT * FROM Products LIMIT 10;
SELECT * FROM Categories LIMIT 10;
```

---

# Step 10: Export Processed Tables (Optional)

Export each normalized table as CSV files.

Store them inside:

```
data/processed/
```

- Customers.csv
- Orders.csv
- Order_Details.csv
- Products.csv
- Categories.csv

These files are used by Python and Power BI.

---

# Step 11: Connect Python to MySQL

Open

```
notebooks/Sales_Analytics.ipynb
```

Create the SQLAlchemy connection.

```python
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://username:password@localhost/sales_analytics"
)
```

Replace:

- username
- password

with your MySQL credentials.

---

# Step 12: Load Tables into Python

```python
import pandas as pd

customers = pd.read_sql("SELECT * FROM Customers", engine)
orders = pd.read_sql("SELECT * FROM Orders", engine)
order_details = pd.read_sql("SELECT * FROM Order_Details", engine)
products = pd.read_sql("SELECT * FROM Products", engine)
categories = pd.read_sql("SELECT * FROM Categories", engine)
```

Python is used for:

- Data validation
- Exploratory Data Analysis
- Creating visualizations

---

# Step 13: Load Data into Power BI

Open:

```
powerbi/all_sales_analytics_dashboard.pbix
```

If recreating the dashboard:

1. Open Power BI Desktop.
2. Click **Get Data → Text/CSV**.
3. Import all CSV files from:

```
data/processed/
```

- Customers.csv
- Orders.csv
- Order_Details.csv
- Products.csv
- Categories.csv

---

# Step 14: Create Relationships

Create the following relationships:

```
Customers (1) -------- (*) Orders

Orders (1) -------- (*) Order_Details

Products (1) -------- (*) Order_Details

Categories (1) -------- (*) Products
```

---

# Step 15: Refresh the Dashboard

Click

```
Home → Refresh
```

The Power BI report will automatically update all dashboards.

---

# Project Workflow

```
Raw CSV
      │
      ▼
MySQL Staging Table
      │
      ▼
Normalized SQL Tables
      │
      ├────────► SQL Business Analysis
      │
      ├────────► Python (EDA & Validation)
      │
      └────────► Power BI Dashboards
```

---

The project is now ready for analysis and dashboard exploration.