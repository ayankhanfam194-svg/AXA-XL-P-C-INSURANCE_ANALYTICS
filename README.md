# Property & Casualty (P&C) Insurance Data Analytics Project

# Project Context: AXA XL Insurance Domain Analytics

This project is built around a simulated 3-year real-world dataset inspired by AXA XL, focusing on Property & Casualty (P&C) insurance.

In insurance MNCs, data analysts and risk teams work closely with databases to catch premium leaks, monitor agent sales, check credit risks, and flag suspicious claims. To do this analysis properly, the data is divided into 5 clear tables:

AXA_CUSTOMERS: Policyholder profiles, ages, credit scores, and driving experience.
AXA_AGENT_DETAILS: Details of insurance agents, their types, and the regions they manage.
AXA_PROPERTIES_DETAILS: Structural data of the insured properties, building materials, and their geographic risk zones.
AXA_POLICY_SALES: The main sales ledger that shows when a policy was bought, the sum insured, base premium, and current status.
AXA_CLAIM_TABLE: The claims history recording how much was claimed, how much got approved, and fraud flags.

Technical Approach & SQL Best Practices
While writing these queries, I focused heavily on data accuracy and optimization. In insurance databases, a common mistake is "data inflation" (where joining sales and claims tables duplicates data and gives wrong financial totals).

To solve this and write clean, production-ready code, I used:
Common Table Expressions (CTEs) & Subqueries to handle complex steps and keep aggregations separate.
Window Functions (DENSE_RANK, COUNT OVER) for ranking and tracking patterns over time.
Data Formatting Safeties like UPPER and TRIM to fix case-sensitivity or trailing spaces in text columns, plus proper date casting.

# # #  Business KPIs & Insights Tracked

KPI 1: Customer Demographics vs Premium Distribution
What it does: Breaks down average premiums and total sum insured by gender and marital status to see which customer groups hold the highest liability for the company.

KPI 2: Agent Sales Ranking
What it does: Groups and ranks all agents based on the total premium revenue they have generated, sorted from highest to lowest.

KPI 3: Property Material and Claims Exposure
What it does: Combines property data with settled claims. It uses a CTE to avoid double-counting, showing the exact asset exposure vs actual claim payouts for each construction material.

KPI 4: Claim Payout Ratio Analysis
What it does: Finds the financial efficiency of claim settlements by calculating (Total Approved Amount / Total Claimed Amount) * 100 for all settled claims.

KPI 5: Policy Active Days (Aging)
What it does: Calculates the exact number of days a policy has been active from its bind date up to the current day, which helps teams identify policies coming up for renewal.

KPI 6: Early Claims Audit (First 90 Days)
What it does: Flags policies where a claim was filed within the first 90 days of buying the insurance. This helps underwriters look for bad risk-selection or skipped inspections.

KPI 7: Credit Score vs Claim Fraud
What it does: Groups customer credit scores into brackets (<600, 600-750, >750) using a CASE WHEN statement and counts the total number of flagged fraud cases in each bracket.

KPI 8: Identifying Unproductive Agents
What it does: Uses a LEFT JOIN between the agent master list and sales table to pull out agents who haven't made a single sale yet, helping regional managers plan training.

KPI 9: High-Loss Geographic Risk Zones
What it does: Pinpoints which geographic risk zones have generated the highest total claim payouts, giving data-driven insights to adjust pricing in high-risk locations.

KPI 10: Driving Experience in High-Value Policies
What it does: Isolates large, high-value accounts (where Sum Insured is over 5,000,000) and finds the average driving experience of those customers to help model future high-end products.

Project by: MOAWIZ RAHMAN
Focus Areas: Insurance Analytics, SQL Query Optimization, Risk & Claims Analysis.
