/*
===============================================================================
Project: Coffee Shop Sales Analytics
Author: Brice Abogo
Description: This script performs data cleaning, transformation, and 
             business analysis to derive key performance indicators (KPIs).
===============================================================================
*/

-- =============================================================================
-- 1. DATA CLEANING & TRANSFORMATION
-- =============================================================================

SET SQL_SAFE_UPDATES = 0;

-- Standardizing Date and Time formats
UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d/%m/%Y');

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

-- Optimizing Data Types
ALTER TABLE coffee_shop_sales MODIFY COLUMN transaction_date DATE;
ALTER TABLE coffee_shop_sales MODIFY COLUMN transaction_time TIME;

-- Fixing encoding issues in column names
ALTER TABLE coffee_shop_sales CHANGE COLUMN `ï»¿transaction_id` transaction_id INT;

SET SQL_SAFE_UPDATES = 1;

-- =============================================================================
-- 2. BUSINESS ANALYSIS QUERIES (KPIs)
-- =============================================================================

-- Total Revenue, Orders and Quantity for the current period (May)
SELECT 
    ROUND(SUM(unit_price * transaction_qty), 2) AS Total_Sales,
    COUNT(transaction_id) AS Total_Orders,
    SUM(transaction_qty) AS Total_Qty_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5;

-- Month-over-Month (MoM) Growth Analysis
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty), 2) AS total_sales,
    ((SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) * 100 AS sales_mom_growth_pct
FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (4, 5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- Peak Hour Analysis to optimize staffing
SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty), 2) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY HOUR(transaction_time)
ORDER BY Hour_of_Day;

-- Top 10 Product Performance
SELECT 
    product_type,
    ROUND(SUM(unit_price * transaction_qty), 2) AS Total_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY Total_Sales DESC
LIMIT 10;
