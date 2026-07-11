-- ============================================================
-- PROJECT: Sales Data SQL Analysis
-- Prepared By: Rajat Gautam — MIS Analyst
-- Company: Infomarp, Agra
-- Date: July 2026
-- Description: SQL queries to analyze sales, returns, and 
--              customer complaint data for business insights
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS sales_analysis;
USE sales_analysis;

-- Create Sales Table
CREATE TABLE IF NOT EXISTS sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    month VARCHAR(20),
    region VARCHAR(20),
    product VARCHAR(20),
    sales_rep VARCHAR(30),
    units_sold INT,
    revenue INT,
    returns INT,
    complaints INT
);


-- ============================================================
-- SECTION 2: BASIC DATA EXPLORATION
-- ============================================================

-- Q1: View all data
SELECT * FROM sales;

-- Q2: How many total records do we have?
SELECT COUNT(*) AS total_records FROM sales;

-- Q3: What are the unique regions?
SELECT DISTINCT region FROM sales;

-- Q4: What are the unique products?
SELECT DISTINCT product FROM sales;


-- ============================================================
-- SECTION 3: SALES PERFORMANCE ANALYSIS
-- ============================================================

-- Q5: Total revenue generated overall
SELECT 
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units,
    SUM(returns) AS total_returns,
    SUM(complaints) AS total_complaints
FROM sales;

-- Q6: Monthly revenue trend (which month performed best?)
SELECT 
    month,
    SUM(units_sold) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(returns) AS total_returns
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- Q7: Top 3 months by revenue
SELECT 
    month,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 3;

-- Q8: Worst performing month
SELECT 
    month,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue ASC
LIMIT 1;


-- ============================================================
-- SECTION 4: REGION-WISE ANALYSIS
-- ============================================================

-- Q9: Revenue by region
SELECT 
    region,
    SUM(units_sold) AS total_units,
    SUM(revenue) AS total_revenue,
    ROUND((SUM(returns)/SUM(units_sold))*100, 2) AS return_rate_pct
FROM sales
GROUP BY region
ORDER BY total_revenue DESC;

-- Q10: Best performing region
SELECT 
    region,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY region
ORDER BY total_revenue DESC
LIMIT 1;

-- Q11: Region with highest return rate (problem area!)
SELECT 
    region,
    ROUND((SUM(returns)/SUM(units_sold))*100, 2) AS return_rate_pct
FROM sales
GROUP BY region
ORDER BY return_rate_pct DESC
LIMIT 1;


-- ============================================================
-- SECTION 5: PRODUCT ANALYSIS
-- ============================================================

-- Q12: Revenue by product
SELECT 
    product,
    SUM(units_sold) AS total_units,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY product
ORDER BY total_revenue DESC;

-- Q13: Product with highest returns (quality issue?)
SELECT 
    product,
    SUM(returns) AS total_returns,
    ROUND((SUM(returns)/SUM(units_sold))*100, 2) AS return_rate_pct
FROM sales
GROUP BY product
ORDER BY return_rate_pct DESC;


-- ============================================================
-- SECTION 6: SALES REP PERFORMANCE
-- ============================================================

-- Q14: Performance by sales rep
SELECT 
    sales_rep,
    SUM(units_sold) AS total_units,
    SUM(revenue) AS total_revenue,
    SUM(complaints) AS total_complaints
FROM sales
GROUP BY sales_rep
ORDER BY total_revenue DESC;

-- Q15: Top performing sales rep
SELECT 
    sales_rep,
    SUM(revenue) AS total_revenue
FROM sales
GROUP BY sales_rep
ORDER BY total_revenue DESC
LIMIT 1;

-- Q16: Sales rep with most complaints (needs attention!)
SELECT 
    sales_rep,
    SUM(complaints) AS total_complaints
FROM sales
GROUP BY sales_rep
ORDER BY total_complaints DESC
LIMIT 1;


-- ============================================================
-- SECTION 7: BUSINESS INSIGHTS FOR MANAGEMENT REPORT
-- ============================================================

-- Q17: Months where return rate was above 5% (alert!)
SELECT 
    month,
    SUM(units_sold) AS total_units,
    SUM(returns) AS total_returns,
    ROUND((SUM(returns)/SUM(units_sold))*100, 2) AS return_rate_pct
FROM sales
GROUP BY month
HAVING return_rate_pct > 5
ORDER BY return_rate_pct DESC;

-- Q18: Revenue vs Returns correlation by region
SELECT 
    region,
    SUM(revenue) AS total_revenue,
    SUM(returns) AS total_returns,
    SUM(complaints) AS total_complaints,
    ROUND((SUM(complaints)/SUM(units_sold))*100, 2) AS complaint_rate_pct
FROM sales
GROUP BY region;

-- Q19: Quarter-wise performance (Q1: Jan-Mar, Q2: Apr-Jun, etc.)
SELECT 
    CASE 
        WHEN month IN ('Jan 2024','Feb 2024','Mar 2024') THEN 'Q1 2024'
        WHEN month IN ('Apr 2024','May 2024','Jun 2024') THEN 'Q2 2024'
        WHEN month IN ('Jul 2024','Aug 2024','Sep 2024') THEN 'Q3 2024'
        WHEN month IN ('Oct 2024','Nov 2024','Dec 2024') THEN 'Q4 2024'
    END AS quarter,
    SUM(revenue) AS total_revenue,
    SUM(units_sold) AS total_units
FROM sales
GROUP BY quarter
ORDER BY quarter;

-- Q20: Final executive summary report
SELECT 
    'Total Revenue' AS metric, CONCAT('₹', FORMAT(SUM(revenue),0)) AS value FROM sales
UNION ALL
SELECT 'Total Units Sold', FORMAT(SUM(units_sold),0) FROM sales
UNION ALL
SELECT 'Total Returns', FORMAT(SUM(returns),0) FROM sales
UNION ALL
SELECT 'Overall Return Rate', CONCAT(ROUND((SUM(returns)/SUM(units_sold))*100,2), '%') FROM sales
UNION ALL
SELECT 'Total Complaints', FORMAT(SUM(complaints),0) FROM sales;

-- ============================================================
-- END OF SQL ANALYSIS PROJECT
-- Prepared by: Rajat Gautam | MIS Analyst | Infomarp, Agra
-- ============================================================
