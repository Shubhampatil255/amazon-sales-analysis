use amazon_db;
-- =====================
-- DATA CLEANING
-- =====================

DROP TABLE IF EXISTS amazon_clean;

CREATE TABLE amazon_clean AS
SELECT * FROM amazon;

SET SQL_SAFE_UPDATES = 0;

UPDATE amazon_clean
SET Order_Date = STR_TO_DATE(Order_Date,'%m/%d/%Y');

ALTER TABLE amazon_clean MODIFY Order_Date DATE;


ALTER TABLE amazon_clean 
MODIFY Quantity INT,
MODIFY Unit_Price DECIMAL(10,2),
MODIFY Discount DECIMAL(5,2),
MODIFY Tax DECIMAL(10,2),
MODIFY Shipping_Cost DECIMAL(10,2),
MODIFY Total_Amount DECIMAL(10,2);


-- =====================
-- BASIC CHECKS
-- =====================

SELECT COUNT(*) FROM amazon_clean;

SELECT MIN(Order_Date), MAX(Order_Date)
FROM amazon_clean;

SELECT 
SUM(Order_Date IS NULL) AS missing_dates,
SUM(Total_Amount IS NULL) AS missing_amount
FROM amazon_clean;
-- =====================
-- BASIC ANALYSIS
-- =====================

-- total revenue
SELECT SUM(Total_Amount) FROM amazon_clean;

-- total orders
SELECT COUNT(DISTINCT Order_ID) FROM amazon_clean;

-- avg order value
SELECT AVG(Total_Amount) FROM amazon_clean;


-- =====================
-- CATEGORY ANALYSIS
-- =====================

SELECT Category, SUM(Total_Amount)
FROM amazon_clean
GROUP BY Category;

-- orders per category
SELECT Category, COUNT(*) 
FROM amazon_clean
GROUP BY Category;

-- =====================
-- TOP PRODUCTS
-- =====================

SELECT Product_Name, SUM(Total_Amount)
FROM amazon_clean
GROUP BY Product_Name
ORDER BY SUM(Total_Amount) DESC
LIMIT 10;


-- =====================
-- MONTHLY SALES
-- =====================

SELECT 
DATE_FORMAT(Order_Date,'%Y-%m') AS month,
SUM(Total_Amount)
FROM amazon_clean
GROUP BY DATE_FORMAT(Order_Date,'%Y-%m');


-- =====================
-- TOP CUSTOMERS
-- =====================

SELECT Customer_Name, SUM(Total_Amount)
FROM amazon_clean
GROUP BY Customer_Name
ORDER BY SUM(Total_Amount) DESC
LIMIT 5;


-- ===============
-- LOCATION ANALYSIS
-- ===============

SELECT State, SUM(Total_Amount)
FROM amazon_clean
GROUP BY State;


-- ==============
-- PAYMENT METHOD
-- ==============

SELECT Payment_Method, COUNT(*)
FROM amazon_clean
GROUP BY Payment_Method;


use amazon_db;

select * from amazon_clean limit 10000;
