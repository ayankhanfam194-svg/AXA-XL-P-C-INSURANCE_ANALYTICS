-- ====================================================================================
-- PROPERTY & CASUALTY (P&C) INSURANCE PORTFOLIO CORE METRICS
-- Target Database: PostgreSQL / Standard Enterprise SQL
-- Author: Moawiz Rahman
-- Domain: Underwriting, Claims Fraud, and Agency Performance Analytics
-- ====================================================================================

-- ------------------------------------------------------------------------------------
-- KPI 1: Customer Demographics vs Risk Premium Distribution
-- INSIGHT: Evaluates how average premium costs and exposure (Sum Insured) are spread 
-- across different gender and marital status groups to detect underpriced segments.
-- ------------------------------------------------------------------------------------
SELECT 
    CUS.Gender, 
    CUS.Marital_Status, 
    CAST(AVG(SALE.Final_Premium) AS INT) AS Average_Premium,
    SUM(SALE.Sum_Insured) AS Total_Sum_Insured
FROM AXA_POLICY_SALES SALE
INNER JOIN AXA_CUSTOMERS CUS
    ON SALE.Customer_ID = CUS.Customer_ID 
GROUP BY CUS.Gender, CUS.Marital_Status
ORDER BY Total_Sum_Insured DESC;


-- ------------------------------------------------------------------------------------
-- KPI 2: Distribution Channel & Agent Revenue Performance Ranking
-- INSIGHT: Ranks insurance agents and sales brokers based on total revenue generation 
-- to reward top performers and allocate strategic corporate support.
-- ------------------------------------------------------------------------------------
SELECT 
    AGEN.Agent_ID, 
    AGEN.Agent_Name, 
    SUM(SALE.Final_Premium) AS Final_Premium_Generated
FROM AXA_POLICY_SALES SALE
INNER JOIN AXA_AGENT_DETAILS AGEN 
    ON SALE.Agent_ID = AGEN.Agent_ID 
GROUP BY AGEN.Agent_ID, AGEN.Agent_Name
ORDER BY Final_Premium_Generated DESC;


-- ------------------------------------------------------------------------------------
-- KPI 3: Portfolio Exposure & High-Risk Property Material Vulnerability
-- INSIGHT: Tracks total asset exposure vs actual historical claims payouts grouped by 
-- building materials to find high-risk structural vulnerabilities.
-- ------------------------------------------------------------------------------------
WITH Total_Approved_Amount AS (
    SELECT 
        Policy_ID, 
        SUM(Approved_Amount) AS Total_Approved_Claim
    FROM AXA_CLAIM_TABLE
    WHERE UPPER(TRIM(Claim_Status)) = 'SETTLED'
    GROUP BY Policy_ID
)
SELECT 
    PROP.Construction_Material, 
    ROUND(SUM(SALE.Sum_Insured), 2) AS Total_Sum_Insured,
    ROUND(SUM(COALESCE(CLAIM.Total_Approved_Claim, 0)), 2) AS Total_Approved_Claim
FROM AXA_PROPERTIES_DETAILS PROP
INNER JOIN AXA_POLICY_SALES SALE
    ON PROP.Property_ID = SALE.Property_ID
LEFT JOIN Total_Approved_Amount CLAIM
    ON SALE.Policy_ID = CLAIM.Policy_ID			
GROUP BY PROP.Construction_Material
ORDER BY Total_Sum_Insured DESC;


-- ------------------------------------------------------------------------------------
-- KPI 4: Underwriting Loss Control & Claim Payout Ratio Analysis
-- INSIGHT: Computes the proportion of approved claim amounts against total demanded sums, 
-- focusing only on approved/settled cases to measure payout efficiency.
-- ------------------------------------------------------------------------------------
SELECT 
    ROUND((SUM(Approved_Amount) / SUM(Claimed_Amount)) * 100, 2) AS Claim_Payout_Ratio
FROM AXA_CLAIM_TABLE
WHERE UPPER(TRIM(Claim_Status)) IN ('APPROVED', 'SETTLED');


-- ------------------------------------------------------------------------------------
-- KPI 5: Policy Lifecycle & Operational Aging Tracking
-- INSIGHT: Measures the total active risk exposure duration (in days) since inception 
-- to assess policy execution and renewal lifecycles.
-- ------------------------------------------------------------------------------------
SELECT 
    Policy_ID, 
    Policy_Bind_Date, 
    ABS(POLICY_BIND_DATE::date - CURRENT_DATE) AS Days_Active
FROM AXA_POLICY_SALES
WHERE UPPER(TRIM(Policy_Status)) = 'ACTIVE';


-- ------------------------------------------------------------------------------------
-- KPI 6: Early Claim Detection & Anti-Selection Risk Auditing (First 90 Days)
-- INSIGHT: Flags policies experiencing critical claims within 90 days of binding, 
-- highlighting potential anti-selection issues or gaps in pre-inspection.
-- ------------------------------------------------------------------------------------
SELECT 
    SALE.Policy_ID, 
    SALE.Policy_Bind_Date, 
    CLAIM.Claim_Date, 
    ABS(SALE.Policy_Bind_Date::date - CLAIM.Claim_Date::date) AS Claim_Days_Gap
