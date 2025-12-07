# Data Warehouse & Analytics Project 🚀
Welcome to the Data Warehouse and Analytics Project repository!  

This project demonstrates the design and implementation of a two-layer SQL Data Warehouse (Bronze & Silver) for a digital subscription business operating multiple acquisition channels. The repository showcases the full analytics workflow from raw data ingestion to exploratory data analysis (EDA), providing actionable insights to inform marketing, retention, and revenue strategies.
 # 🏗️ Data Architecture
 This project applies Medallion Architecture concepts, with two implemented layers (Bronze and Silver) forming the current data warehouse structure.
<img width="684" height="526" alt="Untitled Diagram drawio (1)" src="https://github.com/user-attachments/assets/7953f7ab-9d5d-4aed-9e16-6ee1df3d474e" />

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization,normalization processes to prepare data for analysis and Exploratory Data Analysis.
 ## Project Highlights

- **Data Warehouse Architecture**
  - Bronze layer: raw data ingestion from CSVs
  - Silver layer: cleaned, standardized, and indexed tables ready for analysis
- **Data Sources**
 - Customer records, transactions, marketing campaigns, and activity logs from CRM
- **Data Cleaning & Transformation**
  - Standardization of acquisition channels
  - Duplicate removal
  - Validation and quality checks
- **Exploratory Data Analysis (EDA)**
  - Revenue, cost, and profit trends year-over-year
  - Product category performance (revenue & profit margin)
  - Customer Lifetime Value (CLV) vs Customer Acquisition Cost (CAC) across channels and cohorts
  - Customer behavior analytics: repeat purchases, retention, dormancy, and churn  

