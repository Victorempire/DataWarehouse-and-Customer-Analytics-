/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
IF OBJECT_ID('Bronze.crm_customer','U') IS NOT NULL DROP TABLE Bronze.crm_customer;
CREATE TABLE Bronze.crm_customer (
    customer_id NVARCHAR(100),
    signup_date DATETIME NULL,
    customer_segment NVARCHAR(100) NULL,
    region NVARCHAR(100) NULL,
    "status" NVARCHAR(100) NULL,
    lifetime_months_expected INT NULL,
    acquisition_channel NVARCHAR(100) NULL,
    acquisition_campaign NVARCHAR(100) NULL,
    acquisition_cost_ngn  INT NULL
);
GO

IF OBJECT_ID('Bronze.crm_transactions','U') IS NOT NULL DROP TABLE Bronze.crm_transactions;
CREATE TABLE Bronze.crm_transactions (
    transaction_id VARCHAR(50) ,
	transaction_date DATETIME NULL,
    customer_id VARCHAR(50),
    date_id INT NULL,
    product_category VARCHAR(100) NULL,
    payment_method VARCHAR(50) NULL,
    transaction_amount_ngn DECIMAL(18,2) NULL,
    cost_to_serve_ngn DECIMAL(18,2) NULL,
    is_first_month_purchase INT NULL
);
GO

IF OBJECT_ID('Bronze.crm_activity','U') IS NOT NULL DROP TABLE Bronze.crm_activity;
CREATE TABLE Bronze.crm_activity (
	activity_id VARCHAR(50) ,
    activity_type VARCHAR(50) NULL,
    activity_value VARCHAR(255) NULL,
    channel VARCHAR(100) NULL,
    customer_id VARCHAR(50) NULL,
    activity_date DATE NULL
);
GO

IF OBJECT_ID('Bronze.crm_campaign','U') IS NOT NULL DROP TABLE Bronze.crm_campaign;
CREATE TABLE Bronze.crm_campaign (
  campaign_id VARCHAR(50) NULL,
    campaign_name VARCHAR(255) NULL,
    channel VARCHAR(100) NULL,
    campaign_start_date DATE NULL,
    campaign_end_date DATE NULL,
    budget_ngn DECIMAL(18,2) NULL,
    leads_generated INT NULL,
    new_customers_acquired INT NULL
);
GO

/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Purpose:
    This stored procedure loads data into the 'Bronze' schema from external CSV files. 
    It performs the following actions:
      - Truncates the Bronze tables before loading new data.
      - Uses `BULK INSERT` to load data from CSV files into the Bronze tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage:
    EXEC Bronze.Load_Bronze;

Notes:
    - Ensure CSV files are accessible at the specified file paths.
    - Running this procedure will overwrite existing Bronze data.
===============================================================================
*/
CREATE PROCEDURE Bronze.Bronze_load AS
BEGIN
	BULK INSERT Bronze.crm_customer
	FROM'C:\Users\VICTOR\Desktop\Savy SQL\dim_customer.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	GO

	BULK INSERT Bronze.crm_transactions
	FROM'C:\Users\VICTOR\Desktop\Savy SQL\fact_transactions.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	GO

	BULK INSERT Bronze.crm_activity
	FROM'C:\Users\VICTOR\Desktop\Savy SQL\dim_activity.csv'
	WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
	);
	GO

	BULK INSERT Bronze.crm_campaign
	FROM'C:\Users\VICTOR\Desktop\Savy SQL\dim_campaign.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	GO
END 


