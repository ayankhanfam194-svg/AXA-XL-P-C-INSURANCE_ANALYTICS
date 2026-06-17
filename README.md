# PROPERTY & CASUALTY (P&C) INSURANCE DATA ANALYTICS PROJECT
# Project Overview & Business Context

This repository contains a data analytics project modeled around the Property & Casualty (P&C) commercial and personal lines insurance operations of AXA XL.

In global insurance firms like AXA XL, data doesn't sit in a single clean spreadsheet. It is distributed across multiple legacy systems—ranging from policyholder management systems and underwriting logs to transactional sales ledgers and claim history tracking systems. The primary goal of this project was to act as a bridge between this raw relational data and real business strategies.

By building a structured analytics pipeline in SQL, I mapped out how high-risk properties, customer profiles, underwriting exposure, and claims operations interact with each other to impact the company's overall loss ratio.

# 📂 The Data Architecture (What I Worked With)

The core analysis is driven by a simulated 3-year P&C dataset divided into 5 distinct tables that represent standard insurance data warehouses:

AXA_CUSTOMERS: Tracks policyholder demographic data, credit risk profiles, and historical driving license experience.
AXA_AGENT_DETAILS: Maps out the sales distribution channel, sorting active independent brokers and captive agents across distinct territories.
AXA_PROPERTIES_DETAILS: Houses structural asset data, mapping out construction materials and geographic catastrophe risk boundaries.
AXA_POLICY_SALES: The primary transactional engine recording policy bind dates, coverage values (Sum Insured), and premiums collected.
AXA_CLAIM_TABLE: The operational financial ledger containing initial claimed amounts, final approved payouts, and investigative fraud flags.

# 🛠️ Data Challenges & Technical Quality Safeguards
Writing queries for an insurance environment comes with unique data traps. During this project, I ran into and solved several production-level challenges:
Preventing Data Inflation (The Duplication Trap): A major trap in insurance analytics happens when you directly join sales tables with claim tables. Since one policy can have multiple claims over time, a naive join multiplies the sales premium figures, corrupting the final financial reports. I handled this by isolating claim calculations inside Common Table Expressions (CTEs) before making final joins.

Text Formatting & Uniform Matching: Insurance data entered manually by agents often has inconsistent text casing or trailing spaces. I enforced data quality safeguards by wrapping keys in UPPER(TRIM(...)) to guarantee 100% accurate table joins.

Handling Temporal Logic: Tracking active risk windows or flagging early claims (claims filed too close to the policy bind date) required strict date-type casting and absolute gap calculations using PostgreSQL-compatible syntax.

# 📈 Core Business Deliverables (What this Project Achieves)

Instead of just writing basic queries, the SQL scripts in this repository are designed to deliver actionable executive insights across three major areas:

1. Underwriting & Risk Management
Exposure vs Loss Control: Evaluates how total liability exposure compares to historical claim payouts based on property construction types.
Early Loss Auditing: Flags high-risk policies where losses occurred within the first 90 days of binding, serving as an automated check for pre-inspection gaps.
Moral Hazard Analytics: Analyzes if lower financial credit scores show a statistical correlation with confirmed fraudulent claims.

2. Sales & Distribution Channel Performance
Revenue Tracking: Ranks the entire agency network based on final premium generation to reward top brokers.
Channel Activation Audit: Uses optimized outer joins to isolate unproductive agents who haven't written a single policy, allowing sales managers to initiate targeted training or database cleanup.

3. Portfolio & Financial Profiling
Payout Efficiency: Measures overall financial leakages by calculating the claim payout ratio on approved vs requested amounts.
Elite Account Segmentation: Profiles high-value accounts (Sum Insured > 5M) against driver maturity metrics to help actuarial teams refine future premium models.
Project Engineered by: Ayan Iraqui
Domain Focus: P&C Insurance Analytics | Relational Data Modeling | Performance Optimization

Project Engineered by: Moawiz Rahman
Domain Focus: P&C Insurance Analytics | Relational Data Modeling | Performance Optimization | Insurance Analyst | Data Analyst .
