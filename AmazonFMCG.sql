SELECT * FROM Amazon_FMCG

-- Q.1 What is the central Data Tendency capacity size of the warehouse?
SELECT WH_capacity_size, COUNT (*) as size_count
FROM Amazon_FMCG
GROUP BY WH_capacity_size
ORDER BY size_count;


-- Q.2 How many warehouse are located in urban areas versus rural areas?
SELECT Location_type, COUNT (*) as type_count
FROM Amazon_FMCG
GROUP BY Location_type
ORDER BY type_count;


-- Q.3 What is the total number of retail shops served by each zone?
SELECT zone, SUM(retail_shop_num) as total_retail_shop
FROM Amazon_FMCG
GROUP BY zone
ORDER BY total_retail_shop;


-- Q.4 Calculate the average number of workers per warehouse.
SELECT WH_regional_zone, ROUND(AVG(workers_num), 2) as Avg_workers
FROM Amazon_FMCG
GROUP BY WH_regional_zone
ORDER BY Avg_workers;


-- could also be performed by ware house capacity size
SELECT WH_capacity_size, ROUND(AVG(workers_num), 2) as Avg_workers
FROM Amazon_FMCG
GROUP BY WH_capacity_size
ORDER BY Avg_workers;


-- Q.5 Determine the percentage of warehouse with electric supply.
WITH WarehouseStats AS (
    SELECT COUNT(*) AS total_warehouses, SUM(CAST(electric_supply AS INT)) AS warehouses_with_electric_supply
    FROM Amazon_FMCG)
SELECT total_warehouses, warehouses_with_electric_supply, (CAST(warehouses_with_electric_supply AS FLOAT) / total_warehouses) * 100 AS percentage_with_electric_supply
FROM WarehouseStats;


-- Q.6 What is the average distance of warehouses zone & regional zones from the central distribution hub?
SELECT zone, WH_regional_zone, ROUND(AVG(dist_from_hub), 2) AS Avg_dist
FROM Amazon_FMCG
GROUP BY zone, WH_regional_zone
ORDER BY zone, WH_regional_zone;


-- Q.7 How many warehouses have reported storage issues in the last 3 months zone & regional zones also showcase the percentage?
-- Count total warehouses and warehouses with storage issues for each zone and regional zone
WITH WarehouseCounts AS (
    SELECT 
        zone, 
        WH_regional_zone,
        COUNT(*) AS total_warehouses,
        SUM(CASE WHEN storage_issue_reported_l3m > 0 THEN 1 ELSE 0 END) AS warehouses_with_issues
    FROM 
        Amazon_FMCG
    GROUP BY 
        zone, 
        WH_regional_zone
)
-- Calculate the percentage of warehouses with issues
SELECT 
    zone, 
    WH_regional_zone,
    total_warehouses,
    warehouses_with_issues,
    (CAST(warehouses_with_issues AS FLOAT) / total_warehouses) * 100 AS percentage_with_issues
FROM 
    WarehouseCounts;


-- Q.8 Identify the top 3 zones with the highest number of refill requests in the last 3 months.
SELECT TOP 3 WH_regional_zone, SUM(num_refill_req_l3m) AS total_numrefill
FROM Amazon_FMCG
GROUP BY WH_regional_zone
ORDER BY total_numrefill DESC;


-- Q.9 Calculate the average number of government checks per zone & regional zones in the last 3 months.
SELECT zone, WH_regional_zone, ROUND(AVG(govt_check_l3m), 2) AS Avg_govtcheck
FROM Amazon_FMCG
GROUP BY zone, WH_regional_zone
ORDER BY Avg_govtcheck DESC;


-- Q.10 Determine the most common type of government certification among warehouses.
SELECT approved_wh_govt_certificate, COUNT (*) AS counts
FROM Amazon_FMCG  
WHERE approved_wh_govt_certificate IS NOT NULL
GROUP BY approved_wh_govt_certificate
ORDER BY counts;


-- Q.11 What is the correlation between the number of workers and the number of reported storage issues in the last 3 months?
WITH Avgvalues AS (SELECT AVG(CAST(workers_num AS FLOAT)) AS avg_workers,
AVG(CAST(storage_issue_reported_l3m AS FLOAT)) AS avg_issues
FROM Amazon_FMCG), 

Covariance AS (SELECT SUM((CAST(workers_num AS FLOAT) - avg_workers) * (CAST(storage_issue_reported_l3m AS FLOAT) - avg_issues)) AS covariance,
SUM(POWER(CAST(workers_num AS FLOAT) - avg_workers, 2)) AS variance_workers,
SUM(POWER(CAST(storage_issue_reported_l3m AS FLOAT) - avg_issues, 2)) AS variance_issues
FROM Amazon_FMCG, Avgvalues)

SELECT covariance / SQRT(variance_workers * variance_issues) AS correlation 
FROM Covariance;


--Q.12 Calculate the average product weight per ton for warehouses that have temperature regulation machinery.
SELECT ROUND(AVG(CAST(product_wg_ton AS FLOAT)), 2) AS Avg_wg
FROM Amazon_FMCG
WHERE temp_reg_mach = 1;


