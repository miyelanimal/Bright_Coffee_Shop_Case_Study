SELECT*
FROM workspace.default.bright_coffee
LIMIT 5;

SELECT COUNT(*)
FROM workspace.default.bright_coffee;

------------------------------------
1.Checking date and time range
------------------------------------

SELECT  MIN(transaction_date) AS start_date, 
        MAX(transaction_date) AS finish_date,
        MIN(DATE_FORMAT(transaction_time, 'HH:mm:ss')) AS open_time, 
        MAX(DATE_FORMAT(transaction_time, 'HH:mm:ss')) AS close_time
FROM workspace.default.bright_coffee;



-- finish date 2023-06-30
-- start date 2023-01-01
-- duration 6 months
-- ealiest time (open time) 06:00:00
-- latest time (closing time) 20:59:32

---------------------------------------------------
2. Checking names of the store location
---------------------------------------------------

SELECT DISTINCT store_location
FROM workspace.default.bright_coffee;

SELECT COUNT(DISTINCT store_id) AS number_of_stores
FROM workspace.default.bright_coffee;

---- we have 3 store locations. Lower Manhattan, Hell's Kitchen Astoria

---------------------------------------------------
3. Checking for the products sold across all stores
---------------------------------------------------
SELECT DISTINCT product_category
FROM workspace.default.bright_coffee;

SELECT DISTINCT product_type
FROM workspace.default.bright_coffee;

SELECT DISTINCT product_detail
FROM workspace.default.bright_coffee;

SELECT DISTINCT product_category AS Category,
                product_type AS Type,
                product_detail AS Name
FROM workspace.default.bright_coffee
---------------------------------------------------
4. Checking for customer behavior, product prices, transactions and revenue
---------------------------------------------------


SELECT SUM(transaction_qty*unit_price) AS total_revenue
FROM workspace.default.bright_coffee;

SELECT SUM(transaction_qty) AS total_transaction
FROM workspace.default.bright_coffee;

SELECT COUNT(DISTINCT transaction_id) AS customer
FROM workspace.default.bright_coffee;

SELECT MIN(unit_price) AS lowest_cost_item
FROM workspace.default.bright_coffee;

SELECT MAX(unit_price) AS highest_cost_item
FROM workspace.default.bright_coffee;

SELECT  MIN(transaction_qty) AS minimum_transaction,
        MAX(transaction_qty) AS maximum_transaction,
        AVG(transaction_qty) AS average_transaction
FROM workspace.default.bright_coffee;

SELECT  MIN(transaction_qty*unit_price) AS minimum_spend,
        MAX(transaction_qty*unit_price) AS muximum_spend,
        AVG(transaction_qty*unit_price) AS average_spend
FROM workspace.default.bright_coffee;

-- total revenue 698812
-- total transactions 214470
-- total custombers 149116 
-- average transactions per customer 1.4
-- lowest item cost 0.8
-- highest item cost 45
-- minimun transaction 1
-- maximun transactions 8
-- minimum spend 0.8
-- muximum spend 360
-- average spend 4.69
-- over a period of 6 months

-------------------------------------------------------
5. main code
-------------------------------------------------------

SELECT*
FROM workspace.default.bright_coffee
LIMIT 5;

SELECT  
        transaction_id,

-- Dates
        transaction_date AS purchanse_date,
        DAYNAME(transaction_date) AS day_name,
        MONTHNAME(transaction_date) AS month_name,
        DAYOFMONTH(transaction_date) AS day_of_month,


SELECT

-- Day classification

        CASE
            WHEN DAYNAME(transaction_date) IN ('Saturday', 'Sunday') THEN '02. Weekend'
            ELSE '01. Weekday'
        END AS day_classification,

-- Time
        DATE_FORMAT(transaction_time, 'HH:mm:ss') AS transaction_time,

-- Time buckets
        CASE 
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '07:59:59' THEN '01. Early_Morning'
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '08:00:00' AND '11:59:59' THEN '02. Morning_Peak'
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '16:00:00' AND '18:59:59' THEN '04. Late_Afternoon'
            ELSE '05. Evening'
        END AS time_classification,

-- Transaction size
        CASE 
            WHEN transaction_qty BETWEEN 1 AND 2 THEN '01. Small Order'
            WHEN transaction_qty BETWEEN 3 AND 4 THEN '02. Medium Order'
            ELSE '03. Large Order'
        END AS transaction_size,


-- Added outcome columns
        product_id,
        transaction_qty,
        unit_price,
-- Revenue
        SUM(transaction_qty * unit_price) AS revenue,
        
 -- Spend buckets
      CASE
        WHEN SUM(transaction_qty * unit_price) < 120 THEN '01. Low Spend'
        WHEN SUM(transaction_qty * unit_price) BETWEEN 120 AND 240 THEN '02. Average Spend'
        ELSE '03. High Spend'
    END AS spend_bucket,

-- Counts
        COUNT(DISTINCT transaction_id) AS number_of_sales,

-- sales volume
      CASE
        WHEN SUM(transaction_qty) BETWEEN 1 AND 2 THEN '01. Low Volume'
        WHEN SUM(transaction_qty) BETWEEN 3 AND 5 THEN '02. Medium Volume'
        ELSE '03. High Volume'
    END AS sales_volume,

-- Store
        store_location,

        product_category,
        product_type,
        product_detail

FROM workspace.default.bright_coffee

GROUP BY  
        transaction_id,
        transaction_date,
        DAYNAME(transaction_date),
        MONTHNAME(transaction_date),
        DAYOFMONTH(transaction_date),
        CASE
            WHEN DAYNAME(transaction_date) IN ('Saturday', 'Sunday') THEN '02. Weekend'
            ELSE '01. Weekday'
        END,
        DATE_FORMAT(transaction_time, 'HH:mm:ss'),
        CASE 
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '07:59:59' THEN '01. Early_Morning'
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '08:00:00' AND '11:59:59' THEN '02. Morning_Peak'
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
            WHEN DATE_FORMAT(transaction_time, 'HH:mm:ss') BETWEEN '16:00:00' AND '18:59:59' THEN '04. Late_Afternoon'
            ELSE '05. Evening'
        END,
        CASE 
            WHEN transaction_qty BETWEEN 1 AND 2 THEN '01. Small Order'
            WHEN transaction_qty BETWEEN 3 AND 4 THEN '02. Medium Order'
            ELSE '03. Large Order'
        END,
        transaction_qty,
        unit_price,
        product_id,
        product_category,
        product_type,
        product_detail,
        store_location;
