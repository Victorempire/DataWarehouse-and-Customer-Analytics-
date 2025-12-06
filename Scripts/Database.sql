/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up two schemas 
    within the database: 'bronze', and 'silver'
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/
USE master;
GO
-- Drop and recreate the 'DataWarehouse' database
IF DB_ID('Datawarehouse') IS NULL
    CREATE DATABASE Datawarehouse;
GO
USE Datawarehouse;
GO
---Create Schemas
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name='Bronze')   
    EXEC('CREATE SCHEMA Bronze');
IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name='Silver')   
    EXEC('CREATE SCHEMA Silver');
