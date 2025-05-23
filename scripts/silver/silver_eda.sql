-- EXEC bronze.load_bronze_proc

SELECT TOP 1000 * FROM bronze.crm_cust_info;
SELECT TOP 1000 * FROM bronze.crm_prd_info;
SELECT TOP 1000 * FROM bronze.crm_sales_details;

SELECT TOP 1000 * FROM bronze.erp_cust_az12;
SELECT TOP 1000 * FROM bronze.erp_px_cat_g1v2;
SELECT TOP 1000 * FROM bronze.erp_loc_a101;

-- Check for nulls or duplicates in primary key
-- Expectation: no result
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
-- Expectation: no result
-- Repeat for string features
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for data consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;

/*
Data Quality Check - crm_prod_info table
*/

-- Check for nulls or duplicates in primary key
-- Expectation: no result
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces
-- Expectation: no result
-- Repeat for string features
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for nulls or negative numbers
-- Expectation: No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check for data consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for invalid date orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT * FROM silver.crm_prd_info;