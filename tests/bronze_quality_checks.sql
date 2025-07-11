-- ====================================================================
-- Checking 'bronze.crm_cust_info'
-- ====================================================================
-- Total # of customers
SELECT COUNT(*) FROM bronze.crm_cust_info;

-- # of NULLs or Duplicates in Primary Key
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for data consistency
SELECT cst_gndr, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_gndr;

SELECT cst_marital_status, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_marital_status;

-- ====================================================================
-- Checking 'bronze.crm_prd_info'
-- ====================================================================
-- Total # of products
SELECT COUNT(*) FROM bronze.crm_prd_info;

-- # of NULLs or Duplicates in Primary Key
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- # of unwanted spaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- # of nulls or negative numbers
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check for data consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

SELECT prd_line, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_line;

-- # of invalid date orders (Start date > End Date)
SELECT COUNT(*)
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'bronze.crm_sales_details'
-- ====================================================================
-- Total # of sales transactions
SELECT COUNT(*) FROM bronze.crm_sales_details;

-- Check for unwanted spaces
SELECT COUNT(*)
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

SELECT COUNT(*)
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

-- Check quality of product key from bronze product info
SELECT COUNT(*)
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM bronze.crm_prd_info);

SELECT COUNT(*)
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM bronze.crm_cust_info);

-- Check for invalid dates
SELECT 
    NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
    OR LEN(sls_order_dt) != 8
    OR sls_order_dt > 20500101
    OR sls_order_dt < 19000101;

SELECT 
    NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
    OR LEN(sls_ship_dt) != 8
    OR sls_ship_dt > 20500101
    OR sls_ship_dt < 19000101;

SELECT 
    NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Check for invalid dates orders (Order date > Shipping/Due dates)
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt;

-- Check for data consistency in sales, price, and quantity
SELECT COUNT(*) AS invalid_rows
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL 
    OR sls_quantity IS NULL 
    OR sls_price IS NULL
    OR sls_sales <= 0 
    OR sls_quantity <= 0 
    OR sls_price <= 0;

-- ====================================================================
-- Checking 'bronze.erp_cust_az12'
-- ====================================================================
-- Check invalid date, data type, or out of range dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT COUNT(*)
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Check for data consistency
SELECT gen, COUNT(*)
FROM bronze.erp_cust_az12
GROUP BY gen;

-- ====================================================================
-- Checking 'bronze.erp_loc_a101'
-- ====================================================================
-- Unique countries
SELECT COUNT(DISTINCT cntry) FROM bronze.erp_loc_a101;

-- Check for data consistency
SELECT cntry, COUNT(*)
FROM bronze.erp_loc_a101
GROUP BY cntry;

-- ====================================================================
-- Checking 'bronze.erp_px_cat_g1v2'
-- ====================================================================
-- Total # of ERP customers
SELECT COUNT(*) FROM bronze.erp_cust_az12;

-- Check for unwanted spaces
SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
    OR subcat != TRIM(subcat) 
    OR maintenance != TRIM(maintenance);

-- Check for data consistency
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;

-- ====================================================================
-- Checking 'bronze.erp_px_cat_g1v2'
-- ====================================================================
-- Total product categories
SELECT COUNT(DISTINCT cat) FROM bronze.erp_px_cat_g1v2;

-- Check for unwanted spaces
SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
    OR subcat != TRIM(subcat) 
    OR maintenance != TRIM(maintenance);

-- Check for data consistency
SELECT cat, COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY cat;

SELECT maintenance, COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY maintenance;