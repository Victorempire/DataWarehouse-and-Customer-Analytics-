/*
===============================================================================
Measures Exploration (Key Metrics) – Revenue, Profit, and Customer Behavior
===============================================================================
Purpose:
    - To analyze key business metrics for actionable insights.
    - Revenue, cost, profit, and profit margin trends over time.
    - Product category performance (revenue & profit margin).
    - Customer Lifetime Value (CLV) vs Customer Acquisition Cost (CAC).
    - Customer purchase behavior and repeat rates.

SQL Functions Used:
    - SUM(), COUNT(), ROUND(), FORMAT(), DATEPART(), CASE(), ROW_NUMBER()
===============================================================================
*/

-- ====================================================================
-- Year-over-Year Revenue, Cost, and Profit Margins
-- ====================================================================
-- Purpose: To track revenue growth, operational costs, and profitability trends annually
SELECT [Year],
       Total_Revenue,
       Operational_Cost,
       (Total_Revenue-Operational_Cost) AS Profit,
       FORMAT(ROUND(CAST((Total_Revenue-Operational_Cost) AS float)/Total_Revenue,3),'P') AS Profit_Margin
FROM (
    SELECT DATEPART(YEAR, transaction_date) AS [Year],
           SUM(transaction_amount_ngn) AS Total_Revenue,
           SUM(cost_to_serve_ngn) AS Operational_Cost
    FROM Silver.crm_transaction
    GROUP BY DATEPART(YEAR, transaction_date)
) T
ORDER BY [Year] ASC;
GO

-- ====================================================================
-- Product Category Revenue and Profit Margin Analysis
-- ====================================================================
-- Purpose: Identify which product categories deliver highest revenue and profit margins
SELECT "Year",
       product_category,
       Total_Revenue,
       ROUND(CAST((Total_Revenue-Operational_Cost) AS float)*100/Total_Revenue,3) AS Profit_Margin
FROM (
    SELECT product_category,
           DATEPART(YEAR, transaction_date) AS "Year",
           SUM(transaction_amount_ngn) AS Total_Revenue,
           SUM(cost_to_serve_ngn) Operational_Cost
    FROM Silver.crm_transaction
    GROUP BY product_category, DATEPART(YEAR, transaction_date)
) t
ORDER BY "Year", Profit_Margin DESC;
GO

-- ====================================================================
-- Customer Lifetime Value (CLV) vs Customer Acquisition Cost (CAC)
-- ====================================================================
-- Purpose: Evaluate profitability per customer by acquisition channel and cohort year
WITH NewCustomer AS (
    SELECT acquisition_channel,
           DATEPART(YEAR, signup_date) AS Cohort_Year,
           COUNT(Customer_id) AS Total_NewCustomer
    FROM Silver.crm_customer
    GROUP BY acquisition_channel, DATEPART(YEAR, signup_date)
),
Campaign_Spend AS (
    SELECT channel AS Acquisition_Channel,
           DATEPART(YEAR, campaign_start_date) AS Cohort_Year,
           SUM(budget_ngn) Total_Mrk_Spend
    FROM Silver.crm_campaign 
    GROUP BY channel, DATEPART(YEAR, campaign_start_date)
),
CAC_PerCustomer AS (
    SELECT NC.acquisition_channel,
           NC.Cohort_Year,
           NC.Total_NewCustomer,
           CS.Total_Mrk_Spend,
           CASE
               WHEN NC.Total_NewCustomer>0 OR CS.Total_Mrk_Spend IS NULL
               THEN CAST(CS.Total_Mrk_Spend AS float)/NC.Total_NewCustomer
               ELSE NULL
           END AS Cost_PerCustomer
    FROM NewCustomer NC
    LEFT JOIN Campaign_Spend CS
    ON NC.Cohort_Year = CS.Cohort_Year
    AND NC.acquisition_channel = CS.Acquisition_Channel
),
CLV AS (
    SELECT NC.acquisition_channel,
           DATEPART(YEAR, NC.signup_date) AS Cohort_Year,
           SUM(t.transaction_amount_ngn) AS Total_Revenue,
           SUM(t.cost_to_serve_ngn) AS Operational_Cost
    FROM Silver.crm_transaction t
    LEFT JOIN Silver.crm_customer NC
    ON t.customer_id = NC.customer_id
    GROUP BY NC.acquisition_channel, DATEPART(YEAR, NC.signup_date)
)
SELECT CAC.acquisition_channel,
       CAC.Cohort_Year,
       CAC.Total_Mrk_Spend,
       CAC.Total_NewCustomer,
       CAC.Cost_PerCustomer,
       (LV.Total_Revenue-LV.Operational_Cost) AS CustomerLifetime_Value,
       ROUND(
           CASE 
               WHEN CAC.Total_Mrk_Spend=0 OR CAC.Total_Mrk_Spend IS NULL THEN NULL        
               ELSE CAST((LV.Total_Revenue-LV.Operational_Cost) AS float)/CAC.Total_Mrk_Spend
           END, 2) AS ROI
FROM CAC_PerCustomer CAC
LEFT JOIN CLV LV
ON CAC.acquisition_channel = LV.acquisition_channel
AND CAC.Cohort_Year = LV.Cohort_Year
ORDER BY Cohort_Year;
GO

-- ====================================================================
-- Customer Purchase Behavior & Repeat Rate Analysis
-- ====================================================================
-- Purpose: Analyze repeat purchase rates across acquisition channels and customer status
WITH Customer_Purchases AS (
    SELECT t.customer_id,
           c.acquisition_channel,
           c."status",
           DATEPART(YEAR, t.transaction_date) AS "Year",
           COUNT(*) AS Purchase_count
    FROM Silver.crm_transaction t
    LEFT JOIN Silver.crm_customer c
    ON c.customer_id = t.customer_id
    GROUP BY t.customer_id, c.acquisition_channel, c."status", DATEPART(YEAR, t.transaction_date)
),
CustomerRepeat_Purchases AS (
    SELECT "Year",
           acquisition_channel,
           "status",
           COUNT(*) AS Total_Customer,
           SUM(CASE WHEN Purchase_count>1 THEN 1 ELSE 0 END) AS Repeat_Customer
    FROM Customer_Purchases
    GROUP BY "Year", acquisition_channel, "status"
)
SELECT "YEAR",
       acquisition_channel,
       "status",
       ROUND(CAST(Repeat_Customer AS float)*100/Total_Customer,2) AS Repeat_Rate
FROM CustomerRepeat_Purchases
ORDER BY "Year";
GO