FROM AXA_POLICY_SALES SALE
INNER JOIN AXA_CLAIM_TABLE CLAIM
    ON SALE.Policy_ID = CLAIM.Policy_ID
WHERE ABS(SALE.Policy_Bind_Date::date - CLAIM.Claim_Date::date) <= 90;


-- ------------------------------------------------------------------------------------
-- KPI 7: Underwriting Risk Correlation - Financial Credit Score vs Fraud Incidence
-- INSIGHT: Cross-analyzes customer credit profiles with confirmed fraudulent claims 
-- to check if weak financial metrics correlate with moral hazard.
-- ------------------------------------------------------------------------------------
WITH CTE_Unique_Fraud_Customers AS (
    SELECT DISTINCT 
        SALE.Customer_ID
    FROM AXA_POLICY_SALES SALE
    INNER JOIN AXA_CLAIM_TABLE CLM 
        ON SALE.Policy_ID = CLM.Policy_ID
    WHERE CLM.Fraud_Flag = 1
)
SELECT 
    CASE 
        WHEN CUST.Credit_Score < 600 THEN 'Low Credit Score (<600)'
        WHEN CUST.Credit_Score BETWEEN 600 AND 750 THEN 'Medium Credit Score (600-750)'
        WHEN CUST.Credit_Score > 750 THEN 'High Credit Score (>750)'
        ELSE 'Unknown/Missing'
    END AS Credit_Score_Bracket, 
    COUNT(FRD.Customer_ID) AS Total_Fraud_Cases
FROM AXA_CUSTOMERS CUST
INNER JOIN CTE_Unique_Fraud_Customers FRD 
    ON CUST.Customer_ID = FRD.Customer_ID
GROUP BY 
    CASE 
        WHEN CUST.Credit_Score < 600 THEN 'Low Credit Score (<600)'
        WHEN CUST.Credit_Score BETWEEN 600 AND 750 THEN 'Medium Credit Score (600-750)'
        WHEN CUST.Credit_Score > 750 THEN 'High Credit Score (>750)'
        ELSE 'Unknown/Missing'
    END
ORDER BY Total_Fraud_Cases DESC;


-- ------------------------------------------------------------------------------------
-- KPI 8: Sales Activation Audit - Identification of Unproductive Onboarded Agents
-- INSIGHT: Detects registered agents with zero sales conversions using a LEFT JOIN, 
-- assisting regional managers in executing training or operational cleanup.
-- ------------------------------------------------------------------------------------
SELECT 
    AGEN.Agent_ID, 
    AGEN.Agent_Name,
    AGEN.Agent_Type,
    AGEN.Region
FROM AXA_AGENT_DETAILS AGEN
LEFT JOIN AXA_POLICY_SALES SALE
    ON AGEN.Agent_ID = SALE.Agent_ID 
WHERE SALE.Agent_ID IS NULL
ORDER BY AGEN.Agent_Name ASC; 


-- ------------------------------------------------------------------------------------
-- KPI 9: Catastrophe Management - High Severity Loss Risk Zones
-- INSIGHT: pinpoints the absolute highest loss-causing geographical locations by tracking 
-- consolidated financial payout aggregates to modify future location risk models.
-- ------------------------------------------------------------------------------------
SELECT 
    PROP.Geographic_Risk_Zone, 
    ROUND(SUM(CLM.Approved_Amount), 0) AS Total_Approved_Claims,
    COUNT(CLM.Claim_ID) AS Total_Claims_Count
FROM AXA_PROPERTIES_DETAILS PROP
INNER JOIN AXA_POLICY_SALES SALE 
    ON PROP.Property_ID = SALE.Property_ID 
INNER JOIN AXA_CLAIM_TABLE CLM 
    ON SALE.Policy_ID = CLM.Policy_ID       
WHERE UPPER(TRIM(CLM.Claim_Status)) IN ('APPROVED', 'SETTLED') 
GROUP BY PROP.Geographic_Risk_Zone
ORDER BY Total_Approved_Claims DESC;


-- ------------------------------------------------------------------------------------
-- KPI 10: High-Value Risk Analysis - Demographics of Elite Account Sellers
-- INSIGHT: Extracts the average operational driving experience of policyholders who 
-- secure elite asset coverage (Sum Insured > 5,000,000) for underwriting profile modeling.
-- ------------------------------------------------------------------------------------
SELECT 
    ROUND(AVG(CUST.Driving_License_Years), 1) AS Avg_Driving_License_Years,
    COUNT(SALE.Policy_ID) AS Total_High_Value_Policies
FROM AXA_POLICY_SALES SALE
INNER JOIN AXA_CUSTOMERS CUST
    ON CUST.Customer_ID = SALE.Customer_ID
WHERE SALE.Sum_Insured > 5000000;
