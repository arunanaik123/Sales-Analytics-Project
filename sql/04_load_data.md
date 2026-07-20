# Loading Raw Dataset

## Source

Sample Sales Dataset (CSV)

## Import Method

MySQL Workbench → Table Data Import Wizard

Imported CSV into:

Sales_Raw

## Verification

```sql
SELECT COUNT(*) FROM Sales_Raw;

SELECT * FROM Sales_Raw LIMIT 10;